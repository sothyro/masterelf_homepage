# Cloud Functions – Master Elf

Firebase Cloud Functions for appointments (slots, booking, PlasGate SMS) and contact form (Resend email).

## PlasGate SMS setup

When a new document is created in the `appointments` collection, **3 SMS** are sent (sender **MasterElf**): (1) customer, (2) admin, (3) Master Elf (+85512222211).

### Required secrets

| Secret | Description |
|--------|-------------|
| `PLASGATE_PRIVATE_KEY` | Your PlasGate API private key |
| `PLASGATE_SECRET` | Your PlasGate secret (X-Secret header) |
| `ADMIN_SMS_PHONE` | Admin phone (E.164, e.g. `855XXXXXXXXX`) to receive an SMS summary on **every new booking**. Set to `0` to disable. **Must be set at least once** (e.g. to `0`) for deploy to succeed. |
| `ADMIN_EMAILS` | Comma-separated staff emails allowed to use admin dashboard callables (e.g. `staff@example.com,admin@example.com`). Set to `legacy` (or leave effectively empty) to allow any authenticated Firebase user until you configure real admin emails. |

**Blaze plan required:** Cloud Functions do not run on the Spark (free) plan. Enable Blaze in Firebase Console → Usage and billing, then redeploy functions.

**Option A – Script (recommended)**  
From project root, set env vars and run:

```powershell
# PowerShell (use single quotes so $ in secret is not expanded)
$env:PLASGATE_PRIVATE_KEY='your_private_key'
$env:PLASGATE_SECRET='your_secret'
node functions/scripts/set-plasgate-secrets.cjs
```

**Option B – Manual**  
From project root:

```bash
firebase functions:secrets:set PLASGATE_PRIVATE_KEY
firebase functions:secrets:set PLASGATE_SECRET
```

Paste the values when prompted. Then deploy:

```bash
cd functions && npm ci && cd ..
firebase deploy --only functions
```

### Testing SMS

- **From the app**: Book a consultation and confirm; an SMS is sent to the phone number you enter.
- **Callable `sendTestSms`**: Requires an authenticated user. Call with `{ "phone": "855XXXXXXXXX", "message": "Optional text" }` to send a test SMS and confirm PlasGate is working.

### Behaviour

On every new booking (customer or admin):

1. **Customer SMS**: Sent to the customer’s phone (from the booking). Message: consultation confirmed, date, time, ref. If phone is invalid or missing, customer SMS is skipped and `smsStatus: "skipped"` is set on the document.
2. **Admin SMS**: Sent to `ADMIN_SMS_PHONE` (summary: name, date, time, ref, customer phone). Skipped if secret not set or invalid.
3. **Master Elf SMS**: Always sent to **+85512222211** with the same summary.

Phone numbers are normalized to E.164. One automatic retry on 5xx or network errors per SMS. Customer SMS result is written to the appointment document (`smsStatus`, `smsSentAt`, and on failure `smsErrorReason`, `smsErrorBody`, etc.).

## Site inspection recovery

Audit or relink `site_inspections` documents in Firestore (project `masterelf-website`):

```powershell
# Authenticate once
gcloud auth application-default login

# List all inspections and summary for sothyro@gmail.com
node functions/scripts/audit-site-inspections.mjs

# Lowercase all inspectorEmail fields (fixes case mismatches)
node functions/scripts/audit-site-inspections.mjs --normalize-all

# Relink inspections from old login email to sothyro@gmail.com
node functions/scripts/audit-site-inspections.mjs --relink-from hello@masterelf.vip --relink-to sothyro@gmail.com
```

After relink/normalize, sign in as `sothyro@gmail.com` and open `/consultations/inspection-dashboard`.

Deploy updated Firestore rules after email normalization changes:

```bash
firebase deploy --only firestore:rules
```
