import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/inspection_form_constants.dart';
import '../../utils/inspection_form_l10n_extension.dart';
import '../../utils/twenty_four_mountains.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/site_inspection_service.dart' show getInspection, saveSiteInspection;
import '../../services/site_inspection_pdf_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/login_dialog.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/page_content_inset.dart';

/// Feng Shui Geomancy Site Inspection Form - Commercial Housing Complex Assessment.
/// Structure cloned from assets/Forms/Feng shui inspection form.txt
/// Uses step-based flow (like Consultations booking) for better mobile UX.
class SiteInspectionScreen extends StatefulWidget {
  const SiteInspectionScreen({super.key, this.inspectionId});

  /// When set, loads existing inspection for edit/continue.
  final String? inspectionId;

  @override
  State<SiteInspectionScreen> createState() => _SiteInspectionScreenState();
}

class _SiteInspectionScreenState extends State<SiteInspectionScreen> {
  static const int _totalSteps = 18; // Header + Sections 1-17 (Section 15 removed)
  final _formKey = GlobalKey<FormState>();
  final _stepSectionKey = GlobalKey();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _formData = {};
  int _step = 0;
  bool _saved = false;
  bool _saving = false;
  bool _loading = false;
  String? _saveError;
  String? _inspectionId;
  Uint8List? _savedPdfBytes;
  String? _savedPdfFilename;

  List<String> _sectionTitles(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.inspectionSection0,
      l10n.inspectionSection1,
      l10n.inspectionSection2,
      l10n.inspectionSection3,
      l10n.inspectionSection4,
      l10n.inspectionSection5,
      l10n.inspectionSection6,
      l10n.inspectionSection7,
      l10n.inspectionSection8,
      l10n.inspectionSection9,
      l10n.inspectionSection10,
      l10n.inspectionSection11,
      l10n.inspectionSection12,
      l10n.inspectionSection13,
      l10n.inspectionSection14,
      l10n.inspectionSection15,
      l10n.inspectionSection16,
      l10n.inspectionSection17,
    ];
  }

  TextEditingController _getController(String key, {String? initial}) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController(text: initial ?? _formData[key]?.toString());
    }
    return _controllers[key]!;
  }

  @override
  void initState() {
    super.initState();
    _inspectionId = widget.inspectionId;
    if (widget.inspectionId != null && widget.inspectionId!.isNotEmpty) {
      _loadInspection();
    }
  }

  Future<void> _loadInspection() async {
    if (widget.inspectionId == null) return;
    setState(() => _loading = true);
    try {
      final data = await getInspection(widget.inspectionId!);
      if (!mounted) return;
      if (data != null) {
        if (data.inspectionName.isNotEmpty && data.inspectionName != 'Inspection') {
          _formData['inspectionName'] = data.inspectionName;
        }
        for (final e in data.formData.entries) {
          final v = e.value;
          if (v == null) continue;
          if (v is List) {
            _formData[e.key] = List<String>.from(v.map((x) => x.toString()));
          } else if (v is String && _isDateString(v)) {
            final dt = _parseDate(v);
            if (dt != null) {
              _formData[e.key] = dt;
            } else {
              _formData[e.key] = v;
            }
          } else if (v is String && _isTimeString(v)) {
            final t = _parseTime(v);
            if (t != null) {
              _formData[e.key] = t;
            } else {
              _formData[e.key] = v;
            }
          } else {
            _formData[e.key] = v;
          }
        }
        _step = data.lastStep.clamp(0, _totalSteps - 1);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _isDateString(String s) =>
      RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(s);

  bool _isTimeString(String s) =>
      RegExp(r'^\d{1,2}:\d{2}$').hasMatch(s);

  DateTime? _parseDate(String s) {
    final parts = s.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  TimeOfDay? _parseTime(String s) {
    final parts = s.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h.clamp(0, 23), minute: m.clamp(0, 59));
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildTextField(String key, String label, {int maxLines = 1, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _getController(key),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.accent, width: 2),
          ),
          filled: true,
          fillColor: AppColors.backgroundDark,
        ),
        style: const TextStyle(color: AppColors.onPrimary),
        onChanged: (v) => _formData[key] = v,
      ),
    );
  }

  /// Degree field: numbers/decimals only, suffix ° always visible. Value stored as "91.99".
  Widget _buildDegreeField(String key, String label) {
    final raw = (_formData[key] ?? _getController(key).text)?.toString().replaceAll('°', '').trim() ?? '';
    final ctrl = _getController(key, initial: raw);
    if (ctrl.text != raw && raw.isNotEmpty) {
      ctrl.text = raw;
      ctrl.selection = TextSelection.collapsed(offset: raw.length);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        decoration: InputDecoration(
          labelText: label,
          hintText: '91.99',
          suffixText: '°',
          suffixStyle: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.accent, width: 2),
          ),
          filled: true,
          fillColor: AppColors.backgroundDark,
        ),
        style: const TextStyle(color: AppColors.onPrimary),
        onChanged: (v) => _formData[key] = v.trim().isEmpty ? null : v.trim(),
      ),
    );
  }

  /// Dimension field: numbers/decimals, suffix m or m².
  Widget _buildDimensionField(String key, String label, {bool squareMeters = false}) {
    const suffix = ' m';
    const suffixSq = ' m²';
    final unit = squareMeters ? suffixSq : suffix;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _getController(key),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        decoration: InputDecoration(
          labelText: label,
          hintText: '0.00',
          suffixText: unit,
          suffixStyle: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.accent, width: 2),
          ),
          filled: true,
          fillColor: AppColors.backgroundDark,
        ),
        style: const TextStyle(color: AppColors.onPrimary),
        onChanged: (v) => _formData[key] = v,
      ),
    );
  }

  /// 24 Mountains dropdown, auto-derived from source degree field. User can override.
  Widget _build24MountainsField(String key, String label, String sourceDegreeKey) {
    final ctrlText = _getController(sourceDegreeKey).text;
    final sourceVal = ctrlText.isNotEmpty ? ctrlText : (_formData[sourceDegreeKey] ?? '');
    final sourceStr = (sourceVal is String ? sourceVal : sourceVal?.toString() ?? '').replaceAll('°', '').trim();
    final derived = degreesTo24Mountains(sourceStr);
    final current = _formData[key] as String?;
    final effective = derived ?? (k24Mountains.contains(current) ? current! : k24Mountains.first);
    if (derived != null && (current == null || current.isEmpty || current == derived)) {
      _formData[key] = derived;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: k24Mountains.contains(effective) ? effective : k24Mountains.first,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.accent, width: 2),
          ),
          filled: true,
          fillColor: AppColors.backgroundDark,
        ),
        dropdownColor: AppColors.surfaceElevatedDark,
        style: const TextStyle(color: AppColors.onPrimary),
        items: k24Mountains.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
        onChanged: (v) => setState(() => _formData[key] = v ?? effective),
      ),
    );
  }

  List<String> _eightDirections(AppLocalizations l10n) => [
    l10n.dirNorth, l10n.dirSouth, l10n.dirEast, l10n.dirWest,
    l10n.dirNortheast, l10n.dirNorthwest, l10n.dirSoutheast, l10n.dirSouthwest,
  ];

  List<String> _eightMansionsSectors(AppLocalizations l10n) => [
    l10n.sectorKanNorth, l10n.sectorKunSouthwest, l10n.sectorZhenEast, l10n.sectorXunSoutheast,
    l10n.sectorQianNorthwest, l10n.sectorDuiWest, l10n.sectorGenNortheast, l10n.sectorLiSouth,
  ];

  List<String> _months(AppLocalizations l10n) => [
    l10n.monthJan, l10n.monthFeb, l10n.monthMar, l10n.monthApr, l10n.monthMay, l10n.monthJun,
    l10n.monthJul, l10n.monthAug, l10n.monthSep, l10n.monthOct, l10n.monthNov, l10n.monthDec,
  ];

  List<String> _chineseZodiac(AppLocalizations l10n) => [
    l10n.zodRat, l10n.zodOx, l10n.zodTiger, l10n.zodRabbit, l10n.zodDragon, l10n.zodSnake,
    l10n.zodHorse, l10n.zodGoat, l10n.zodMonkey, l10n.zodRooster, l10n.zodDog, l10n.zodPig,
  ];

  List<String> _personalGua(AppLocalizations l10n) => [
    l10n.personalGuaKan, l10n.personalGuaKun, l10n.personalGuaZhen, l10n.personalGuaXun,
    l10n.personalGuaQian, l10n.personalGuaDui, l10n.personalGuaGen, l10n.personalGuaLi,
  ];

  List<String> _trigrams(AppLocalizations l10n) => [
    l10n.trigramQian, l10n.trigramKun, l10n.trigramZhen, l10n.trigramXun,
    l10n.trigramKan, l10n.trigramLi, l10n.trigramGen, l10n.trigramDui,
  ];

  Widget _buildDropdownField(String key, String label, List<String> options, {String? selectPlaceholder}) {
    final current = _formData[key] as String?;
    final effectiveOptions = current != null && !options.contains(current)
        ? [current, ...options]
        : options;
    final value = current != null && effectiveOptions.contains(current) ? current : null;
    final placeholder = selectPlaceholder ?? AppLocalizations.of(context)?.inspectionSelectPlaceholder ?? '— Select —';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String?>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.accent, width: 2),
          ),
          filled: true,
          fillColor: AppColors.backgroundDark,
        ),
        dropdownColor: AppColors.surfaceElevatedDark,
        style: const TextStyle(color: AppColors.onPrimary),
        items: [DropdownMenuItem<String?>(value: null, child: Text(placeholder, style: TextStyle(color: AppColors.onSurfaceVariantDark)))]
            .followedBy(effectiveOptions.map((o) => DropdownMenuItem<String?>(value: o, child: Text(o)))).toList(),
        onChanged: (v) => setState(() => _formData[key] = v),
      ),
    );
  }

  Widget _buildRadioGroup(String key, String label, List<String> options) {
    final selected = _formData[key] as String?;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: options.map((o) {
              final isSelected = selected == o;
              return FilterChip(
                label: Text(o),
                selected: isSelected,
                onSelected: (_) => setState(() => _formData[key] = o),
                selectedColor: AppColors.accent.withValues(alpha: 0.3),
                checkmarkColor: AppColors.accent,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxGroup(String key, String label, List<String> options) {
    final selected = (_formData[key] as List<String>? ?? []);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: options.map((o) {
              final isSelected = selected.contains(o);
              return FilterChip(
                label: Text(o, style: const TextStyle(fontSize: 13)),
                selected: isSelected,
                onSelected: (v) {
                  setState(() {
                    final list = List<String>.from(selected);
                    if (v) {
                      list.add(o);
                    } else {
                      list.remove(o);
                    }
                    _formData[key] = list;
                  });
                },
                selectedColor: AppColors.accent.withValues(alpha: 0.3),
                checkmarkColor: AppColors.accent,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String key, String label) {
    final date = _formData[key] as DateTime?;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: OutlinedButton.icon(
        onPressed: () async {
          final d = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (_, child) => Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AppColors.accent,
                  onPrimary: AppColors.onAccent,
                  surface: AppColors.surfaceElevatedDark,
                  onSurface: AppColors.onPrimary,
                ),
              ),
              child: child!,
            ),
          );
          if (d != null) setState(() => _formData[key] = d);
        },
        icon: const Icon(LucideIcons.calendar, size: 18),
        label: Text(date != null ? '${date.day}/${date.month}/${date.year}' : label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onPrimary,
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
    );
  }

  Widget _buildTimeField(String key, String label) {
    final time = _formData[key] as TimeOfDay?;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: OutlinedButton.icon(
        onPressed: () async {
          final t = await showTimePicker(
            context: context,
            initialTime: time ?? TimeOfDay.now(),
            builder: (_, child) => Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AppColors.accent,
                  onPrimary: AppColors.onAccent,
                  surface: AppColors.surfaceElevatedDark,
                  onSurface: AppColors.onPrimary,
                ),
              ),
              child: child!,
            ),
          );
          if (t != null) setState(() => _formData[key] = t);
        },
        icon: const Icon(LucideIcons.clock, size: 18),
        label: Text(time != null ? '${time.hour}:${time.minute.toString().padLeft(2, '0')}' : label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onPrimary,
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
    );
  }

  /// Sync all controller values into formData for save.
  /// Converts DateTime/TimeOfDay to strings for Firestore.
  Map<String, dynamic> _collectFormDataForSave() {
    final data = <String, dynamic>{};
    for (final e in _controllers.entries) {
      final text = e.value.text.trim();
      if (text.isNotEmpty) data[e.key] = text;
    }
    for (final e in _formData.entries) {
      if (data.containsKey(e.key)) continue; // Prefer controller value
      final v = e.value;
      if (v == null) continue;
      if (v is DateTime) {
        data[e.key] = '${v.year}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}';
      } else if (v is TimeOfDay) {
        data[e.key] = '${v.hour.toString().padLeft(2, '0')}:${v.minute.toString().padLeft(2, '0')}';
      } else {
        data[e.key] = v;
      }
    }
    return data;
  }

  void _nextStep() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
      _scrollToStep();
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() => _step--);
      _scrollToStep();
    }
  }

  void _scrollToStep() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _stepSectionKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );
      }
    });
  }

  Future<void> _saveInspection(AuthProvider auth, {bool isFinalStep = false}) async {
    final l10n = AppLocalizations.of(context)!;
    if (!auth.isLoggedIn || auth.userEmail == null) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });
    final data = _collectFormDataForSave();
    final result = await saveSiteInspection(
      formData: data,
      inspectorEmail: auth.userEmail!,
      inspectionId: _inspectionId,
      lastStep: _step,
    );
    if (!mounted) return;
    if (result.success) {
      if (result.inspectionId != null && _inspectionId == null) {
        _inspectionId = result.inspectionId;
      }
      if (isFinalStep) {
        try {
          final pdfBytes = await generateSiteInspectionPdf(
            data,
            fieldLabels: l10n.buildInspectionPdfFieldLabels(),
            reportTitle: l10n.inspectionFormTitle,
            reportSubtitle: l10n.inspectionFormSubtitle,
          );
          final raw = (data['projectName'] as String?)?.trim() ?? '';
          final projectName = raw
              .replaceAll(RegExp(r'\s+'), '-')
              .replaceAll(RegExp(r'[^\w-]'), '')
              .replaceAll(RegExp(r'-+'), '-')
              .replaceAll(RegExp(r'^-|-$'), '');
          final safeName = projectName.isEmpty ? 'inspection' : projectName;
          final dateStr = DateTime.now().toIso8601String().substring(0, 10);
          final filename = 'feng-shui-inspection-$safeName-$dateStr.pdf';
          await saveSiteInspectionPdf(pdfBytes, filename);
          if (mounted) {
            setState(() {
              _savedPdfBytes = pdfBytes;
              _savedPdfFilename = filename;
            });
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${l10n.inspectionPdfExportFailed}: $e'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      }
    }
    if (!mounted) return;
    setState(() {
      _saving = false;
      if (result.success && isFinalStep) {
        _saved = true;
      } else if (!result.success) {
        _saveError = result.error ?? l10n.inspectionSaveFailed;
      }
    });
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFinalStep
              ? '${l10n.inspectionSavedTitle}. ${l10n.inspectionPdfDownloadStarted}'
              : l10n.inspectionSavedTitle),
          backgroundColor: AppColors.accent,
        ),
      );
    } else if (_saveError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_saveError!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    if (!auth.isLoggedIn) {
      return Container(
        width: double.infinity,
        color: AppColors.backgroundDark,
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.lock, size: 64, color: AppColors.accent),
              const SizedBox(height: 24),
              Text(
                l10n.loginRequired,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.onPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (isNarrow)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () => showLoginDialog(
                        context,
                        successActions: [
                          (label: l10n.inspectionNewInspection, route: '/consultations/site-inspection'),
                          (label: l10n.goToDashboard, route: '/consultations/inspection-dashboard'),
                        ],
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                      ),
                      child: Text(l10n.loginButton),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => context.go('/consultations'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                      ),
                      child: Text(l10n.consultations),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () => showLoginDialog(
                        context,
                        successActions: [
                          (label: l10n.inspectionNewInspection, route: '/consultations/site-inspection'),
                          (label: l10n.goToDashboard, route: '/consultations/inspection-dashboard'),
                        ],
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                      ),
                      child: Text(l10n.loginButton),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => context.go('/consultations'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                      ),
                      child: Text(l10n.consultations),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    }

    // Loading state when editing
    if (_loading) {
      return Container(
        width: double.infinity,
        color: AppColors.backgroundDark,
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.accent),
              const SizedBox(height: 16),
              Text(
                l10n.loadingAppointments,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Success state after save
    if (_saved) {
      return _buildSuccessState(context, l10n);
    }

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: SingleChildScrollView(
        child: Padding(
          padding: pageContentPadding(context, bottom: 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  key: _stepSectionKey,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.inspectionFormTitle,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.inspectionFormSubtitle,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.onSurfaceVariantDark,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => context.go('/consultations/inspection-dashboard'),
                          icon: const Icon(LucideIcons.arrowLeft),
                          label: Text(l10n.back),
                          style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildStepper(context),
                    const SizedBox(height: 24),
                    GlassContainer(
                      blurSigma: 8,
                      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderDark, width: 1),
                      boxShadow: AppShadows.card,
                      padding: EdgeInsets.all(isNarrow ? 20 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _sectionTitles(context)[_step],
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 24),
                          _buildCurrentStepContent(context),
                        ],
                      ),
                    ),
                    if (_saveError != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Row(
                          children: [
                            Icon(LucideIcons.alertCircle, color: AppColors.error, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _saveError!,
                                style: TextStyle(color: AppColors.error, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (isNarrow)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: _step > 0 ? _prevStep : null,
                              icon: const Icon(LucideIcons.chevronLeft, size: 18),
                              label: Text(l10n.back),
                              style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _saving
                                ? null
                                : () => _saveInspection(auth, isFinalStep: false),
                            icon: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                                  )
                                : const Icon(LucideIcons.save, size: 18),
                            label: Text(_saving ? l10n.inspectionSaving : l10n.inspectionSaveProgress),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.accent,
                              side: const BorderSide(color: AppColors.accent),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_step < _totalSteps - 1)
                            FilledButton.icon(
                              onPressed: _nextStep,
                              icon: const Icon(LucideIcons.chevronRight, size: 18),
                              label: Text(l10n.next),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.onAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              ),
                            )
                          else
                            FilledButton.icon(
                              onPressed: _saving ? null : () => _saveInspection(auth, isFinalStep: true),
                              icon: _saving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                                    )
                                  : const Icon(LucideIcons.save, size: 20),
                              label: Text(_saving ? l10n.inspectionSaving : l10n.inspectionSave),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.onAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              ),
                            ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: _step > 0 ? _prevStep : null,
                            icon: const Icon(LucideIcons.chevronLeft, size: 18),
                            label: Text(l10n.back),
                            style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: _saving
                                ? null
                                : () => _saveInspection(auth, isFinalStep: false),
                            icon: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                                  )
                                : const Icon(LucideIcons.save, size: 18),
                            label: Text(_saving ? l10n.inspectionSaving : l10n.inspectionSaveProgress),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.accent,
                              side: const BorderSide(color: AppColors.accent),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (_step < _totalSteps - 1)
                            FilledButton.icon(
                              onPressed: _nextStep,
                              icon: const Icon(LucideIcons.chevronRight, size: 18),
                              label: Text(l10n.next),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.onAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              ),
                            )
                          else
                            FilledButton.icon(
                              onPressed: _saving ? null : () => _saveInspection(auth, isFinalStep: true),
                              icon: _saving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                                    )
                                  : const Icon(LucideIcons.save, size: 20),
                              label: Text(_saving ? l10n.inspectionSaving : l10n.inspectionSave),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.onAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_step + 1) / _totalSteps,
                  minHeight: 8,
                  backgroundColor: AppColors.borderDark,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              l10n.inspectionStepOf(_step + 1, _totalSteps),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const separator = 2.0;
            final availableWidth = constraints.maxWidth;
            final circleSize = ((availableWidth - (17 * separator)) / 18).clamp(18.0, 36.0);
            final iconSize = (circleSize * 0.5).clamp(8.0, 18.0);
            final fontSize = (circleSize * 0.4).clamp(8.0, 12.0);
            return SizedBox(
              height: circleSize + 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_totalSteps, (index) {
                  final isActive = _step == index;
                  final isDone = _step > index;
                  return GestureDetector(
                    onTap: () => setState(() => _step = index),
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone
                            ? AppColors.accent
                            : isActive
                                ? AppColors.accent
                                : AppColors.surfaceElevatedDark,
                        border: Border.all(
                          color: isActive || isDone ? AppColors.accent : AppColors.borderDark,
                          width: 1.0,
                        ),
                      ),
                      child: isDone
                          ? Icon(Icons.check, size: iconSize, color: AppColors.onAccent)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                                color: isActive ? AppColors.onAccent : AppColors.onSurfaceVariantDark,
                              ),
                            ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCurrentStepContent(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildHeaderSection(context);
      case 1:
        return _buildSection1(context);
      case 2:
        return _buildSection2(context);
      case 3:
        return _buildSection3(context);
      case 4:
        return _buildSection4(context);
      case 5:
        return _buildSection5(context);
      case 6:
        return _buildSection6(context);
      case 7:
        return _buildSection7(context);
      case 8:
        return _buildSection8(context);
      case 9:
        return _buildSection9(context);
      case 10:
        return _buildSection10(context);
      case 11:
        return _buildSection11(context);
      case 12:
        return _buildSection12(context);
      case 13:
        return _buildSection13(context);
      case 14:
        return _buildSection14(context);
      case 15:
        return _buildSection16(context);
      case 16:
        return _buildSection17(context);
      case 17:
        return _buildSection18(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSuccessState(BuildContext context, AppLocalizations l10n) {
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      padding: EdgeInsets.only(
        top: isMobile ? 168 : 120,
        bottom: 48,
        left: isMobile ? 16 : 24,
        right: isMobile ? 16 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: GlassContainer(
            blurSigma: 8,
            color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5), width: 1),
            boxShadow: AppShadows.card,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 64, color: AppColors.accent),
                const SizedBox(height: 24),
                Text(
                  l10n.inspectionSavedTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.inspectionSavedMessage,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => context.go('/consultations/site-inspection'),
                  icon: const Icon(LucideIcons.plus, size: 20),
                  label: Text(l10n.inspectionNewInspection),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
                if (_savedPdfBytes != null && _savedPdfFilename != null) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await saveSiteInspectionPdf(_savedPdfBytes!, _savedPdfFilename!);
                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(l10n.inspectionPdfDownloadStarted),
                            backgroundColor: AppColors.accent,
                          ),
                        );
                      }
                    },
                    icon: const Icon(LucideIcons.fileDown, size: 18),
                    label: Text(l10n.inspectionDownloadPdf),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => context.go('/consultations/inspection-dashboard'),
                  icon: const Icon(LucideIcons.layoutDashboard, size: 18),
                  label: Text(l10n.goToDashboard),
                  style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('inspectionName', l10n.inspectionNameLabel, hint: l10n.inspectionNameHint),
        _buildTextField('inspectorName', l10n.inspectionInspectorName),
        _buildDateField('inspectionDate', l10n.inspectionDate),
        _buildTimeField('timeOfArrival', l10n.inspectionTimeOfArrival),
        _buildDropdownField('weatherConditions', l10n.inspectionWeatherConditions, [
          l10n.weatherSunny, l10n.weatherCloudy, l10n.weatherOvercast, l10n.weatherRainy,
          l10n.weatherStormy, l10n.weatherFoggy, l10n.weatherPartlyCloudy,
        ]),
      ],
    );
  }

  Widget _buildSection1(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('projectName', l10n.inspectionProjectName),
        _buildTextField('address', l10n.inspectionAddress),
        _buildTextField('districtSangkat', l10n.inspectionDistrictSangkat),
        _buildTextField('googleMapsLink', l10n.inspectionGoogleMapsLink),
        _buildRadioGroup('projectType', l10n.inspectionProjectType, [
          l10n.inspectionProjectTypeShophouse,
          l10n.inspectionProjectTypeCommercial,
          l10n.inspectionProjectTypeMixedUse,
          l10n.inspectionProjectTypeOther,
        ]),
        _buildTextField('projectTypeOther', l10n.inspectionOtherSpecify, hint: l10n.inspectionHintSpecify),
        _buildRadioGroup('constructionStatus', l10n.inspectionConstructionStatus, [
          l10n.inspectionConstructionUnder,
          l10n.inspectionConstructionCompleted,
          l10n.inspectionConstructionPartially,
          l10n.inspectionConstructionFully,
        ]),
        _buildDropdownField('estimatedCompletionYear', l10n.inspectionEstimatedCompletionYear, kYears),
        _buildTextField('numberOfFloors', l10n.inspectionNumberOfFloors),
        _buildTextField('numberOfUnits', l10n.inspectionNumberOfUnits),
        _buildTextField('renovationDates', l10n.inspectionRenovationDates),
        _buildRadioGroup('structuralChanges', l10n.inspectionStructuralChanges, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildTextField('renovationDetails', l10n.inspectionRenovationDetails),
        _buildRadioGroup('constructionPhase', l10n.inspectionConstructionPhase, [
          l10n.inspectionPhaseAllBlocks,
          l10n.inspectionPhasePhased,
        ]),
        _buildTextField('phaseDetails', l10n.inspectionPhaseDetails),
      ],
    );
  }

  Widget _buildSection2(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.inspectionDimensions, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _buildDimensionField('frontageWidth', l10n.inspectionFrontageWidth),
        _buildDimensionField('depthLength', l10n.inspectionDepthLength),
        _buildDimensionField('totalSiteArea', l10n.inspectionTotalSiteArea, squareMeters: true),
        _buildDimensionField('unitWidth', l10n.inspectionUnitWidth),
        _buildDimensionField('unitDepth', l10n.inspectionUnitDepth),
        _buildDimensionField('unitArea', l10n.inspectionUnitArea, squareMeters: true),
        _buildDimensionField('floorToCeilingHeight', l10n.inspectionFloorToCeilingHeight),
        const SizedBox(height: 24),
        Text(l10n.inspectionOrientationCompass, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _buildCheckboxGroup('equipmentUsed', l10n.inspectionEquipmentUsed, [
          l10n.inspectionEquipmentLuoPan,
          l10n.inspectionEquipmentDigital,
          l10n.inspectionEquipmentSmartphone,
          l10n.inspectionEquipmentOther,
        ]),
        _buildTextField('equipmentOther', l10n.inspectionOtherEquipment),
        _buildDegreeField('facingReading1', l10n.inspectionFacingReading1),
        _buildDegreeField('facingReading2', l10n.inspectionFacingReading2),
        _buildDegreeField('facingReading3', l10n.inspectionFacingReading3),
        _buildDegreeField('averageFacing', l10n.inspectionAverageFacing),
        _build24MountainsField('converted24Mountains', l10n.inspectionConverted24Mountains, 'averageFacing'),
        _buildDropdownField('facingCardinal', l10n.inspectionFacingCardinal, [
          l10n.dirNorth, l10n.dirSouth, l10n.dirEast, l10n.dirWest,
          l10n.dirNortheast, l10n.dirNorthwest, l10n.dirSoutheast, l10n.dirSouthwest,
        ]),
        _buildDropdownField('sittingDirection', l10n.inspectionSittingDirection, [
          l10n.dirNorth, l10n.dirSouth, l10n.dirEast, l10n.dirWest,
          l10n.dirNortheast, l10n.dirNorthwest, l10n.dirSoutheast, l10n.dirSouthwest,
        ]),
        _buildTextField('magneticInterferenceNotes', l10n.inspectionMagneticInterferenceNotes, maxLines: 3),
      ],
    );
  }

  Widget _buildSection3(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCelestialAnimal(context, l10n.inspectionTortoiseTitle, 'tortoise', [
          l10n.inspectionTortoiseDesc1, l10n.inspectionTortoiseDesc2, l10n.inspectionTortoiseDesc3, l10n.inspectionTortoiseDesc4,
          l10n.inspectionTortoiseDesc5, l10n.inspectionTortoiseDesc6, l10n.inspectionTortoiseDesc7,
        ], [l10n.inspectionTortoiseAssess1, l10n.inspectionTortoiseAssess2, l10n.inspectionTortoiseAssess3]),
        const SizedBox(height: 24),
        _buildCelestialAnimal(context, l10n.inspectionDragonTitle, 'dragon', [
          l10n.inspectionDragonDesc1, l10n.inspectionDragonDesc2, l10n.inspectionDragonDesc3, l10n.inspectionDragonDesc4,
          l10n.inspectionDragonDesc5, l10n.inspectionDragonDesc6, l10n.inspectionDragonDesc7,
        ], [l10n.inspectionDragonAssess1, l10n.inspectionDragonAssess2, l10n.inspectionDragonAssess3, l10n.inspectionDragonAssess4]),
        const SizedBox(height: 24),
        _buildCelestialAnimal(context, l10n.inspectionTigerTitle, 'tiger', [
          l10n.inspectionTigerDesc1, l10n.inspectionTigerDesc2, l10n.inspectionTigerDesc3,
          l10n.inspectionTigerDesc4, l10n.inspectionTigerDesc5, l10n.inspectionTigerDesc6,
        ], [l10n.inspectionTigerAssess1, l10n.inspectionTigerAssess2, l10n.inspectionTigerAssess3, l10n.inspectionTigerAssess4]),
        const SizedBox(height: 24),
        _buildCelestialAnimal(context, l10n.inspectionPhoenixTitle, 'phoenix', [
          l10n.inspectionPhoenixDesc1, l10n.inspectionPhoenixDesc2, l10n.inspectionPhoenixDesc3, l10n.inspectionPhoenixDesc4,
          l10n.inspectionPhoenixDesc5, l10n.inspectionPhoenixDesc6,
        ], [l10n.inspectionPhoenixAssess1, l10n.inspectionPhoenixAssess2, l10n.inspectionPhoenixAssess3]),
      ],
    );
  }

  Widget _buildCelestialAnimal(BuildContext context, String title, String prefix, List<String> descOptions, List<String> assessmentOptions) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 12),
        _buildCheckboxGroup('${prefix}Desc', l10n.inspectionDescription, descOptions),
        _buildRadioGroup('${prefix}Assessment', l10n.inspectionAssessment, assessmentOptions),
        _buildTextField('${prefix}Notes', l10n.inspectionNotesSketch, maxLines: 3),
      ],
    );
  }

  Widget _buildSection4(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.inspectionWiderAreaContext, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _buildTextField('distanceToCityCenter', l10n.inspectionDistanceToCityCenter),
        _buildTextField('majorHighways', l10n.inspectionMajorHighways),
        _buildTextField('riversWaterBodies', l10n.inspectionRiversWaterBodies),
        _buildTextField('mountainsTerrain', l10n.inspectionMountainsTerrain),
        _buildRadioGroup('directionOfMountains', l10n.inspectionDirectionOfMountains, [
          l10n.inspectionDirN, l10n.inspectionDirS, l10n.inspectionDirE, l10n.inspectionDirW,
          l10n.inspectionDirNE, l10n.inspectionDirNW, l10n.inspectionDirSE, l10n.inspectionDirSW,
        ]),
        _buildCheckboxGroup('surroundingDevelopment', l10n.inspectionSurroundingDevelopment, [
          l10n.inspectionSurroundEstablished, l10n.inspectionSurroundDeveloping, l10n.inspectionSurroundMixed,
          l10n.inspectionSurroundIndustrial, l10n.inspectionSurroundSuburban,
        ]),
        const SizedBox(height: 24),
        Text(l10n.inspectionMicroEnvironment, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _buildDropdownField('powerLinesDirection', l10n.inspectionPowerLinesDirection, _eightDirections(l10n)),
        _buildDropdownField('bridgesDirection', l10n.inspectionBridgesDirection, _eightDirections(l10n)),
        _buildTextField('largeTreesLocation', l10n.inspectionLargeTreesLocation),
        _buildDropdownField('religiousBuildingsDirection', l10n.inspectionReligiousBuildingsDirection, _eightDirections(l10n)),
        _buildDropdownField('hospitalDirection', l10n.inspectionHospitalDirection, _eightDirections(l10n)),
        _buildDropdownField('schoolDirection', l10n.inspectionSchoolDirection, _eightDirections(l10n)),
        _buildDropdownField('marketDirection', l10n.inspectionMarketDirection, _eightDirections(l10n)),
        _buildDropdownField('factoryDirection', l10n.inspectionFactoryDirection, _eightDirections(l10n)),
        _buildRadioGroup('trafficNoise', l10n.inspectionTrafficNoise, [l10n.inspectionHeavy, l10n.inspectionModerate, l10n.inspectionLight]),
        _buildCheckboxGroup('noiseSources', l10n.inspectionNoiseSources, [
          l10n.inspectionNoiseConstruction, l10n.inspectionNoiseNightclub, l10n.inspectionNoiseMarket, l10n.inspectionNoiseAirport,
        ]),
        _buildCheckboxGroup('airQuality', l10n.inspectionAirQuality, [
          l10n.inspectionAirClean, l10n.inspectionAirModerate, l10n.inspectionAirIndustrial,
          l10n.inspectionAirDust, l10n.inspectionAirFoul,
        ]),
        _buildTextField('foulOdorsFrom', l10n.inspectionFoulOdorsFrom),
      ],
    );
  }

  Widget _buildSection5(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('mainRoadName', l10n.inspectionMainRoadName),
        _buildDimensionField('roadWidth', l10n.inspectionRoadWidth),
        _buildRadioGroup('roadPosition', l10n.inspectionRoadPosition, [
          l10n.inspectionRoadParallel, l10n.inspectionRoadCurvesToward, l10n.inspectionRoadCurvesAway, l10n.inspectionRoadStraight,
        ]),
        _buildRadioGroup('trafficFlowDirection', l10n.inspectionTrafficFlowDirection, [
          l10n.inspectionFlowDragonToTiger, l10n.inspectionFlowTigerToDragon, l10n.inspectionFlowBoth,
        ]),
        _buildRadioGroup('trafficVolume', l10n.inspectionTrafficVolume, [l10n.inspectionHeavy, l10n.inspectionModerate, l10n.inspectionLight]),
        _buildCheckboxGroup('nearbyJunctions', l10n.inspectionNearbyJunctions, [
          l10n.inspectionJunctionT, l10n.inspectionJunctionY, l10n.inspectionJunctionCross, l10n.inspectionJunctionRoundabout, l10n.inspectionJunctionNone,
        ]),
        _buildDimensionField('junctionDistance', l10n.inspectionJunctionDistance),
        _buildRadioGroup('deflectionBuffer', l10n.inspectionDeflectionBuffer, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildRadioGroup('roadAssessment', l10n.inspectionRoadAssessment, [
          l10n.inspectionRoadConfigFavorable, l10n.inspectionNeutral, l10n.inspectionRoadConfigShaQi,
        ]),
        _buildTextField('roadNotes', l10n.inspectionRoadNotes),
        _buildRadioGroup('serviceRoad', l10n.inspectionServiceRoad, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildTextField('serviceRoadLocation', l10n.inspectionServiceRoadLocation),
        _buildRadioGroup('backAlley', l10n.inspectionBackAlley, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildDimensionField('backAlleyWidth', l10n.inspectionBackAlleyWidth),
        _buildRadioGroup('carParkEntrance', l10n.inspectionCarParkEntrance, [l10n.inspectionFront, l10n.inspectionSide, l10n.inspectionBack]),
        _buildRadioGroup('loadingBay', l10n.inspectionLoadingBay, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildTextField('loadingBayLocation', l10n.inspectionLoadingBayLocation),
      ],
    );
  }

  Widget _buildSection6(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCheckboxGroup('waterBodiesPresent', l10n.inspectionWaterBodiesPresent, [
          l10n.inspectionWaterRiver, l10n.inspectionWaterCanal, l10n.inspectionWaterPond, l10n.inspectionWaterLake,
          l10n.inspectionWaterDitch, l10n.inspectionWaterPool, l10n.inspectionWaterFountain, l10n.inspectionWaterNone,
        ]),
        _buildCheckboxGroup('waterLocation', l10n.inspectionWaterLocation, [
          l10n.inspectionFront, l10n.inspectionBack, l10n.inspectionWaterLeftDragon, l10n.inspectionWaterRightTiger,
        ]),
        _buildRadioGroup('waterFlowDirection', l10n.inspectionWaterFlowDirection, [
          l10n.inspectionFlowToward, l10n.inspectionFlowAway, l10n.inspectionFlowEmbracing, l10n.inspectionFlowStagnant,
        ]),
        _buildRadioGroup('waterQuality', l10n.inspectionWaterQuality, [
          l10n.inspectionQualityClean, l10n.inspectionQualityModerate, l10n.inspectionQualityPolluted, l10n.inspectionQualityFoul,
        ]),
        _buildRadioGroup('waterAssessment', l10n.inspectionWaterAssessment, [
          l10n.inspectionWaterConfigFavorable, l10n.inspectionNeutral, l10n.inspectionWaterConfigUnfavorable,
        ]),
        _buildTextField('waterNotes', l10n.inspectionWaterNotes, maxLines: 3),
      ],
    );
  }

  Widget _buildSection7(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCheckboxGroup('shaQiChecklist', l10n.inspectionShaQiChecklist, [
          l10n.inspectionShaLamppost, l10n.inspectionShaSharpCorners, l10n.inspectionShaTransmission, l10n.inspectionShaBridge,
          l10n.inspectionShaDeadEnd, l10n.inspectionShaChurch, l10n.inspectionShaTree, l10n.inspectionShaTriangular,
          l10n.inspectionShaHighway, l10n.inspectionShaConstruction,
        ]),
        _buildRadioGroup('shaQiSeverity', l10n.inspectionShaQiSeverity, [
          l10n.inspectionShaSeverityNone, l10n.inspectionShaSeverityMinor, l10n.inspectionShaSeverityModerate, l10n.inspectionShaSeveritySevere,
        ]),
        _buildTextField('shaQiDetailedNotes', l10n.inspectionShaQiDetailedNotes, maxLines: 4),
      ],
    );
  }

  Widget _buildSection8(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDegreeField('leftCornerReading', l10n.inspectionLeftCornerReading),
        _buildDegreeField('centerReading', l10n.inspectionCenterReading),
        _buildDegreeField('rightCornerReading', l10n.inspectionRightCornerReading),
        _buildDegreeField('mainFacadeAverage', l10n.inspectionMainFacadeAverage),
        _buildDegreeField('mainDoorReading1', l10n.inspectionMainDoorReading1),
        _buildDegreeField('mainDoorReading2', l10n.inspectionMainDoorReading2),
        _buildDegreeField('mainDoorAverage', l10n.inspectionMainDoorAverage),
        _build24MountainsField('mainDoor24Mountains', l10n.inspectionMainDoor24Mountains, 'mainDoorAverage'),
        _buildDegreeField('backEntranceReading', l10n.inspectionBackEntranceReading),
        _build24MountainsField('backEntrance24Mountains', l10n.inspectionBackEntrance24Mountains, 'backEntranceReading'),
        _buildDegreeField('carParkEntranceReading', l10n.inspectionCarParkEntranceReading),
        _build24MountainsField('carPark24Mountains', l10n.inspectionCarPark24Mountains, 'carParkEntranceReading'),
        _buildRadioGroup('metalDoorFrames', l10n.inspectionMetalDoorFrames, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildRadioGroup('electricalPanelsNearby', l10n.inspectionElectricalPanelsNearby, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildRadioGroup('steelReinforcement', l10n.inspectionSteelReinforcement, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildTextField('magneticAdjustments', l10n.inspectionAdjustmentsMade),
        _buildTextField('groundFloorFunction', l10n.inspectionGroundFloorFunction),
        _buildDimensionField('groundFloorHeight', l10n.inspectionGroundFloorHeight),
        _buildTextField('groundFloorFeatures', l10n.inspectionGroundFloorFeatures),
        _buildTextField('staircaseLocation', l10n.inspectionStaircaseLocation),
        _buildTextField('liftLocation', l10n.inspectionLiftLocation),
        _buildTextField('fireEscapeLocation', l10n.inspectionFireEscapeLocation),
      ],
    );
  }

  Widget _buildSection9(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sectors = _eightMansionsSectors(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDropdownField('buildingCompletionYear', l10n.inspectionBuildingCompletionYear, kYears),
        _buildRadioGroup('xuanKongPeriod', l10n.inspectionXuanKongPeriod, l10n.inspectionXuanKongPeriods),
        _buildDegreeField('facingDirectionDegrees', l10n.inspectionFacingDirectionDegrees),
        _build24MountainsField('facing24MountainPosition', l10n.inspection24MountainPosition, 'facingDirectionDegrees'),
        _buildDropdownField('star9Location', l10n.inspectionStar9Location, sectors),
        _buildDropdownField('star1Location', l10n.inspectionStar1Location, sectors),
        _buildDropdownField('star8Location', l10n.inspectionStar8Location, sectors),
        _buildDropdownField('star5Location', l10n.inspectionStar5Location, sectors),
        _buildDropdownField('star2Location', l10n.inspectionStar2Location, sectors),
        _buildDropdownField('star3Location', l10n.inspectionStar3Location, sectors),
        _buildDropdownField('monthOfVisit', l10n.inspectionMonthOfVisit, _months(l10n)),
        _buildTextField('criticalCombinations', l10n.inspectionCriticalCombinations, maxLines: 3),
      ],
    );
  }

  Widget _buildSection10(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sectors = _eightMansionsSectors(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDegreeField('facingDirectionForGua', l10n.inspectionFacingDirectionDegrees),
        _buildDropdownField('convertedToTrigram', l10n.inspectionConvertedToTrigram, _trigrams(l10n)),
        _buildRadioGroup('houseGua', l10n.inspectionHouseGua, l10n.inspectionHouseGuaOptions),
        _buildRadioGroup('houseGroup', l10n.inspectionHouseGroup, l10n.inspectionHouseGroups),
        _buildDropdownField('mainEntranceSector', l10n.inspectionMainEntranceSector, sectors),
        _buildRadioGroup('mainEntranceQuality', l10n.inspectionMainEntranceQuality, [l10n.inspectionFavorable, l10n.inspectionUnfavorable]),
        _buildDropdownField('managerOfficeSector', l10n.inspectionManagerOfficeSector, sectors),
        _buildRadioGroup('managerOfficeQuality', l10n.inspectionManagerOfficeQuality, [l10n.inspectionFavorable, l10n.inspectionUnfavorable]),
        _buildDropdownField('cashierSector', l10n.inspectionCashierSector, sectors),
        _buildRadioGroup('cashierQuality', l10n.inspectionCashierQuality, [l10n.inspectionFavorable, l10n.inspectionUnfavorable]),
        _buildDropdownField('toiletSector', l10n.inspectionToiletSector, sectors),
        _buildRadioGroup('toiletImpact', l10n.inspectionToiletImpact, l10n.inspectionToiletImpactOptions),
      ],
    );
  }

  Widget _buildSection11(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final directions = _eightDirections(l10n);
    final personalGua = _personalGua(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('clientFullName', l10n.inspectionClientFullName),
        _buildRadioGroup('clientRole', l10n.inspectionClientRole, l10n.inspectionClientRoles),
        _buildDateField('clientBirthDate', l10n.inspectionBirthDate),
        _buildTimeField('clientBirthTime', l10n.inspectionBirthTime),
        _buildTextField('clientPlaceOfBirth', l10n.inspectionPlaceOfBirth),
        _buildTextField('dayMaster', l10n.inspectionDayMaster),
        _buildCheckboxGroup('favorableElements', l10n.inspectionFavorableElements, l10n.inspectionFiveElements),
        _buildCheckboxGroup('unfavorableElements', l10n.inspectionUnfavorableElements, l10n.inspectionFiveElements),
        _buildRadioGroup('personalGua', l10n.inspectionPersonalGuaLabel, personalGua),
        _buildRadioGroup('personalGroup', l10n.inspectionPersonalGroup, l10n.inspectionPersonalGroups),
        _buildDropdownField('shengQiDirection', l10n.inspectionShengQiDirection, directions),
        _buildDropdownField('tianYiDirection', l10n.inspectionTianYiDirection, directions),
        _buildDropdownField('yanNianDirection', l10n.inspectionYanNianDirection, directions),
        _buildDropdownField('fuWeiDirection', l10n.inspectionFuWeiDirection, directions),
        _buildTextField('person2Name', l10n.inspectionPerson2Name),
        _buildTextField('person2Role', l10n.inspectionPerson2Role),
        _buildDateField('person2BirthDate', l10n.inspectionPerson2BirthDate),
        _buildTimeField('person2BirthTime', l10n.inspectionPerson2BirthTime),
        _buildDropdownField('person2Gua', l10n.inspectionPerson2Gua, personalGua),
        _buildTextField('person3Name', l10n.inspectionPerson3Name),
        _buildTextField('person3Role', l10n.inspectionPerson3Role),
        _buildDateField('person3BirthDate', l10n.inspectionPerson3BirthDate),
        _buildTimeField('person3BirthTime', l10n.inspectionPerson3BirthTime),
        _buildDropdownField('person3Gua', l10n.inspectionPerson3Gua, personalGua),
        _buildCheckboxGroup('businessGoals', l10n.inspectionBusinessGoals, l10n.inspectionBusinessGoalOptions),
        _buildTextField('specificConcerns', l10n.inspectionSpecificConcerns, maxLines: 3),
        _buildCheckboxGroup('currentChallenges', l10n.inspectionCurrentChallenges, l10n.inspectionChallengeOptions),
        _buildTextField('healthIssuesSpecify', l10n.inspectionHealthIssuesSpecify),
      ],
    );
  }

  Widget _buildSection12(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDateField('plannedOpeningDate', l10n.inspectionPlannedOpeningDate),
        _buildDateField('preferredDateRangeFrom', l10n.inspectionPreferredDateFrom),
        _buildDateField('preferredDateRangeTo', l10n.inspectionPreferredDateTo),
        _buildCheckboxGroup('activitiesForDateSelection', l10n.inspectionActivitiesDateSelection, l10n.inspectionDateSelectionActivities),
        _buildDropdownField('solarTerm', l10n.inspectionSolarTerm, l10n.inspectionSolarTerms),
        _buildDropdownField('lunarDate', l10n.inspectionLunarDate, l10n.inspectionLunarDates),
        _buildTextField('favorablePalaces', l10n.inspectionFavorablePalaces, maxLines: 2),
        _buildTextField('unfavorablePalaces', l10n.inspectionUnfavorablePalaces, maxLines: 2),
        _buildDateField('grandOpeningDate1', l10n.inspectionGrandOpeningDate1),
        _buildDateField('grandOpeningDate2', l10n.inspectionGrandOpeningDate2),
        _buildDateField('grandOpeningDate3', l10n.inspectionGrandOpeningDate3),
        _buildDateField('renovationDate1', l10n.inspectionRenovationDate1),
        _buildDateField('renovationDate2', l10n.inspectionRenovationDate2),
        _buildDropdownField('avoidOwnerZodiac', l10n.inspectionAvoidOwnerZodiac, _chineseZodiac(l10n)),
        _buildDropdownField('avoidPartnerZodiac', l10n.inspectionAvoidPartnerZodiac, _chineseZodiac(l10n)),
        _buildTextField('mustAvoid', l10n.inspectionMustAvoid),
      ],
    );
  }

  Widget _buildSection13(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sectors = _eightMansionsSectors(l10n);
    final directions = _eightDirections(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('numberOfMainEntrances', l10n.inspectionNumberOfMainEntrances),
        _buildDropdownField('mainDoorPosition', l10n.inspectionMainDoorPosition, sectors),
        _buildRadioGroup('doorConfiguration', l10n.inspectionDoorConfiguration, l10n.inspectionDoorConfigurations),
        _buildCheckboxGroup('entranceIssues', l10n.inspectionEntranceIssues, l10n.inspectionEntranceIssueOptions),
        _buildRadioGroup('entranceAssessment', l10n.inspectionEntranceAssessment, l10n.inspectionEntranceAssessments),
        _buildDimensionField('ceilingHeight', l10n.inspectionCeilingHeight),
        _buildRadioGroup('naturalLight', l10n.inspectionNaturalLight, l10n.inspectionNaturalLightOptions),
        _buildRadioGroup('airCirculation', l10n.inspectionAirCirculation, l10n.inspectionAirCirculationOptions),
        _buildRadioGroup('floorPlanShape', l10n.inspectionFloorPlanShape, l10n.inspectionFloorPlanShapes),
        _buildDropdownField('receptionSector', l10n.inspectionReceptionSector, sectors),
        _buildDropdownField('receptionFlyingStar', l10n.inspectionReceptionFlyingStar, l10n.inspectionFlyingStars),
        _buildDropdownField('reception8Mansions', l10n.inspectionReception8Mansions, sectors),
        _buildRadioGroup('receptionAssessment', l10n.inspectionReceptionAssessment, l10n.inspectionFavorableNeutralUnfavorable),
        _buildDropdownField('officeSector', l10n.inspectionOfficeSector, sectors),
        _buildDropdownField('officeFlyingStar', l10n.inspectionOfficeFlyingStar, l10n.inspectionFlyingStars),
        _buildDropdownField('office8Mansions', l10n.inspectionOffice8Mansions, sectors),
        _buildRadioGroup('officeAssessment', l10n.inspectionOfficeAssessment, l10n.inspectionFavorableNeutralUnfavorable),
        _buildDropdownField('toiletSectorInternal', l10n.inspectionToiletSectorInternal, sectors),
        _buildDropdownField('toiletFlyingStar', l10n.inspectionToiletFlyingStar, l10n.inspectionFlyingStars),
        _buildDropdownField('toilet8Mansions', l10n.inspectionToilet8Mansions, sectors),
        _buildCheckboxGroup('toiletIssues', l10n.inspectionToiletIssues, l10n.inspectionToiletIssueOptions),
        _buildDropdownField('staircaseSector', l10n.inspectionStaircaseSector, sectors),
        _buildDropdownField('staircaseFlyingStar', l10n.inspectionStaircaseFlyingStar, l10n.inspectionFlyingStars),
        _buildDropdownField('staircase8Mansions', l10n.inspectionStaircase8Mansions, sectors),
        _buildRadioGroup('staircaseAssessment', l10n.inspectionStaircaseAssessment, l10n.inspectionFavorableNeutralUnfavorable),
        _buildCheckboxGroup('internalShaQi', 'Internal Sha Qi', [
          'Exposed beams over critical areas', 'Sharp corners pointing at seating areas', 'Long narrow corridor (arrow sha)',
          'Mirror facing main door', 'Toilet door visible from main entrance', 'Staircase directly facing main door', 'Back door aligned with front door',
        ]),
        _buildTextField('internalShaQiNotes', 'Notes'),
        _buildTextField('room1Function', 'Room 1 - Function'),
        _buildDropdownField('room1Sector', l10n.inspectionRoom1Sector, sectors),
        _buildTextField('room1Dimensions', 'Room 1 - Dimensions (m × m)'),
        _buildDropdownField('room1DoorDirection', l10n.inspectionRoom1DoorDirection, directions),
        _buildDropdownField('room1WindowDirection', l10n.inspectionRoom1WindowDirection, directions),
        _buildTextField('room1CeilingFeatures', 'Room 1 - Ceiling features'),
        _buildDropdownField('room1FlyingStar', l10n.inspectionRoom1FlyingStar, l10n.inspectionFlyingStars),
        _buildDropdownField('room1EightMansions', l10n.inspectionRoom1EightMansions, sectors),
        _buildTextField('room1Issues', 'Room 1 - Issues'),
        _buildTextField('room2Function', 'Room 2 - Function'),
        _buildDropdownField('room2Sector', l10n.inspectionRoom2Sector, sectors),
        _buildTextField('room2Dimensions', 'Room 2 - Dimensions'),
        _buildTextField('room2Issues', 'Room 2 - Issues'),
        _buildTextField('room3Function', 'Room 3 - Function'),
        _buildDropdownField('room3Sector', l10n.inspectionRoom3Sector, sectors),
        _buildTextField('room3Dimensions', 'Room 3 - Dimensions'),
        _buildTextField('room3Issues', 'Room 3 - Issues'),
        _buildTextField('numberOfColumns', 'Number of columns'),
        _buildTextField('columnLocations', 'Column locations (sectors)'),
        _buildTextField('structuralWalls', 'Structural walls'),
        _buildTextField('electricalPanelLocation', 'Main electrical panel location'),
        _buildTextField('acUnits', 'Air conditioning units'),
        _buildTextField('waterHeater', 'Water heater'),
        _buildDropdownField('kitchenLocation', l10n.inspectionKitchenLocation, sectors),
        _buildDropdownField('bathroomLocation', l10n.inspectionBathroomLocation, sectors),
        _buildDropdownField('drainageDirection', l10n.inspectionDrainageDirection, directions),
      ],
    );
  }

  Widget _buildSection14(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCheckboxGroup('safetyConcerns', 'Safety Concerns Observed', [
          'Fire exit blocked/unclear', 'Emergency access insufficient', 'Water leakage signs', 'Mould/dampness',
          'Structural cracks', 'Electrical hazards', 'Poor lighting (safety risk)', 'Slippery surfaces', 'None observed',
        ]),
        _buildTextField('safetyNotes', 'Detailed Notes on Safety Issues', maxLines: 3),
        _buildCheckboxGroup('zoningRestrictions', 'Zoning Restrictions', [
          'Cannot modify façade', 'Cannot relocate staircase', 'Cannot change structural walls',
          'Signage restrictions', 'Operating hours restrictions', 'Other',
        ]),
        _buildTextField('buildingManagementRules', 'Building Management Rules', maxLines: 2),
        _buildRadioGroup('heritageStatus', 'Heritage/Conservation Status', [
          'Not applicable', 'Heritage building (restrictions apply)', 'Conservation zone',
        ]),
        _buildTextField('practicalOverrideNotes', 'Practical Override Notes', maxLines: 4),
      ],
    );
  }

  Widget _buildSection16(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCheckboxGroup('photosTaken', 'Photos Taken', [
          'Front façade (wide shot)', 'Front façade (close-up details)', 'Back of building (Tortoise support)',
          'Left side (Dragon)', 'Right side (Tiger)', 'Front bright hall (Phoenix)', 'Surrounding buildings/structures',
          'Main entrance door', 'Interior layout (each room)', 'Water features (if present)', 'Road configuration and traffic',
          'Sha qi features (poles, corners, etc.)', 'Compass readings (with Luo Pan)', 'Ceiling beams and structural elements',
          'Toilet and kitchen locations', 'Staircase and elevator', 'View from each main window', 'Neighboring properties',
        ]),
        _buildTextField('totalPhotos', 'Total Photos'),
        _buildCheckboxGroup('materialsObtained', 'Materials Obtained', [
          'Building blueprints/floor plans', 'Sales brochure', 'Unit specifications sheet', 'Building management contact',
          'Neighborhood map', 'Historical site information', 'Construction completion certificate', 'Other',
        ]),
        _buildTextField('photosSavedTo', 'Photos saved to'),
        _buildRadioGroup('gpsRecorded', 'GPS coordinates recorded', ['Yes', 'No']),
        _buildRadioGroup('compassDataExported', 'Compass app data exported', ['Yes', 'No']),
        _buildRadioGroup('voiceNotes', 'Voice notes/recordings', ['Yes', 'No']),
      ],
    );
  }

  Widget _buildSection17(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sectors = _eightMansionsSectors(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildRadioGroup('overallLandformQuality', 'Overall Landform Quality', [
          'Excellent', 'Good', 'Average', 'Poor', 'Very Poor',
        ]),
        _buildTextField('keyStrengths', 'Key Strengths', maxLines: 3),
        _buildTextField('keyWeaknesses', 'Key Weaknesses', maxLines: 3),
        _buildTextField('recommendedRemedies', 'Recommended Remedies (Preliminary)', maxLines: 4),
        _buildCheckboxGroup('recommendedBusinessTypes', 'Recommended Business Types', [
          'Retail shop', 'Restaurant/café', 'Office/professional services', 'Showroom',
          'Healthcare/beauty', 'Education/training', 'Other',
        ]),
        _buildDropdownField('bestSectorMainEntrance', l10n.inspectionBestSectorMainEntrance, sectors),
        _buildDropdownField('bestSectorCashier', l10n.inspectionBestSectorCashier, sectors),
        _buildDropdownField('bestSectorManager', l10n.inspectionBestSectorManager, sectors),
        _buildDropdownField('bestSectorStorage', l10n.inspectionBestSectorStorage, sectors),
        _buildTextField('baziSpaceCompatibility', 'Bazi-Space Compatibility', maxLines: 2),
        _buildRadioGroup('elementSupport', 'House/sector element support', l10n.inspectionElementSupportOptions),
        _buildTextField('priorityRanking', 'Priority Ranking for This Project', maxLines: 3),
      ],
    );
  }

  Widget _buildSection18(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCheckboxGroup('additionalInfoNeeded', 'Additional Information Still Needed', [
          'Exact construction completion date/certificate', 'Additional client Bazi information', 'Neighborhood development plans',
          'Historical site information', 'Previous occupant history/outcomes', 'Other',
        ]),
        _buildCheckboxGroup('calculationsRequired', 'Calculations Required', [
          'Flying Star natal chart (Period 9)', 'Annual Flying Star overlay (2026)', 'Monthly Flying Star for key months',
          'Eight Mansions detailed chart', 'Client Bazi Four Pillars analysis', 'Personal Gua calculations for key persons',
          'Qi Men Dun Jia chart for opening dates', 'Date selection for activities',
        ]),
        _buildRadioGroup('siteRevisitNeeded', 'Site Revisit Needed', ['Yes', 'No']),
        _buildTextField('revisitReason', 'Reason'),
        _buildCheckboxGroup('followUpConsultations', 'Follow-up Consultations', [
          'Full written report preparation', 'Client presentation meeting', 'Interior design Feng Shui consultation',
          'Furniture placement guidance', 'Remedy implementation supervision', 'Post-occupation review (3-6 months)',
        ]),
        _buildDateField('estimatedReportDeliveryDate', l10n.inspectionEstimatedReportDeliveryDate),
        _buildTextField('inspectorSignatureName', 'Inspector\'s Name'),
        _buildDateField('inspectorSignatureDate', 'Inspector\'s Signature Date'),
      ],
    );
  }
}
