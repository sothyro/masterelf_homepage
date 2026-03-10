import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/site_inspection_service.dart';
import '../../services/site_inspection_pdf_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/glass_container.dart';

/// Feng Shui Geomancy Site Inspection Form - Commercial Housing Complex Assessment.
/// Structure cloned from assets/Forms/Feng shui inspection form.txt
/// Uses step-based flow (like Consultations booking) for better mobile UX.
class SiteInspectionScreen extends StatefulWidget {
  const SiteInspectionScreen({super.key});

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
  String? _saveError;
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

  Future<void> _saveInspection(AuthProvider auth) async {
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
    );
    if (!mounted) return;
    if (result.success) {
      try {
        final pdfBytes = await generateSiteInspectionPdf(data);
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
    if (!mounted) return;
    setState(() {
      _saving = false;
      if (result.success) {
        _saved = true;
      } else {
        _saveError = result.error ?? l10n.inspectionSaveFailed;
      }
    });
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.inspectionSavedTitle}. ${l10n.inspectionPdfDownloadStarted}'),
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
              FilledButton(
                onPressed: () => context.go('/consultations'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                ),
                child: Text(l10n.consultations),
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
          padding: EdgeInsets.only(
            top: 168,
            bottom: 48,
            left: isNarrow ? 16 : 24,
            right: isNarrow ? 16 : 24,
          ),
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
                          onPressed: () => context.go('/consultations/dashboard'),
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
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: _step > 0 ? _prevStep : null,
                          icon: const Icon(LucideIcons.chevronLeft, size: 18),
                          label: Text(l10n.back),
                          style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                        ),
                        const Spacer(),
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
                            onPressed: _saving ? null : () => _saveInspection(auth),
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
                  onPressed: () => setState(() {
                    _saved = false;
                    _formData.clear();
                    for (final c in _controllers.values) {
                      c.clear();
                    }
                    _step = 0;
                  }),
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
                  onPressed: () => context.go('/consultations/dashboard'),
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
        _buildTextField('inspectorName', l10n.inspectionInspectorName),
        _buildDateField('inspectionDate', l10n.inspectionDate),
        _buildTimeField('timeOfArrival', l10n.inspectionTimeOfArrival),
        _buildTextField('weatherConditions', l10n.inspectionWeatherConditions),
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
        _buildTextField('estimatedCompletionYear', l10n.inspectionEstimatedCompletionYear),
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
        _buildTextField('frontageWidth', l10n.inspectionFrontageWidth),
        _buildTextField('depthLength', l10n.inspectionDepthLength),
        _buildTextField('totalSiteArea', l10n.inspectionTotalSiteArea),
        _buildTextField('unitWidth', l10n.inspectionUnitWidth),
        _buildTextField('unitDepth', l10n.inspectionUnitDepth),
        _buildTextField('unitArea', l10n.inspectionUnitArea),
        _buildTextField('floorToCeilingHeight', l10n.inspectionFloorToCeilingHeight),
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
        _buildTextField('facingReading1', l10n.inspectionFacingReading1),
        _buildTextField('facingReading2', l10n.inspectionFacingReading2),
        _buildTextField('facingReading3', l10n.inspectionFacingReading3),
        _buildTextField('averageFacing', l10n.inspectionAverageFacing),
        _buildTextField('converted24Mountains', l10n.inspectionConverted24Mountains),
        _buildTextField('facingCardinal', l10n.inspectionFacingCardinal),
        _buildTextField('sittingDirection', l10n.inspectionSittingDirection),
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
        _buildTextField('powerLinesDirection', l10n.inspectionPowerLinesDirection),
        _buildTextField('bridgesDirection', l10n.inspectionBridgesDirection),
        _buildTextField('largeTreesLocation', l10n.inspectionLargeTreesLocation),
        _buildTextField('religiousBuildingsDirection', l10n.inspectionReligiousBuildingsDirection),
        _buildTextField('hospitalDirection', l10n.inspectionHospitalDirection),
        _buildTextField('schoolDirection', l10n.inspectionSchoolDirection),
        _buildTextField('marketDirection', l10n.inspectionMarketDirection),
        _buildTextField('factoryDirection', l10n.inspectionFactoryDirection),
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
        _buildTextField('roadWidth', l10n.inspectionRoadWidth),
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
        _buildTextField('junctionDistance', l10n.inspectionJunctionDistance),
        _buildRadioGroup('deflectionBuffer', l10n.inspectionDeflectionBuffer, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildRadioGroup('roadAssessment', l10n.inspectionRoadAssessment, [
          l10n.inspectionRoadConfigFavorable, l10n.inspectionNeutral, l10n.inspectionRoadConfigShaQi,
        ]),
        _buildTextField('roadNotes', l10n.inspectionRoadNotes),
        _buildRadioGroup('serviceRoad', l10n.inspectionServiceRoad, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildTextField('serviceRoadLocation', l10n.inspectionServiceRoadLocation),
        _buildRadioGroup('backAlley', l10n.inspectionBackAlley, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildTextField('backAlleyWidth', l10n.inspectionBackAlleyWidth),
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
        _buildTextField('leftCornerReading', l10n.inspectionLeftCornerReading),
        _buildTextField('centerReading', l10n.inspectionCenterReading),
        _buildTextField('rightCornerReading', l10n.inspectionRightCornerReading),
        _buildTextField('mainFacadeAverage', l10n.inspectionMainFacadeAverage),
        _buildTextField('mainDoorReading1', l10n.inspectionMainDoorReading1),
        _buildTextField('mainDoorReading2', l10n.inspectionMainDoorReading2),
        _buildTextField('mainDoorAverage', l10n.inspectionMainDoorAverage),
        _buildTextField('mainDoor24Mountains', l10n.inspectionMainDoor24Mountains),
        _buildTextField('backEntranceReading', l10n.inspectionBackEntranceReading),
        _buildTextField('backEntrance24Mountains', l10n.inspectionBackEntrance24Mountains),
        _buildTextField('carParkEntranceReading', l10n.inspectionCarParkEntranceReading),
        _buildTextField('carPark24Mountains', l10n.inspectionCarPark24Mountains),
        _buildRadioGroup('metalDoorFrames', l10n.inspectionMetalDoorFrames, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildRadioGroup('electricalPanelsNearby', l10n.inspectionElectricalPanelsNearby, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildRadioGroup('steelReinforcement', l10n.inspectionSteelReinforcement, [l10n.inspectionYes, l10n.inspectionNo]),
        _buildTextField('magneticAdjustments', l10n.inspectionAdjustmentsMade),
        _buildTextField('groundFloorFunction', l10n.inspectionGroundFloorFunction),
        _buildTextField('groundFloorHeight', l10n.inspectionGroundFloorHeight),
        _buildTextField('groundFloorFeatures', l10n.inspectionGroundFloorFeatures),
        _buildTextField('staircaseLocation', l10n.inspectionStaircaseLocation),
        _buildTextField('liftLocation', l10n.inspectionLiftLocation),
        _buildTextField('fireEscapeLocation', l10n.inspectionFireEscapeLocation),
      ],
    );
  }

  Widget _buildSection9(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('buildingCompletionYear', 'Building Completion Year'),
        _buildRadioGroup('xuanKongPeriod', 'Xuan Kong Period', [
          'Period 7 (1984–2003)', 'Period 8 (2004–2023)', 'Period 9 (2024–2043)',
        ]),
        _buildTextField('facingDirectionDegrees', 'Facing Direction (degrees)'),
        _buildTextField('facing24MountainPosition', '24 Mountain Position'),
        _buildTextField('star9Location', 'Star 9 (Future Prosperity) location'),
        _buildTextField('star1Location', 'Star 1 (Noble/Water Wealth) location'),
        _buildTextField('star8Location', 'Star 8 (Current Wealth) location'),
        _buildTextField('star5Location', 'Star 5 (Five Yellow - Misfortune) location'),
        _buildTextField('star2Location', 'Star 2 (Illness Star) location'),
        _buildTextField('star3Location', 'Star 3 (Quarrel Star) location'),
        _buildTextField('monthOfVisit', 'Month of Visit'),
        _buildTextField('criticalCombinations', 'Critical Combinations to Note', maxLines: 3),
      ],
    );
  }

  Widget _buildSection10(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('facingDirectionForGua', 'Facing Direction (degrees)'),
        _buildTextField('convertedToTrigram', 'Converted to Trigram'),
        _buildRadioGroup('houseGua', 'House Gua', [
          'Kan House (坎) - Sitting North', 'Kun House (坤) - Sitting Southwest', 'Zhen House (震) - Sitting East',
          'Xun House (巽) - Sitting Southeast', 'Qian House (乾) - Sitting Northwest', 'Dui House (兌) - Sitting West',
          'Gen House (艮) - Sitting Northeast', 'Li House (離) - Sitting South',
        ]),
        _buildRadioGroup('houseGroup', 'House Group', ['East Group (Kan, Zhen, Xun, Li)', 'West Group (Qian, Kun, Gen, Dui)']),
        _buildTextField('mainEntranceSector', 'Main Entrance - Eight Mansions sector'),
        _buildRadioGroup('mainEntranceQuality', 'Main Entrance - Quality', ['Favorable', 'Unfavorable']),
        _buildTextField('managerOfficeSector', 'Manager/Owner Office - Sector'),
        _buildRadioGroup('managerOfficeQuality', 'Manager/Owner Office - Quality', ['Favorable', 'Unfavorable']),
        _buildTextField('cashierSector', 'Cashier/Safe - Sector'),
        _buildRadioGroup('cashierQuality', 'Cashier/Safe - Quality', ['Favorable', 'Unfavorable']),
        _buildTextField('toiletSector', 'Toilet Location - Sector'),
        _buildRadioGroup('toiletImpact', 'Toilet Impact', ['Acceptable (at unfavorable sector)', 'Poor (at favorable sector)']),
      ],
    );
  }

  Widget _buildSection11(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('clientFullName', 'Primary Client/Owner - Full Name'),
        _buildRadioGroup('clientRole', 'Role', ['Owner', 'Main Tenant', 'CEO', 'Manager']),
        _buildTextField('clientBirthDate', 'Birth Date (YYYY-MM-DD)'),
        _buildTextField('clientBirthTime', 'Birth Time (24-hour format)'),
        _buildTextField('clientPlaceOfBirth', 'Place of Birth'),
        _buildTextField('dayMaster', 'Day Master'),
        _buildCheckboxGroup('favorableElements', 'Favorable Elements', ['Wood (木)', 'Fire (火)', 'Earth (土)', 'Metal (金)', 'Water (水)']),
        _buildCheckboxGroup('unfavorableElements', 'Unfavorable Elements', ['Wood (木)', 'Fire (火)', 'Earth (土)', 'Metal (金)', 'Water (水)']),
        _buildRadioGroup('personalGua', 'Personal Gua (Ming Gua)', [
          'Kan (坎) - Water', 'Kun (坤) - Earth', 'Zhen (震) - Wood', 'Xun (巽) - Wood',
          'Qian (乾) - Metal', 'Dui (兌) - Metal', 'Gen (艮) - Earth', 'Li (離) - Fire',
        ]),
        _buildRadioGroup('personalGroup', 'Personal Group', ['East Group', 'West Group']),
        _buildTextField('shengQiDirection', 'Sheng Qi (Best) direction'),
        _buildTextField('tianYiDirection', 'Tian Yi (Health) direction'),
        _buildTextField('yanNianDirection', 'Yan Nian (Relationship) direction'),
        _buildTextField('fuWeiDirection', 'Fu Wei (Stability) direction'),
        _buildTextField('person2Name', 'Person 2 - Name'),
        _buildTextField('person2Role', 'Person 2 - Role'),
        _buildTextField('person2BirthDate', 'Person 2 - Birth Date'),
        _buildTextField('person2BirthTime', 'Person 2 - Birth Time'),
        _buildTextField('person2Gua', 'Person 2 - Personal Gua'),
        _buildTextField('person3Name', 'Person 3 - Name'),
        _buildTextField('person3Role', 'Person 3 - Role'),
        _buildTextField('person3BirthDate', 'Person 3 - Birth Date'),
        _buildTextField('person3BirthTime', 'Person 3 - Birth Time'),
        _buildTextField('person3Gua', 'Person 3 - Personal Gua'),
        _buildCheckboxGroup('businessGoals', 'Primary Business Goals', [
          'Wealth/profit maximization', 'Customer flow', 'Business stability', 'Staff harmony', 'Health and wellbeing', 'Other',
        ]),
        _buildTextField('specificConcerns', 'Specific Concerns Raised', maxLines: 3),
        _buildCheckboxGroup('currentChallenges', 'Current Challenges', [
          'Financial difficulties', 'Health issues', 'Staff conflicts', 'Legal problems', 'Relationship issues', 'Poor customer flow', 'Other',
        ]),
        _buildTextField('healthIssuesSpecify', 'Health issues (specify)'),
      ],
    );
  }

  Widget _buildSection12(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('plannedOpeningDate', 'Planned Opening Date'),
        _buildTextField('preferredDateRangeFrom', 'Preferred Date Range - From'),
        _buildTextField('preferredDateRangeTo', 'Preferred Date Range - To'),
        _buildCheckboxGroup('activitiesForDateSelection', 'Important Activities Requiring Date Selection', [
          'Grand opening ceremony', 'Renovation commencement', 'Moving in/occupation', 'Sign installation',
          'Contract signing', 'Major purchases', 'Other',
        ]),
        _buildTextField('solarTerm', 'Solar Term'),
        _buildTextField('lunarDate', 'Lunar Date'),
        _buildTextField('favorablePalaces', 'Favorable Palaces for This Date/Time', maxLines: 2),
        _buildTextField('unfavorablePalaces', 'Unfavorable Palaces for This Date/Time', maxLines: 2),
        _buildTextField('grandOpeningDate1', 'For Grand Opening - Date option 1'),
        _buildTextField('grandOpeningDate2', 'For Grand Opening - Date option 2'),
        _buildTextField('grandOpeningDate3', 'For Grand Opening - Date option 3'),
        _buildTextField('renovationDate1', 'For Renovation Start - Date option 1'),
        _buildTextField('renovationDate2', 'For Renovation Start - Date option 2'),
        _buildTextField('avoidOwnerZodiac', 'Avoid clash with owner\'s zodiac'),
        _buildTextField('avoidPartnerZodiac', 'Avoid clash with partner\'s zodiac'),
        _buildTextField('mustAvoid', 'Must avoid'),
      ],
    );
  }

  Widget _buildSection13(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('numberOfMainEntrances', 'Number of Main Entrances'),
        _buildTextField('mainDoorPosition', 'Main Door Position (which palace/sector)'),
        _buildRadioGroup('doorConfiguration', 'Door Configuration', [
          'Opens inward', 'Opens outward', 'Sliding door', 'Automatic door',
        ]),
        _buildCheckboxGroup('entranceIssues', 'Issues', [
          'Beam directly above door', 'Door opens to back door (through-flow)', 'Door opens to staircase',
          'Door opens to toilet', 'Narrow entrance/cramped', 'No issues observed',
        ]),
        _buildRadioGroup('entranceAssessment', 'Assessment', [
          'Favorable entrance', 'Acceptable with minor adjustments', 'Requires remedial work',
        ]),
        _buildTextField('ceilingHeight', 'Ceiling Height (m)'),
        _buildRadioGroup('naturalLight', 'Natural Light', ['Abundant (large windows)', 'Moderate', 'Dim/insufficient']),
        _buildRadioGroup('airCirculation', 'Air Circulation', ['Good ventilation', 'Moderate', 'Poor/stagnant']),
        _buildRadioGroup('floorPlanShape', 'Floor Plan Shape', [
          'Square/rectangular (ideal)', 'L-shaped', 'Irregular', 'Triangular sections',
        ]),
        _buildTextField('receptionSector', 'Reception/Cashier - Sector'),
        _buildTextField('receptionFlyingStar', 'Reception - Flying Star'),
        _buildTextField('reception8Mansions', 'Reception - Eight Mansions'),
        _buildRadioGroup('receptionAssessment', 'Reception - Assessment', ['Favorable', 'Neutral', 'Unfavorable']),
        _buildTextField('officeSector', 'Office/Manager - Sector'),
        _buildTextField('officeFlyingStar', 'Office - Flying Star'),
        _buildTextField('office8Mansions', 'Office - Eight Mansions'),
        _buildRadioGroup('officeAssessment', 'Office - Assessment', ['Favorable', 'Neutral', 'Unfavorable']),
        _buildTextField('toiletSectorInternal', 'Toilet/Bathroom - Sector'),
        _buildTextField('toiletFlyingStar', 'Toilet - Flying Star'),
        _buildTextField('toilet8Mansions', 'Toilet - Eight Mansions'),
        _buildCheckboxGroup('toiletIssues', 'Toilet Issues', ['At center palace', 'At wealth sector', 'No issues']),
        _buildTextField('staircaseSector', 'Staircase/Elevator - Sector'),
        _buildTextField('staircaseFlyingStar', 'Staircase - Flying Star'),
        _buildTextField('staircase8Mansions', 'Staircase - Eight Mansions'),
        _buildRadioGroup('staircaseAssessment', 'Staircase - Assessment', ['Favorable', 'Neutral', 'Unfavorable']),
        _buildCheckboxGroup('internalShaQi', 'Internal Sha Qi', [
          'Exposed beams over critical areas', 'Sharp corners pointing at seating areas', 'Long narrow corridor (arrow sha)',
          'Mirror facing main door', 'Toilet door visible from main entrance', 'Staircase directly facing main door', 'Back door aligned with front door',
        ]),
        _buildTextField('internalShaQiNotes', 'Notes'),
        _buildTextField('room1Function', 'Room 1 - Function'),
        _buildTextField('room1Sector', 'Room 1 - Sector'),
        _buildTextField('room1Dimensions', 'Room 1 - Dimensions (m × m)'),
        _buildTextField('room1DoorDirection', 'Room 1 - Door direction'),
        _buildTextField('room1WindowDirection', 'Room 1 - Window direction'),
        _buildTextField('room1CeilingFeatures', 'Room 1 - Ceiling features'),
        _buildTextField('room1FlyingStar', 'Room 1 - Flying Star'),
        _buildTextField('room1EightMansions', 'Room 1 - Eight Mansions'),
        _buildTextField('room1Issues', 'Room 1 - Issues'),
        _buildTextField('room2Function', 'Room 2 - Function'),
        _buildTextField('room2Sector', 'Room 2 - Sector'),
        _buildTextField('room2Dimensions', 'Room 2 - Dimensions'),
        _buildTextField('room2Issues', 'Room 2 - Issues'),
        _buildTextField('room3Function', 'Room 3 - Function'),
        _buildTextField('room3Sector', 'Room 3 - Sector'),
        _buildTextField('room3Dimensions', 'Room 3 - Dimensions'),
        _buildTextField('room3Issues', 'Room 3 - Issues'),
        _buildTextField('numberOfColumns', 'Number of columns'),
        _buildTextField('columnLocations', 'Column locations (sectors)'),
        _buildTextField('structuralWalls', 'Structural walls'),
        _buildTextField('electricalPanelLocation', 'Main electrical panel location'),
        _buildTextField('acUnits', 'Air conditioning units'),
        _buildTextField('waterHeater', 'Water heater'),
        _buildTextField('kitchenLocation', 'Kitchen/pantry location'),
        _buildTextField('bathroomLocation', 'Bathroom/toilet location'),
        _buildTextField('drainageDirection', 'Drainage direction'),
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
        _buildTextField('bestSectorMainEntrance', 'Sectors Best for - Main entrance'),
        _buildTextField('bestSectorCashier', 'Sectors Best for - Cashier/finance'),
        _buildTextField('bestSectorManager', 'Sectors Best for - Manager office'),
        _buildTextField('bestSectorStorage', 'Sectors Best for - Storage'),
        _buildTextField('baziSpaceCompatibility', 'Bazi-Space Compatibility', maxLines: 2),
        _buildRadioGroup('elementSupport', 'House/sector element support', ['Strong', 'Moderate', 'Weak', 'Conflicting']),
        _buildTextField('priorityRanking', 'Priority Ranking for This Project', maxLines: 3),
      ],
    );
  }

  Widget _buildSection18(BuildContext context) {
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
        _buildTextField('estimatedReportDeliveryDate', 'Estimated Report Delivery Date'),
        _buildTextField('inspectorSignatureName', 'Inspector\'s Name'),
        _buildDateField('inspectorSignatureDate', 'Inspector\'s Signature Date'),
      ],
    );
  }
}
