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
const adminSmsPhone = defineSecret("ADMIN_SMS_PHONE");
const SMS_SENDER = "MasterElf";

const APPOINTMENTS = "appointments";
const SESSION_DURATION_MINUTES = 120;
const BREAK_AFTER_MINUTES = 60;  // 1 hour between sessions
const BUSINESS_OPEN_HOUR = 9;
const BUSINESS_CLOSE_HOUR = 22;  // Slots up to 21:00 (special: 1h or 2h to 23:00)

const PLASGATE_API_URL = "https://cloudapi.plasgate.com/rest/send";
const MIN_PHONE_DIGITS = 9; // Cambodia local number length without country code
const SMS_RETRY_DELAY_MS = 2000;
/** Master Elf business line – receives SMS on every new booking. */
const MASTER_ELF_SMS_PHONE = "85512222211";

/**
 * Normalize phone to E.164 (digits only, Cambodia 855).
 */
function normalizePhone(phone) {
  const digits = String(phone || "").replace(/\D/g, "");
  if (digits.startsWith("855")) return digits;
  if (digits.startsWith("0")) return "855" + digits.slice(1);
  if (digits.length >= MIN_PHONE_DIGITS) return "855" + digits;
  return digits;
}

/**
 * Validate that normalized phone is suitable for PlasGate (Cambodia 855 + 8–9 digits).
 */
function isValidE164Phone(normalized) {
  if (!normalized || typeof normalized !== "string") return false;
  const digits = normalized.replace(/\D/g, "");
  return digits.startsWith("855") && digits.length >= 11 && digits.length <= 15;
}

/**
 * Send one request to PlasGate REST API.
 * POST https://cloudapi.plasgate.com/rest/send?private_key=...
 * Header: X-Secret: ...
 * Body: { sender, to, content }
 */
async function sendPlasGateSmsRequest(privateKey, secret, toE164, content) {
  const url = `${PLASGATE_API_URL}?private_key=${encodeURIComponent(privateKey)}`;
  const res = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-Secret": secret,
    },
    body: JSON.stringify({
      sender: SMS_SENDER,
      to: toE164,
      content,
    }),
  });
  const responseText = await res.text();
  let parsed;
  try {
    parsed = JSON.parse(responseText);
  } catch {
    parsed = { message: responseText };
  }
  return { ok: res.ok, status: res.status, body: responseText, parsed };
}

/**
 * Send SMS via PlasGate REST API with validation, normalization, and one retry on 5xx/network.
 */
async function sendPlasGateSms(to, content) {
  try {
    const privateKey = plasgatePrivateKey.value();
    const secret = plasgateSecret.value();

    if (!privateKey || !secret) {
      console.warn("PlasGate credentials not set; skipping SMS. Set PLASGATE_PRIVATE_KEY and PLASGATE_SECRET via Firebase secrets.");
      return { ok: false, reason: "config" };
    }

    const toE164 = normalizePhone(to);
    if (!isValidE164Phone(toE164)) {
      const masked = toE164 ? `${toE164.slice(0, 5)}***${toE164.slice(-2)}` : "(empty)";
      console.warn(`sendPlasGateSms: Invalid phone (normalized=${masked}, length=${(toE164 || "").replace(/\D/g, "").length})`);
      return { ok: false, reason: "invalid_phone", toE164 };
    }

    if (!content || typeof content !== "string" || content.trim().length === 0) {
      return { ok: false, reason: "empty_content" };
    }

    const trimmedContent = content.trim();
    console.log(`sendPlasGateSms: Sending to ${toE164}, content length: ${trimmedContent.length}`);

    let result = await sendPlasGateSmsRequest(privateKey, secret, toE164, trimmedContent);

    // Retry once on 5xx or network-related failure
    if (!result.ok && (result.status >= 500 || result.status === 0)) {
      console.log(`sendPlasGateSms: Retrying after ${SMS_RETRY_DELAY_MS}ms...`);
      await new Promise((r) => setTimeout(r, SMS_RETRY_DELAY_MS));
      result = await sendPlasGateSmsRequest(privateKey, secret, toE164, trimmedContent);
    }

    if (!result.ok) {
      console.error("PlasGate error:", result.status, result.body);
      return {
        ok: false,
        status: result.status,
        body: result.body,
        parsed: result.parsed,
        reason: "api_error",
      };
    }

    const errLike = result.parsed?.error
      || result.parsed?.status === "error"
      || result.parsed?.status === "failed"
      || (result.parsed?.message && String(result.parsed.message).toLowerCase().includes("error"));
    if (errLike) {
      console.error("PlasGate API error in response:", result.parsed);
      return {
        ok: false,
        status: result.status,
        body: result.body,
        parsed: result.parsed,
        reason: "api_error",
      };
    }

    console.log("sendPlasGateSms: Success.", result.parsed ? JSON.stringify(result.parsed) : result.body);
    return { ok: true, response: result.body, parsed: result.parsed };
  } catch (error) {
    console.error("sendPlasGateSms: Exception:", error);
    return { ok: false, reason: "exception", error: error.message || String(error) };
  }
}

/**
 * Firestore trigger: when an appointment is created, send SMS via PlasGate and update doc.
 * Runs for both: (1) customer booking from the app, (2) admin booking from the dashboard (on behalf of client).
 * Both flows write a new document to `appointments` via submitAppointmentBooking → same trigger.
 */
export const onAppointmentCreated = onDocumentCreated(
  { document: `${APPOINTMENTS}/{docId}`, secrets: [plasgatePrivateKey, plasgateSecret, adminSmsPhone] },
  async (event) => {
    const docId = event.params?.docId ?? "(unknown)";
    console.log(`onAppointmentCreated: Triggered for document ${docId}`);
    const snap = event.data;
    if (!snap) {
      console.warn("onAppointmentCreated: No snapshot data");
      return;
    }
    const data = snap.data();
    const ref = snap.ref;
    const name = data.name || "";
    const rawPhone = data.phone || "";
    const phone = normalizePhone(rawPhone);
    const serviceName = data.serviceName || "Consultation";
    const sessionType = data.sessionType || "VISIT";
    const date = data.date || "";
    const time = data.time || "";
    const bookingRef = data.bookingReference || docId.slice(-6).toUpperCase();

    console.log(`onAppointmentCreated: Processing appointment ${docId} for phone ${phone || "(empty)"}`);

    const sessionLabel = sessionType === "ONLINE" ? "Online" : "In-person visit";
    // Admin & Master Elf: Khmer notice + Ref (Master Hong Chhayheng: New appointment, confirm with client 1h before)
    const adminMasterElfContent = `ម៉ាស្ទ័រ ហុង ឆាយហេង៖ ការណាត់ថ្មី ឈ្មោះ ${name}។ ដើម្បីមើល ${serviceName} នៅថ្ងៃ ${date} ម៉ោង ${time}។ សូមបញ្ជាក់ជាមួយភ្ញៀវមុនពេលជួប ១ម៉ោងមុន! Ref: ${bookingRef}.`;

    try {
      // 1. Customer SMS (only if valid phone)
      let updateData;
      if (!isValidE164Phone(phone)) {
        await ref.update({
          smsStatus: "skipped",
          smsErrorReason: "invalid_phone",
        });
        console.warn(`onAppointmentCreated: Skipped customer SMS for ${docId} - invalid or missing phone`);
        updateData = { smsStatus: "skipped", smsErrorReason: "invalid_phone" };
      } else {
        const content = `ម៉ាស្ទ័រ ហុង ឆាយហេង៖ ការណាត់ជួបបានកក់ដោយជោគជ័យ  ដើម្បីមើល (${serviceName}, ${sessionLabel}) បងជួបលោកគ្រូនៅថ្ងៃ ${date} ម៉ោង ${time}។ សូមមានលាភមានជ័យ! Ref: ${bookingRef}.`;
        console.log(`onAppointmentCreated: Sending customer SMS to ${phone}, content length: ${content.length}`);
        const result = await sendPlasGateSms(phone, content);
        console.log(`onAppointmentCreated: Customer SMS result:`, JSON.stringify(result));
        updateData = {
          smsSentAt: result.ok ? Timestamp.now() : null,
          smsStatus: result.ok ? "sent" : "failed",
        };
        if (!result.ok && result.reason) updateData.smsErrorReason = result.reason;
        if (!result.ok && result.status) updateData.smsErrorStatus = result.status;
        if (!result.ok && result.body) updateData.smsErrorBody = (result.body || "").substring(0, 200);
        if (!result.ok && result.reason === "config") {
          updateData.smsErrorBody = "PlasGate credentials not set. Set PLASGATE_PRIVATE_KEY and PLASGATE_SECRET in Firebase secrets.";
        }
        if (!result.ok && result.parsed) updateData.smsErrorParsed = result.parsed;
        await ref.update(updateData);
        console.log(`onAppointmentCreated: Updated document ${docId} with SMS status: ${updateData.smsStatus}`);
      }

      // 2. Admin SMS – every booking (admin phone from secret).
      try {
        const adminPhoneRaw = adminSmsPhone.value();
        const adminPhone = typeof adminPhoneRaw === "string" ? adminPhoneRaw.trim() : "";
        if (adminPhone && isValidE164Phone(normalizePhone(adminPhone))) {
          const adminResult = await sendPlasGateSms(adminPhone, adminMasterElfContent);
          if (adminResult.ok) {
            console.log(`onAppointmentCreated: Admin SMS sent for ${docId}`);
          } else {
            console.warn(`onAppointmentCreated: Admin SMS failed for ${docId}:`, adminResult.reason || adminResult.body);
          }
        } else {
          console.log(`onAppointmentCreated: ADMIN_SMS_PHONE not set or invalid; skipping admin SMS`);
        }
      } catch (adminErr) {
        console.warn(`onAppointmentCreated: Admin SMS error (non-fatal):`, adminErr);
      }

      // 3. Master Elf SMS – every booking (fixed business number).
      try {
        const masterElfResult = await sendPlasGateSms(MASTER_ELF_SMS_PHONE, adminMasterElfContent);
        if (masterElfResult.ok) {
          console.log(`onAppointmentCreated: Master Elf SMS sent for ${docId}`);
        } else {
          console.warn(`onAppointmentCreated: Master Elf SMS failed for ${docId}:`, masterElfResult.reason || masterElfResult.body);
        }
      } catch (masterErr) {
        console.warn(`onAppointmentCreated: Master Elf SMS error (non-fatal):`, masterErr);
      }
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
 * Returns array of "HH:mm" strings (2h session, 1h break between).
 * Business hours: 09:00–20:00 Cambodia time.
 */
export const getAvailableSlots = onCall(async (request) => {
  const dateStr = request.data?.date;
  if (!dateStr || typeof dateStr !== "string") {
    throw new HttpsError("invalid-argument", "date is required (YYYY-MM-DD)");
  }
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

  // Business hours 09:00–20:00 Cambodia; slot 2h, break 1h → 09:00, 12:00, 15:00, 18:00
  const slots = [];
  const slotDurationMs = SESSION_DURATION_MINUTES * 60 * 1000;
  let hour = BUSINESS_OPEN_HOUR;
  let minute = 0;

  while (hour < BUSINESS_CLOSE_HOUR || (hour === BUSINESS_CLOSE_HOUR && minute === 0)) {
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

    // Next slot: +2h session + 1h break = +3h
    hour += Math.floor(SESSION_DURATION_MINUTES / 60) + Math.floor(BREAK_AFTER_MINUTES / 60);
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
      sessionType: d.sessionType || "VISIT",
      notes: d.notes || "",
    };
  });
  return { bookings: list };
});

/**
 * Callable: get all appointments (admin only - requires authenticated user).
 */
export const getAllAppointments = onCall(async (request) => {
  try {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "You must be logged in to access the dashboard.");
    }
    const { status: statusFilter, limit: limitParam } = request.data || {};
    const limit = Math.min(Math.max(limitParam || 100, 1), 500);

    let snapshot;
    try {
      snapshot = await db
        .collection(APPOINTMENTS)
        .orderBy("startTime", "desc")
        .limit(limit * 2)
        .get();
    } catch (queryError) {
      // Fallback: startTime query may fail (missing index or field); fetch without order
      console.warn("getAllAppointments: startTime query failed:", queryError.message);
      snapshot = await db.collection(APPOINTMENTS).limit(limit * 2).get();
    }

    let list = snapshot.docs.map((doc) => {
      const d = doc.data();
      const start = d.startTime?.toDate?.();
      return {
        id: doc.id,
        name: d.name || "",
        phone: d.phone || "",
        bookingReference: d.bookingReference || doc.id.slice(-6).toUpperCase(),
        serviceName: d.serviceName || "",
        serviceId: d.serviceId || "",
        date: d.date || "",
        time: d.time || "",
        startTime: start ? start.toISOString() : null,
        status: d.status || "pending",
        sessionType: d.sessionType || "VISIT",
        notes: d.notes || "",
        createdAt: d.createdAt?.toDate?.()?.toISOString?.() || null,
        smsStatus: d.smsStatus || null,
        smsErrorReason: d.smsErrorReason || null,
        smsErrorBody: d.smsErrorBody || null,
      };
    });
    // Sort by startTime desc in memory (handles unordered fetch)
    list.sort((a, b) => {
      const aVal = a.startTime ? new Date(a.startTime).getTime() : 0;
      const bVal = b.startTime ? new Date(b.startTime).getTime() : 0;
      return bVal - aVal;
    });
    if (statusFilter && ["pending", "confirmed", "cancelled", "completed"].includes(statusFilter)) {
      list = list.filter((a) => a.status === statusFilter);
    }
    return { appointments: list.slice(0, limit) };
  } catch (err) {
    if (err instanceof HttpsError) throw err;
    console.error("getAllAppointments error:", err);
    throw new HttpsError("internal", err.message || "Failed to load appointments");
  }
});

/**
 * Parse date (YYYY-MM-DD) and time (HH:mm) to Date in Cambodia timezone.
 */
function parseDateTime(dateStr, timeStr) {
  if (!dateStr || !timeStr || typeof dateStr !== "string" || typeof timeStr !== "string") {
    return null;
  }
  const [h, m] = timeStr.split(":").map((x) => parseInt(x, 10) || 0);
  const CAMBODIA_OFFSET_MS = 7 * 60 * 60 * 1000;
  const localDate = new Date(dateStr + "T00:00:00.000Z");
  const slotStartUtc = new Date(
    localDate.getTime() + (h * 60 + m) * 60 * 1000 - CAMBODIA_OFFSET_MS
  );
  return isNaN(slotStartUtc.getTime()) ? null : slotStartUtc;
}

/**
 * Callable: update appointment date and time (admin only).
 */
export const updateAppointment = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "You must be logged in to update appointments.");
  }
  const { appointmentId, date, time } = request.data || {};
  if (!appointmentId || !date || !time) {
    throw new HttpsError("invalid-argument", "appointmentId, date, and time are required");
  }
  const ref = db.collection(APPOINTMENTS).doc(appointmentId);
  const doc = await ref.get();
  if (!doc.exists) {
    throw new HttpsError("not-found", "Appointment not found");
  }
  const startDate = parseDateTime(date, time);
  if (!startDate) {
    throw new HttpsError("invalid-argument", "Invalid date or time format (use YYYY-MM-DD and HH:mm)");
  }
  const duration = doc.data().durationMinutes ?? SESSION_DURATION_MINUTES;
  const endDate = new Date(startDate.getTime() + duration * 60 * 1000);
  await ref.update({
    date,
    time,
    startTime: Timestamp.fromDate(startDate),
    endTime: Timestamp.fromDate(endDate),
  });
  return { ok: true };
});

/**
 * Callable: update appointment status (admin only).
 */
export const updateAppointmentStatus = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "You must be logged in to update appointments.");
  }
  const { appointmentId, status } = request.data || {};
  if (!appointmentId || !status) {
    throw new HttpsError("invalid-argument", "appointmentId and status are required");
  }
  if (!["pending", "confirmed", "cancelled", "completed"].includes(status)) {
    throw new HttpsError("invalid-argument", "status must be pending, confirmed, cancelled, or completed");
  }
  const ref = db.collection(APPOINTMENTS).doc(appointmentId);
  const doc = await ref.get();
  if (!doc.exists) {
    throw new HttpsError("not-found", "Appointment not found");
  }
  await ref.update({ status });
  return { ok: true };
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

/**
 * Callable: send a test SMS via PlasGate (authenticated users only).
 * Use to verify PlasGate credentials after setting secrets.
 * Body: { phone: "855..." or "0...", message?: "Optional custom text" }
 */
export const sendTestSms = onCall(
  { secrets: [plasgatePrivateKey, plasgateSecret] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "You must be logged in to send a test SMS.");
    }
    const phone = request.data?.phone;
    const message = typeof request.data?.message === "string" ? request.data.message.trim() : null;
    if (!phone || typeof phone !== "string") {
      throw new HttpsError("invalid-argument", "phone is required");
    }
    const toE164 = normalizePhone(phone);
    if (!isValidE164Phone(toE164)) {
      throw new HttpsError("invalid-argument", "Invalid phone number. Use format 855XXXXXXXX or 0XXXXXXXX.");
    }
    const content = message && message.length > 0 ? message : `Master Elf: Test SMS at ${new Date().toISOString()}. PlasGate OK.`;
    const result = await sendPlasGateSms(toE164, content);
    if (!result.ok) {
      throw new HttpsError(
        "internal",
        result.reason === "config"
          ? "PlasGate credentials not set. Run: firebase functions:secrets:set PLASGATE_PRIVATE_KEY and PLASGATE_SECRET."
          : result.body || result.error || "SMS send failed"
      );
    }
    return { ok: true, message: "SMS sent successfully" };
  }
);

// ---------------------------------------------------------------------------
// Contact form submissions
// ---------------------------------------------------------------------------
const CONTACT_SUBMISSIONS = "contact_submissions";

// Optional: notify team by email when a contact form is submitted (Resend).
const resendApiKey = defineSecret("RESEND_API_KEY");
const contactNotifyEmail = defineSecret("CONTACT_NOTIFY_EMAIL");

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MAX_NAME = 200;
const MAX_EMAIL = 200;
const MAX_PHONE = 50;
const MAX_MESSAGE = 5000;

/**
 * Callable: submit contact form. Writes to Firestore contact_submissions.
 * No auth required. Validates name, email, message, subjectIndex (0-5).
 */
export const submitContactForm = onCall(async (request) => {
  const data = request.data || {};
  const name = typeof data.name === "string" ? data.name.trim() : "";
  const email = typeof data.email === "string" ? data.email.trim() : "";
  const phone = typeof data.phone === "string" ? data.phone.trim() : "";
  const message = typeof data.message === "string" ? data.message.trim() : "";
  const subjectIndex = typeof data.subjectIndex === "number" ? data.subjectIndex : 0;
  const subjectLabel = typeof data.subjectLabel === "string" ? data.subjectLabel.trim() : "";

  if (!name || name.length > MAX_NAME) {
    throw new HttpsError("invalid-argument", "Name is required and must be at most " + MAX_NAME + " characters.");
  }
  if (!email || email.length > MAX_EMAIL) {
    throw new HttpsError("invalid-argument", "Email is required and must be at most " + MAX_EMAIL + " characters.");
  }
  if (!EMAIL_REGEX.test(email)) {
    throw new HttpsError("invalid-argument", "Invalid email format.");
  }
  if (!message || message.length > MAX_MESSAGE) {
    throw new HttpsError("invalid-argument", "Message is required and must be at most " + MAX_MESSAGE + " characters.");
  }
  const safeSubjectIndex = Math.max(0, Math.min(5, Math.floor(subjectIndex)));

  const doc = {
    name,
    email,
    phone: phone || null,
    subjectIndex: safeSubjectIndex,
    subjectLabel: subjectLabel || "",
    message,
    status: "new",
    createdAt: Timestamp.now(),
  };

  const ref = await db.collection(CONTACT_SUBMISSIONS).add(doc);
  console.log("submitContactForm: created", ref.id);
  return { success: true, id: ref.id };
});

/**
 * Firestore trigger: when a contact form is submitted, optionally email the team.
 * Set secrets RESEND_API_KEY and CONTACT_NOTIFY_EMAIL to enable. Otherwise only logs.
 */
// Brand colors for email (match app theme)
const EMAIL_ACCENT = "#C9A227";
const EMAIL_DARK = "#1A1A1A";
const EMAIL_BG = "#F5F5F5";
const EMAIL_TEXT = "#333333";
const EMAIL_MUTED = "#666666";

function buildContactNotificationHtml(submission) {
  const name = escapeHtml(submission.name);
  const email = escapeHtml(submission.email);
  const phone = submission.phone ? escapeHtml(submission.phone) : null;
  const subject = submission.subjectLabel ? escapeHtml(submission.subjectLabel) : null;
  const message = escapeHtml(submission.message).replace(/\n/g, "<br>");

  const row = (label, value) =>
    value != null && value !== ""
      ? `
    <tr>
      <td style="padding:10px 16px 10px 0;vertical-align:top;width:100px;font-weight:600;color:${EMAIL_MUTED};font-size:13px;font-family:sans-serif;">${label}</td>
      <td style="padding:10px 0;vertical-align:top;font-size:14px;color:${EMAIL_TEXT};font-family:sans-serif;">${value}</td>
    </tr>`
      : "";

  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>New contact submission</title>
</head>
<body style="margin:0;padding:0;background-color:${EMAIL_BG};font-family:sans-serif;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color:${EMAIL_BG};">
    <tr>
      <td style="padding:32px 24px;">
        <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="max-width:560px;margin:0 auto;background:#ffffff;border-radius:12px;box-shadow:0 4px 24px rgba(0,0,0,0.08);overflow:hidden;">
          <!-- Header -->
          <tr>
            <td style="background:linear-gradient(135deg, ${EMAIL_DARK} 0%, #2a2a2a 100%);padding:24px 28px;text-align:left;">
              <span style="font-size:11px;letter-spacing:0.12em;text-transform:uppercase;color:${EMAIL_ACCENT};font-weight:600;">Master Elf Feng Shui</span>
              <h1 style="margin:8px 0 0;font-size:22px;font-weight:700;color:#ffffff;letter-spacing:-0.02em;">New contact form submission</h1>
              <p style="margin:6px 0 0;font-size:13px;color:rgba(255,255,255,0.75);">Someone reached out via your website.</p>
            </td>
          </tr>
          <!-- Subject badge (if present) -->
          ${subject ? `
          <tr>
            <td style="padding:16px 28px 0;">
              <span style="display:inline-block;padding:6px 12px;background:${EMAIL_ACCENT};color:#1a1a1a;font-size:12px;font-weight:600;border-radius:6px;">${subject}</span>
            </td>
          </tr>` : ""}
          <!-- Details table -->
          <tr>
            <td style="padding:24px 28px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="border-collapse:collapse;">
                ${row("Name", name)}
                ${row("Email", email)}
                ${row("Phone", phone)}
                ${row("Subject", subject)}
              </table>
              <!-- Message block -->
              <div style="margin-top:20px;padding:20px;background:${EMAIL_BG};border-radius:8px;border-left:4px solid ${EMAIL_ACCENT};">
                <p style="margin:0 0 8px;font-size:12px;font-weight:600;color:${EMAIL_MUTED};text-transform:uppercase;letter-spacing:0.05em;">Message</p>
                <p style="margin:0;font-size:15px;line-height:1.6;color:${EMAIL_TEXT};white-space:pre-wrap;">${message}</p>
              </div>
            </td>
          </tr>
          <!-- Footer -->
          <tr>
            <td style="padding:16px 28px 24px;border-top:1px solid #eee;">
              <p style="margin:0;font-size:12px;color:${EMAIL_MUTED};">
                View and manage in
                <a href="https://console.firebase.google.com/project/_/firestore/data/~2Fcontact_submissions" style="color:${EMAIL_ACCENT};font-weight:600;text-decoration:none;">Firebase Console → Firestore → contact_submissions</a>
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
}

async function sendContactNotificationEmail(toEmail, apiKey, submission) {
  if (!apiKey || !toEmail) {
    console.log("onContactSubmissionCreated: RESEND_API_KEY or CONTACT_NOTIFY_EMAIL not set; skipping email.");
    return;
  }
  const subject = submission.subjectLabel
    ? `[Master Elf] ${submission.subjectLabel} – ${submission.name}`
    : `[Master Elf] Contact from ${submission.name}`;
  const html = buildContactNotificationHtml(submission);

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Authorization": "Bearer " + apiKey,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: "Master Elf Contact <onboarding@resend.dev>",
      to: [toEmail],
      subject,
      html,
    }),
  });
  if (!res.ok) {
    const text = await res.text();
    console.error("onContactSubmissionCreated: Resend error", res.status, text);
    return;
  }
  console.log("onContactSubmissionCreated: notification email sent to", toEmail);
}

function escapeHtml(s) {
  if (typeof s !== "string") return "";
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

export const onContactSubmissionCreated = onDocumentCreated(
  {
    document: `${CONTACT_SUBMISSIONS}/{docId}`,
    secrets: [resendApiKey, contactNotifyEmail],
  },
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const data = snap.data();
    const apiKey = resendApiKey.value();
    const toEmail = contactNotifyEmail.value();
    try {
      await sendContactNotificationEmail(toEmail, apiKey, {
        name: data.name || "",
        email: data.email || "",
        phone: data.phone || "",
        subjectLabel: data.subjectLabel || "",
        message: data.message || "",
      });
    } catch (err) {
      console.error("onContactSubmissionCreated:", err);
    }
  }
);
