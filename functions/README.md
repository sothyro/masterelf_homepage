# Cloud Functions – Master Elf

Firebase Cloud Functions for appointments (slots, booking, PlasGate SMS) and contact form (Resend email).

## PlasGate SMS setup

When a new document is created in the `appointments` collection, **3 SMS** are sent (sender **MasterElf**): (1) customer, (2) admin, (3) Master Elf (+85512222211).

### Required secrets

| Secret | Description |
|--------|-------------|
| `PLASGATE_PRIVATE_KEY` | Your PlasGate API private key |
| `PLASGATE_SECRET` | Your PlasGate secret (X-Secret header) |
| `ADMIN_SMS_PHONE` | Admin phone (E.164, e.g. `855XXXXXXXXX`) to receive an SMS when a booking is **created by admin** on behalf of a client. Set to `0` to disable. **Must be set at least once** (e.g. to `0`) for deploy to succeed. |

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
