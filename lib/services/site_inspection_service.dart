import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Whether Firebase is available for site inspection storage.
bool get _isFirebaseEnabled {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// Result of saving a site inspection.
class SiteInspectionSaveResult {
  const SiteInspectionSaveResult({
    required this.success,
    this.inspectionId,
    this.error,
  });

  final bool success;
  final String? inspectionId;
  final String? error;
}

/// Saves a site inspection to Firestore.
/// [formData] should contain only serializable types (String, num, List, Map).
/// Requires authenticated user (caller should verify).
Future<SiteInspectionSaveResult> saveSiteInspection({
  required Map<String, dynamic> formData,
  required String inspectorEmail,
}) async {
  if (!_isFirebaseEnabled) {
    return const SiteInspectionSaveResult(
      success: false,
      error: 'Firebase is not configured. Inspection data cannot be saved.',
    );
  }

  try {
    final firestore = FirebaseFirestore.instance;
    final ref = firestore.collection('site_inspections').doc();

    final data = <String, dynamic>{
      ...formData,
      'inspectorEmail': inspectorEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await ref.set(data);

    return SiteInspectionSaveResult(
      success: true,
      inspectionId: ref.id,
    );
  } catch (e) {
    return SiteInspectionSaveResult(
      success: false,
      error: e.toString(),
    );
  }
}
