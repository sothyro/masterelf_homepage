# Booking System – Complete Setup Steps

Follow these steps in order to get the full booking flow working with Firestore, PlasGate SMS, and the booking dashboard.

---

## Prerequisites

- **Node.js 20** (for Cloud Functions): `node --version` should show v20.x.
- **Flutter** installed and on your PATH.
- **Firebase CLI**: `npm install -g firebase-tools` then `firebase login`.
- **PlasGate account** (for SMS): [cloud.plasgate.com](https://cloud.plasgate.com) – you will need an API private key and secret.

---

## Step 1: Create a Firebase project

1. Go to [Firebase Console](https://console.firebase.google.com).
2. Click **Add project** (or use an existing project).
3. Enter a project name (e.g. `masterelf-booking`), follow the wizard, and finish.
4. Note your **Project ID** (e.g. `masterelf-booking`).

---

## Step 2: Enable Firestore

1. In the Firebase Console, open your project.
2. In the left menu, go to **Build → Firestore Database**.
3. Click **Create database**.
4. Choose **Start in production mode** (we use security rules from the repo).
5. Pick a region (e.g. `us-central1` or closest to your users) and confirm.

---

## Step 3: Register your Flutter app with Firebase (Web)

1. In Firebase Console, click the **Web** icon (</>) under “Get started by adding Firebase to your app”.
2. Register an app nickname (e.g. `masterelf-web`) and click **Register app**.
3. Copy the `firebaseConfig` object shown (you will use it in Step 5 if you skip FlutterFire CLI).

**Optional – use FlutterFire CLI (recommended):**

1. In the project root run:
   ```bash
   dart run flutterfire_cli:flutterfire configure
   ```
2. Select your Firebase project and the **web** platform. This will generate/update `lib/firebase_options.dart` with your project’s config.
3. If that succeeds, you can **skip Step 5** (manual firebase_options).

---

## Step 4: Log in to Firebase CLI and select the project

1. In a terminal:
   ```bash
   firebase login
   ```
2. Select your project:
   ```bash
   firebase use <YOUR_PROJECT_ID>
   ```
   Replace `<YOUR_PROJECT_ID>` with the project ID from Step 1.

---

## Step 5: Point the app to your Firebase project (if not using FlutterFire)

If you did **not** run `flutterfire configure`, edit `lib/firebase_options.dart` and replace the placeholder values with your Web app config from Step 3:

- `apiKey` → from Firebase Console Web app config  
- `appId` → from Firebase Console  
- `messagingSenderId` → from Firebase Console  
- `projectId` → your Firebase **Project ID**  
- `authDomain` → `YOUR_PROJECT_ID.firebaseapp.com`  
- `storageBucket` → `YOUR_PROJECT_ID.appspot.com`  

**Important:** The app only uses Firebase when `projectId` is not empty and not the literal string `your-project-id`. So either run FlutterFire or paste real values here.

---

## Step 6: Deploy Firestore rules and indexes

From the **project root** (where `firebase.json` and `firestore.rules` are):

```bash
firebase deploy --only firestore
```

This deploys:

- `firestore.rules` – clients can only **create** documents in `appointments`; reads/updates go through Cloud Functions.
- `firestore.indexes.json` – composite index for “View your bookings” (phone + startTime).

---

## Step 7: Install Cloud Functions dependencies

From the project root:

```bash
cd functions
npm install
cd ..
```

---

## Step 8: Get PlasGate API credentials

1. Sign in at [cloud.plasgate.com](https://cloud.plasgate.com).
2. Open the API / developer section (e.g. [SMPP/API](https://cloud.plasgate.com/smppapi) or similar in your dashboard).
3. Create or copy:
   - **Private key** (API key)
   - **Secret key** (X-Secret)
4. Ensure your account has **balance** so SMS can be sent.

---

## Step 9: Set PlasGate credentials for Cloud Functions

The functions read `PLASGATE_PRIVATE_KEY` and `PLASGATE_SECRET` from the environment. Use **one** of these methods.

**Option A – Set env vars in Google Cloud (recommended, no keys on command line):**

1. Open [Google Cloud Console](https://console.cloud.google.com) and select your Firebase project.
2. Go to **Cloud Functions** → select one of your functions (e.g. `onAppointmentCreated`) → **Edit** → **Runtime, build, connections and security** → **Runtime environment variables**.
3. Add:
   - `PLASGATE_PRIVATE_KEY` = your PlasGate private key  
   - `PLASGATE_SECRET` = your PlasGate secret  
4. Save (or do the same for all four functions). Then deploy:
   ```bash
   firebase deploy --only functions
   ```

**Option B – One-time deploy with env vars on the command line:**

```bash
firebase deploy --only functions --set-env-vars "PLASGATE_PRIVATE_KEY=your_key,PLASGATE_SECRET=your_secret"
```

Use your real keys; do not commit them to git. For future deploys you can run `firebase deploy --only functions` and the previously set env vars are kept unless you change them.

**If keys are not set:** the app and Firestore still work; the trigger will run but skip sending SMS (no error to the user).

---

## Step 10: Deploy Cloud Functions

From the project root:

```bash
firebase deploy --only functions
```

Wait until deployment finishes. You should see:

- `onAppointmentCreated` (Firestore trigger)
- `getAvailableSlots` (callable)
- `getMyBookings` (callable)
- `cancelBooking` (callable)

---

## Step 11: Enable required APIs (if prompted)

If Firebase or the CLI tells you to enable an API (e.g. Cloud Build, Cloud Functions API), open the link it gives or go to [Google Cloud Console](https://console.cloud.google.com) → your project → APIs & Services, and enable:

- Cloud Firestore API  
- Cloud Functions API  
- (Any other API the CLI or Console asks for.)

---

## Step 12: Run the Flutter app

1. Get dependencies:
   ```bash
   flutter pub get
   ```

2. Run on web:
   ```bash
   flutter run -d chrome
   ```
   Or open the project in your IDE and run the web device.

3. Go to the **Consultations / Book Consultation** page:
   - Choose a service → pick a date → pick an available time (2h slots, 30min break) → enter name and phone → confirm.  
   - After submit, a document is created in Firestore, the trigger runs, and (if PlasGate keys are set) an SMS is sent via PlasGate.  
   - Use **View your bookings** below the form: enter the same phone number and click **Find my bookings** to see and cancel appointments.

---

## Quick checklist

| Step | What you did |
|------|----------------------|
| 1 | Created Firebase project |
| 2 | Enabled Firestore |
| 3 | Registered Web app (and optionally ran `flutterfire configure`) |
| 4 | `firebase login` and `firebase use <project_id>` |
| 5 | Real config in `lib/firebase_options.dart` (or from FlutterFire) |
| 6 | `firebase deploy --only firestore` |
| 7 | `cd functions && npm install && cd ..` |
| 8 | Got PlasGate private key and secret |
| 9 | Set `PLASGATE_PRIVATE_KEY` and `PLASGATE_SECRET` (env or Secret Manager) |
| 10 | `firebase deploy --only functions` |
| 11 | Enabled any required APIs |
| 12 | `flutter run -d chrome` and tested booking + dashboard |

---

## Troubleshooting

- **“Firebase not configured” / demo mode:**  
  Ensure `lib/firebase_options.dart` has a real `projectId` (not `your-project-id`). Restart the app after changing it.

- **SMS not sent:**  
  Check Cloud Functions logs: `firebase functions:log`. Ensure `PLASGATE_PRIVATE_KEY` and `PLASGATE_SECRET` are set for the functions. Verify PlasGate balance and that the “to” number is in the correct format (e.g. 855xxxxxxxx for Cambodia).

- **“Permission denied” when creating a booking:**  
  Redeploy Firestore rules: `firebase deploy --only firestore`. Ensure the document has required fields: `name`, `phone`, `serviceId`, `serviceName`, `date`, `time`, `status: 'pending'`.

- **“No bookings found” or callable errors:**  
  Confirm functions are deployed and that you’re using the same Firebase project as the app. Check the browser console and `firebase functions:log` for errors.

- **Index errors in Firestore:**  
  If you see a message about a missing index, open the link in the error message to create the index in the Firebase Console, or run `firebase deploy --only firestore` again so indexes from `firestore.indexes.json` are applied.
