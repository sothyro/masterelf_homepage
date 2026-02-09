import { initializeApp } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";

initializeApp();
const db = getFirestore();

// PlasGate credentials – set via firebase functions:secrets:set
const plasgatePrivateKey = defineSecret("PLASGATE_PRIVATE_KEY");
const plasgateSecret = defineSecret("PLASGATE_SECRET");
const SMS_SENDER = "PlasGateUAT";

const APPOINTMENTS = "appointments";
const SESSION_DURATION_MINUTES = 120;
const BREAK_AFTER_MINUTES = 30;

/**
 * Normalize phone to E.164 (digits only, Cambodia 855).
 */
function normalizePhone(phone) {
  const digits = String(phone).replace(/\D/g, "");
  if (digits.startsWith("855")) return digits;
  if (digits.startsWith("0")) return "855" + digits.slice(1);
  if (digits.length >= 9) return "855" + digits;
  return digits;
}

/**
 * Send SMS via PlasGate REST API.
 * POST https://cloudapi.plasgate.com/rest/send?private_key=... 
 * Header: X-Secret: ...
 * Body: { sender, to, content }
 */
async function sendPlasGateSms(to, content) {
  try {
    const privateKey = plasgatePrivateKey.value();
    const secret = plasgateSecret.value();
    
    console.log(`sendPlasGateSms: Checking credentials - privateKey exists: ${!!privateKey}, secret exists: ${!!secret}`);
    
    if (!privateKey || !secret) {
      console.warn("PlasGate credentials not set; skipping SMS. Use 'firebase functions:secrets:set PLASGATE_PRIVATE_KEY' and 'firebase functions:secrets:set PLASGATE_SECRET'");
      return { ok: false, reason: "config" };
    }
    
    const toDigits = to.replace(/\D/g, "");
    console.log(`sendPlasGateSms: Normalized phone number: ${to} -> ${toDigits}`);
    
    const url = `https://cloudapi.plasgate.com/rest/send?private_key=${encodeURIComponent(privateKey)}`;
    console.log(`sendPlasGateSms: Calling PlasGate API: ${url.substring(0, 50)}...`);
    
    const requestBody = {
      sender: SMS_SENDER,
      to: toDigits,
      content,
    };
    console.log(`sendPlasGateSms: Request body:`, JSON.stringify({ ...requestBody, content: content.substring(0, 50) + "..." }));
    
    const res = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Secret": secret,
      },
      body: JSON.stringify(requestBody),
    });
    
    console.log(`sendPlasGateSms: Response status: ${res.status}`);
    
    const responseText = await res.text();
    console.log(`sendPlasGateSms: Response body: ${responseText}`);
    
    // Parse response to check for actual success/error
    let responseData;
    try {
      responseData = JSON.parse(responseText);
    } catch (e) {
      // Not JSON, treat as plain text
      responseData = { message: responseText };
    }
    
    // Check if response indicates an error even with 2xx status
    if (!res.ok || (res.status === 203 && responseData.message && responseData.message.includes("Non-Authoritative"))) {
      console.error("PlasGate error:", res.status, responseText);
      return { 
        ok: false, 
        status: res.status, 
        body: responseText,
        parsed: responseData 
      };
    }
    
    // Check for error messages in response
    if (responseData.error || responseData.status === "error" || (responseData.message && responseData.message.toLowerCase().includes("error"))) {
      console.error("PlasGate API returned error in response:", responseData);
      return { 
        ok: false, 
        status: res.status, 
        body: responseText,
        parsed: responseData,
        reason: "api_error"
      };
    }
    
    console.log(`sendPlasGateSms: Success! Response: ${JSON.stringify(responseData)}`);
    return { ok: true, response: responseText, parsed: responseData };
  } catch (error) {
    console.error("sendPlasGateSms: Exception:", error);
    return { ok: false, reason: "exception", error: error.message || String(error) };
  }
}

/**
 * Firestore trigger: when an appointment is created, send SMS via PlasGate and update doc.
 */
export const onAppointmentCreated = onDocumentCreated(
  { document: `${APPOINTMENTS}/{docId}`, secrets: [plasgatePrivateKey, plasgateSecret] },
  async (event) => {
    const snap = event.data;
    if (!snap) {
      console.warn("onAppointmentCreated: No snapshot data");
      return;
    }
    
    const docId = event.params.docId;
    const data = snap.data();
    const ref = snap.ref;
    const name = data.name || "";
    const phone = data.phone || "";
    const serviceName = data.serviceName || "Consultation";
    const date = data.date || "";
    const time = data.time || "";
    const bookingRef = data.bookingReference || docId.slice(-6).toUpperCase();

    console.log(`onAppointmentCreated: Processing appointment ${docId} for phone ${phone}`);

    try {
      const content = `Master Elf: Your consultation (${serviceName}) is confirmed on ${date} at ${time}. Ref: ${bookingRef}.`;
      console.log(`onAppointmentCreated: Sending SMS to ${phone} with content: ${content.substring(0, 50)}...`);
      
      const result = await sendPlasGateSms(phone, content);
      
      console.log(`onAppointmentCreated: SMS result:`, JSON.stringify(result));

      const updateData = {
        smsSentAt: result.ok ? Timestamp.now() : null,
        smsStatus: result.ok ? "sent" : "failed",
      };
      
      if (!result.ok && result.reason) {
        updateData.smsErrorReason = result.reason;
      }
      if (!result.ok && result.status) {
        updateData.smsErrorStatus = result.status;
      }
      if (!result.ok && result.body) {
        updateData.smsErrorBody = result.body.substring(0, 200); // Limit error body length
      }
      if (!result.ok && result.parsed) {
        updateData.smsErrorParsed = result.parsed;
      }

      await ref.update(updateData);
      console.log(`onAppointmentCreated: Updated document ${docId} with SMS status: ${updateData.smsStatus}`);
    } catch (error) {
      console.error(`onAppointmentCreated: Error processing appointment ${docId}:`, error);
      try {
        await ref.update({
          smsStatus: "error",
          smsError: error.message || String(error),
        });
      } catch (updateError) {
        console.error(`onAppointmentCreated: Failed to update document with error status:`, updateError);
      }
    }
  }
);

/**
 * Callable: get available slot start times for a given date.
 * Returns array of "HH:mm" strings (2h session, 30min break between).
 */
export const getAvailableSlots = onCall(async (request) => {
  const dateStr = request.data?.date;
  if (!dateStr || typeof dateStr !== "string") {
    throw new HttpsError("invalid-argument", "date is required (YYYY-MM-DD)");
  }
  // Cambodia (UTC+7): date YYYY-MM-DD = 2025-02-08 17:00 UTC to 2025-02-10 16:59:59 UTC
  const CAMBODIA_OFFSET_MS = 7 * 60 * 60 * 1000;
  const dayStart = new Date(new Date(dateStr + "T00:00:00Z").getTime() - CAMBODIA_OFFSET_MS);
  const dayEnd = new Date(dayStart.getTime() + 24 * 60 * 60 * 1000 - 1);
  if (isNaN(dayStart.getTime())) {
    throw new HttpsError("invalid-argument", "Invalid date format");
  }

  const snapshot = await db
    .collection(APPOINTMENTS)
    .where("startTime", ">=", dayStart)
    .where("startTime", "<=", dayEnd)
    .where("status", "in", ["pending", "confirmed"])
    .get();

  const occupied = snapshot.docs.map((d) => {
    const d_ = d.data();
    return {
      start: d_.startTime?.toDate?.() ?? new Date(0),
      end: d_.endTime?.toDate?.() ?? new Date(0),
    };
  });

  // Business hours 09:00–17:00 Cambodia (UTC+7); slot length 2h, break 30min
  const slots = [];
  const slotDurationMs = SESSION_DURATION_MINUTES * 60 * 1000;

  // Iterate slot starts in Cambodia local time: 09:00, 11:30, 14:00, ...
  let hour = 9, minute = 0;
  const closeHour = 17;

  while (hour < closeHour || (hour === closeHour && minute === 0)) {
    // Create UTC time for this slot in Cambodia: "YYYY-MM-DD HH:mm" Cambodia = UTC - 7h
    const localDate = new Date(dateStr + "T00:00:00.000Z");
    const slotStartUtc = new Date(
      localDate.getTime() + (hour * 60 + minute) * 60 * 1000 - CAMBODIA_OFFSET_MS
    );
    const slotEndUtc = new Date(slotStartUtc.getTime() + slotDurationMs);

    const overlaps = occupied.some(
      (o) => slotStartUtc < o.end && slotEndUtc > o.start
    );
    if (!overlaps) {
      slots.push(
        `${String(hour).padStart(2, "0")}:${String(minute).padStart(2, "0")}`
      );
    }

    // Next slot: +2h + 30min
    minute += 30;
    hour += Math.floor(minute / 60);
    minute %= 60;
    hour += 2;
  }

  return { slots };
});

/**
 * Callable: get appointments for a phone number (normalized).
 */
export const getMyBookings = onCall(async (request) => {
  const phone = request.data?.phone;
  if (!phone || typeof phone !== "string") {
    throw new HttpsError("invalid-argument", "phone is required");
  }
  const normalized = normalizePhone(phone);
  const snapshot = await db
    .collection(APPOINTMENTS)
    .where("phone", "==", normalized)
    .orderBy("startTime", "desc")
    .limit(50)
    .get();

  const list = snapshot.docs.map((doc) => {
    const d = doc.data();
    const start = d.startTime?.toDate?.();
    return {
      id: doc.id,
      bookingReference: d.bookingReference || doc.id.slice(-6).toUpperCase(),
      serviceName: d.serviceName,
      date: d.date,
      time: d.time,
      startTime: start ? start.toISOString() : null,
      status: d.status,
    };
  });
  return { bookings: list };
});

/**
 * Callable: cancel an appointment (verify phone matches).
 */
export const cancelBooking = onCall(async (request) => {
  const { appointmentId, phone } = request.data || {};
  if (!appointmentId || !phone) {
    throw new HttpsError("invalid-argument", "appointmentId and phone are required");
  }
  const ref = db.collection(APPOINTMENTS).doc(appointmentId);
  const doc = await ref.get();
  if (!doc.exists) {
    throw new HttpsError("not-found", "Appointment not found");
  }
  const normalized = normalizePhone(phone);
  if (doc.data().phone !== normalized) {
    throw new HttpsError("permission-denied", "Phone does not match this booking");
  }
  if (doc.data().status === "cancelled") {
    return { ok: true, message: "Already cancelled" };
  }
  await ref.update({ status: "cancelled" });
  return { ok: true };
});
