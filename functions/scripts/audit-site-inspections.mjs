/**
 * Audit and optionally relink site_inspections in Firestore.
 *
 * Usage (from project root):
 *   node functions/scripts/audit-site-inspections.mjs
 *   node functions/scripts/audit-site-inspections.mjs --relink-from hello@masterelf.vip --relink-to sothyro@gmail.com
 *   node functions/scripts/audit-site-inspections.mjs --normalize-all
 *
 * Requires Firebase Admin credentials:
 *   gcloud auth application-default login
 *   (or set GOOGLE_APPLICATION_CREDENTIALS to a service account key)
 */
import { initializeApp, applicationDefault, getApps } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";

const PROJECT_ID = "masterelf-website";
const TARGET_EMAIL = "sothyro@gmail.com";

function parseArgs(argv) {
  const relinkIndex = argv.indexOf("--relink");
  const relinkFromIndex = argv.indexOf("--relink-from");
  const relinkToIndex = argv.indexOf("--relink-to");
  return {
    relinkTo:
      relinkIndex >= 0 && argv[relinkIndex + 1]
        ? argv[relinkIndex + 1].trim().toLowerCase()
        : null,
    relinkFrom:
      relinkFromIndex >= 0 && argv[relinkFromIndex + 1]
        ? argv[relinkFromIndex + 1].trim().toLowerCase()
        : null,
    relinkToExplicit:
      relinkToIndex >= 0 && argv[relinkToIndex + 1]
        ? argv[relinkToIndex + 1].trim().toLowerCase()
        : null,
    normalizeAll: argv.includes("--normalize-all"),
  };
}

function formatTs(value) {
  if (!value) return "";
  if (value instanceof Timestamp) return value.toDate().toISOString();
  if (value instanceof Date) return value.toISOString();
  return String(value);
}

function matchesTarget(email, targetLower) {
  if (!email || typeof email !== "string") return false;
  return email.toLowerCase().includes(targetLower.split("@")[0]);
}

function normalizeEmail(email) {
  return typeof email === "string" ? email.trim().toLowerCase() : "";
}

async function main() {
  const { relinkTo, relinkFrom, relinkToExplicit, normalizeAll } = parseArgs(
    process.argv.slice(2),
  );
  const targetLower = TARGET_EMAIL.toLowerCase();

  if (getApps().length === 0) {
    initializeApp({
      credential: applicationDefault(),
      projectId: PROJECT_ID,
    });
  }

  const db = getFirestore();
  const snapshot = await db.collection("site_inspections").get();

  console.log(`\nProject: ${PROJECT_ID}`);
  console.log(`Collection: site_inspections`);
  console.log(`Total documents: ${snapshot.size}\n`);

  const rows = [];
  for (const doc of snapshot.docs) {
    const data = doc.data();
    const email = data.inspectorEmail ?? "";
    rows.push({
      id: doc.id,
      inspectorEmail: email,
      normalizedEmail: normalizeEmail(email),
      inspectionName: data.inspectionName ?? "",
      projectName: data.projectName ?? "",
      lastStep: data.lastStep ?? 0,
      createdAt: formatTs(data.createdAt),
      updatedAt: formatTs(data.updatedAt),
      matchesSothyro: matchesTarget(email, targetLower),
      exactTarget: normalizeEmail(email) === targetLower,
      needsLowercase: email !== normalizeEmail(email),
    });
  }

  rows.sort((a, b) => (b.updatedAt || "").localeCompare(a.updatedAt || ""));

  const sothyroRows = rows.filter((r) => r.matchesSothyro);
  const exactRows = rows.filter((r) => r.exactTarget);
  const orphanRows = sothyroRows.filter((r) => !r.exactTarget);
  const lowercaseRows = rows.filter((r) => r.needsLowercase);

  console.log("=== All inspections (newest first) ===");
  if (rows.length === 0) {
    console.log("(no documents found)");
  } else {
    for (const row of rows) {
      console.log(
        [
          `id=${row.id}`,
          `inspectorEmail=${JSON.stringify(row.inspectorEmail)}`,
          `inspectionName=${JSON.stringify(row.inspectionName)}`,
          `projectName=${JSON.stringify(row.projectName)}`,
          `lastStep=${row.lastStep}`,
          `updatedAt=${row.updatedAt}`,
        ].join(" | "),
      );
    }
  }

  console.log("\n=== Summary ===");
  console.log(`Exact match (${TARGET_EMAIL}): ${exactRows.length}`);
  console.log(`Sothyro variants (case/partial): ${sothyroRows.length}`);
  console.log(`Orphaned (sothyro but not exact email): ${orphanRows.length}`);
  console.log(`Need lowercase normalization: ${lowercaseRows.length}`);

  if (orphanRows.length > 0) {
    console.log("\nOrphaned document IDs:");
    for (const row of orphanRows) {
      console.log(`  - ${row.id} (${row.inspectorEmail})`);
    }
  }

  if (normalizeAll) {
    const toNormalize = rows.filter((r) => r.inspectorEmail !== r.normalizedEmail);
    if (toNormalize.length === 0) {
      console.log("\nAll inspectorEmail values are already normalized.");
      return;
    }
    console.log(`\n=== Normalizing ${toNormalize.length} document(s) ===`);
    const batch = db.batch();
    for (const row of toNormalize) {
      const ref = db.collection("site_inspections").doc(row.id);
      batch.update(ref, { inspectorEmail: row.normalizedEmail });
      console.log(`  queued: ${row.id} (${row.inspectorEmail} -> ${row.normalizedEmail})`);
    }
    await batch.commit();
    console.log("Normalize complete.");
    return;
  }

  if (relinkFrom && relinkToExplicit) {
    const fromEmail = relinkFrom.trim().toLowerCase();
    const toEmail = relinkToExplicit.trim().toLowerCase();
    const toRelink = rows.filter((r) => normalizeEmail(r.inspectorEmail) === fromEmail);
    if (toRelink.length === 0) {
      console.log(`\nNo documents with inspectorEmail ${fromEmail}.`);
      return;
    }
    console.log(
      `\n=== Relinking ${toRelink.length} document(s): ${fromEmail} -> ${toEmail} ===`,
    );
    const batch = db.batch();
    for (const row of toRelink) {
      const ref = db.collection("site_inspections").doc(row.id);
      batch.update(ref, { inspectorEmail: toEmail });
      console.log(`  queued: ${row.id} (${row.inspectorEmail} -> ${toEmail})`);
    }
    await batch.commit();
    console.log("Relink complete.");
    return;
  }

  if (!relinkTo) {
    if (orphanRows.length > 0 || lowercaseRows.length > 0) {
      console.log("\nRecovery commands:");
      if (orphanRows.length > 0) {
        console.log(
          `  node functions/scripts/audit-site-inspections.mjs --relink ${TARGET_EMAIL}`,
        );
      }
      if (lowercaseRows.length > 0) {
        console.log("  node functions/scripts/audit-site-inspections.mjs --normalize-all");
      }
    }
    return;
  }

  const normalizedRelink = relinkTo.trim().toLowerCase();
  if (orphanRows.length === 0) {
    console.log(`\nNo orphaned sothyro docs to relink to ${normalizedRelink}.`);
    return;
  }

  console.log(`\n=== Relinking ${orphanRows.length} document(s) to ${normalizedRelink} ===`);
  const batch = db.batch();
  for (const row of orphanRows) {
    const ref = db.collection("site_inspections").doc(row.id);
    batch.update(ref, { inspectorEmail: normalizedRelink });
    console.log(`  queued: ${row.id} (${row.inspectorEmail} -> ${normalizedRelink})`);
  }
  await batch.commit();
  console.log("Relink complete.");
}

main().catch((err) => {
  console.error("Audit failed:", err);
  process.exit(1);
});
