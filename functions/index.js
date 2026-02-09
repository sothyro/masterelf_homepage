import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineString } from "firebase-functions/params";

initializeApp();
const db = getFirestore();

// PlasGate credentials – set via Firebase config or Secret Manager
const plasgatePrivateKey = defineString("PLASGATE_PRIVATE_KEY", { default: "" });
const plasgateSecret = defineString("PLASGATE_SECRET", { default: "" });
const SMS_SENDER = "MasterElf";

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
  const privateKey = plasgatePrivateKey.value();
  const secret = plasgateSecret.value();
  if (!privateKey || !secret) {
    console.warn("PlasGate credentials not set; skipping SMS.");
    return { ok: false, reason: "config" };
  }
  const toDigits = to.replace(/\D/g, "");
  const url = `https://cloudapi.plasgate.com/rest/send?private_key=${encodeURIComponent(privateKey)}`;
  const res = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-Secret": secret,
    },
    body: JSON.stringify({
      sender: SMS_SENDER,
      to: toDigits,
      content,
    }),
  });
  if (!res.ok) {
    const text = await res.text();
    console.error("PlasGate error:", res.status, text);
    return { ok: false, status: res.status, body: text };
  }
  return { ok: true };
}

/**
 * Firestore trigger: when an appointment is created, send SMS via PlasGate and update doc.
 */
export const onAppointmentCreated = onDocumentCreated(
  { document: `${APPOINTMENTS}/{docId}` },
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const docId = event.params.docId;
    const data = snap.data();
    const ref = snap.ref;
    const name = data.name || "";
    const phone = data.phone || "";
    const serviceName = data.serviceName || "Consultation";
    const date = data.date || "";
    const time = data.time || "";
    const bookingRef = data.bookingReference || docId.slice(-6).toUpperCase();

    const content = `Master Elf: Your consultation (${serviceName}) is confirmed on ${date} at ${time}. Ref: ${bookingRef}.`;
    const result = await sendPlasGateSms(phone, content);

    await ref.update({
      smsSentAt: result.ok ? new Date() : null,
      smsStatus: result.ok ? "sent" : "failed",
    });
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
  const dayStart = new Date(dateStr + "T00:00:00Z");
  const dayEnd = new Date(dateStr + "T23:59:59Z");
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

  // Business hours 09:00–17:00 local (adjust as needed); slot length 2h, break 30min
  const slots = [];
  const slotDurationMs = SESSION_DURATION_MINUTES * 60 * 1000;
  const breakMs = BREAK_AFTER_MINUTES * 60 * 1000;
  let t = new Date(dayStart);
  t.setUTCHours(9, 0, 0, 0);
  const closeHour = 17;

  while (t.getUTCHours() < closeHour || (t.getUTCHours() === closeHour && t.getUTCMinutes() === 0)) {
    const slotEnd = new Date(t.getTime() + slotDurationMs);
    const overlaps = occupied.some(
      (o) => t < o.end && slotEnd > o.start
    );
    if (!overlaps) {
      const h = t.getUTCHours();
      const m = t.getUTCMinutes();
      slots.push(
        `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}`
      );
    }
    t = new Date(slotEnd.getTime() + breakMs);
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
