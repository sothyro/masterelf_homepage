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

/// Lightweight inspection record for list views.
class InspectionRecord {
  const InspectionRecord({
    required this.id,
    required this.inspectionName,
    required this.inspectorEmail,
    required this.lastStep,
    this.visitDateTime,
    this.updatedAt,
    this.createdAt,
  });

  final String id;
  final String inspectionName;
  final String inspectorEmail;
  final int lastStep;
  final DateTime? visitDateTime;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  factory InspectionRecord.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final updatedAt = data['updatedAt'] as Timestamp?;
    final createdAt = data['createdAt'] as Timestamp?;

    DateTime? parsedVisitDateTime;
    final inspectionDateStr = data['inspectionDate'] as String?;
    final timeOfArrivalStr = data['timeOfArrival'] as String?;
    if (inspectionDateStr != null && inspectionDateStr.isNotEmpty) {
      final parts = inspectionDateStr.split('-');
      if (parts.length == 3) {
        final y = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final d = int.tryParse(parts[2]);
        if (y != null && m != null && d != null) {
          int hour = 0;
          int minute = 0;
          if (timeOfArrivalStr != null && timeOfArrivalStr.isNotEmpty) {
            final tParts = timeOfArrivalStr.split(':');
            if (tParts.isNotEmpty) {
              final h = int.tryParse(tParts[0]);
              if (h != null) hour = h;
              if (tParts.length > 1) {
                final min = int.tryParse(tParts[1]);
                if (min != null) minute = min;
              }
            }
          }
          parsedVisitDateTime = DateTime(y, m, d, hour, minute);
        }
      }
    }

    return InspectionRecord(
      id: doc.id,
      inspectionName: data['inspectionName'] as String? ?? 'Inspection',
      inspectorEmail: data['inspectorEmail'] as String? ?? '',
      lastStep: (data['lastStep'] as int?) ?? 0,
      visitDateTime: parsedVisitDateTime,
      updatedAt: updatedAt?.toDate(),
      createdAt: createdAt?.toDate(),
    );
  }
}

/// Full inspection data for editing.
class InspectionData {
  const InspectionData({
    required this.id,
    required this.formData,
    required this.inspectionName,
    required this.inspectorEmail,
    required this.lastStep,
    this.updatedAt,
    this.createdAt,
  });

  final String id;
  final Map<String, dynamic> formData;
  final String inspectionName;
  final String inspectorEmail;
  final int lastStep;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  factory InspectionData.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final formData = Map<String, dynamic>.from(data);
    formData.remove('inspectorEmail');
    formData.remove('inspectionName');
    formData.remove('lastStep');
    formData.remove('createdAt');
    formData.remove('updatedAt');
    final updatedAt = data['updatedAt'] as Timestamp?;
    final createdAt = data['createdAt'] as Timestamp?;
    return InspectionData(
      id: doc.id,
      formData: formData,
      inspectionName: data['inspectionName'] as String? ?? 'Inspection',
      inspectorEmail: data['inspectorEmail'] as String? ?? '',
      lastStep: (data['lastStep'] as int?) ?? 0,
      updatedAt: updatedAt?.toDate(),
      createdAt: createdAt?.toDate(),
    );
  }
}

String _deriveInspectionName(Map<String, dynamic> formData, DateTime fallbackDate) {
  final name = (formData['inspectionName'] as String?)?.trim();
  if (name != null && name.isNotEmpty) return name;
  final projectName = (formData['projectName'] as String?)?.trim() ?? '';
  if (projectName.isNotEmpty) return projectName;
  final dateStr = '${fallbackDate.year}-${fallbackDate.month.toString().padLeft(2, '0')}-${fallbackDate.day.toString().padLeft(2, '0')}';
  return 'Inspection $dateStr';
}

/// Lists inspections for the given inspector, ordered by updatedAt desc.
Future<List<InspectionRecord>> listInspections(String inspectorEmail) async {
  if (!_isFirebaseEnabled) return [];

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('site_inspections')
        .where('inspectorEmail', isEqualTo: inspectorEmail)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map((d) => InspectionRecord.fromFirestore(d)).toList();
  } catch (_) {
    return [];
  }
}

/// Fetches a single inspection by ID.
Future<InspectionData?> getInspection(String inspectionId) async {
  if (!_isFirebaseEnabled) return null;

  try {
    final doc = await FirebaseFirestore.instance
        .collection('site_inspections')
        .doc(inspectionId)
        .get();

    if (!doc.exists || doc.data() == null) return null;
    return InspectionData.fromFirestore(doc);
  } catch (_) {
    return null;
  }
}

/// Creates a new inspection.
Future<SiteInspectionSaveResult> createInspection({
  required Map<String, dynamic> formData,
  required String inspectorEmail,
  int lastStep = 0,
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
    final now = DateTime.now();
    final inspectionName = _deriveInspectionName(formData, now);

    final data = <String, dynamic>{
      ...formData,
      'inspectorEmail': inspectorEmail,
      'inspectionName': inspectionName,
      'lastStep': lastStep,
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

/// Updates an existing inspection.
Future<SiteInspectionSaveResult> updateInspection({
  required String inspectionId,
  required Map<String, dynamic> formData,
  required String inspectorEmail,
  int lastStep = 0,
}) async {
  if (!_isFirebaseEnabled) {
    return const SiteInspectionSaveResult(
      success: false,
      error: 'Firebase is not configured. Inspection data cannot be saved.',
    );
  }

  try {
    final ref = FirebaseFirestore.instance
        .collection('site_inspections')
        .doc(inspectionId);

    final doc = await ref.get();
    if (!doc.exists) {
      return SiteInspectionSaveResult(
        success: false,
        error: 'Inspection not found.',
      );
    }

    final now = DateTime.now();
    final inspectionName = _deriveInspectionName(formData, now);

    final data = <String, dynamic>{
      ...formData,
      'inspectorEmail': inspectorEmail,
      'inspectionName': inspectionName,
      'lastStep': lastStep,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await ref.set(data, SetOptions(merge: true));

    return SiteInspectionSaveResult(
      success: true,
      inspectionId: inspectionId,
    );
  } catch (e) {
    return SiteInspectionSaveResult(
      success: false,
      error: e.toString(),
    );
  }
}

/// Deletes an inspection.
Future<bool> deleteInspection(String inspectionId) async {
  if (!_isFirebaseEnabled) return false;

  try {
    await FirebaseFirestore.instance
        .collection('site_inspections')
        .doc(inspectionId)
        .delete();
    return true;
  } catch (_) {
    return false;
  }
}

/// Saves a site inspection to Firestore.
/// Creates if [inspectionId] is null, updates otherwise.
/// [formData] should contain only serializable types (String, num, List, Map).
/// Requires authenticated user (caller should verify).
Future<SiteInspectionSaveResult> saveSiteInspection({
  required Map<String, dynamic> formData,
  required String inspectorEmail,
  String? inspectionId,
  int lastStep = 0,
}) async {
  if (inspectionId != null && inspectionId.isNotEmpty) {
    return updateInspection(
      inspectionId: inspectionId,
      formData: formData,
      inspectorEmail: inspectorEmail,
      lastStep: lastStep,
    );
  }
  return createInspection(
    formData: formData,
    inspectorEmail: inspectorEmail,
    lastStep: lastStep,
  );
}
