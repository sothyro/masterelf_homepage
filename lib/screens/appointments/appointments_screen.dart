import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/breadcrumb.dart';
import '../../services/appointment_booking_service.dart';
import '../../widgets/glass_container.dart';

/// Consultation type for booking.
class _ConsultationOption {
  const _ConsultationOption({
    required this.id,
    required this.category,
    required this.method,
    required this.icon,
  });

  final String id;
  final String category;
  final String method;
  final IconData icon;
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  static const int _maxStep = 4; // 0: service, 1: date/time, 2: details, 3: confirm, 4: success
  int _step = 0;

  int? _selectedServiceIndex;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _isSubmitting = false;
  String? _submitError;

  List<_ConsultationOption> _getServices(AppLocalizations l10n) {
    return [
      _ConsultationOption(id: 'destiny', category: l10n.consult1Category, method: l10n.consult1Method, icon: LucideIcons.user),
      _ConsultationOption(id: 'event', category: l10n.consult2Category, method: l10n.consult2Method, icon: LucideIcons.calendar),
      _ConsultationOption(id: 'space', category: l10n.consult3Category, method: l10n.consult3Method, icon: LucideIcons.home),
      _ConsultationOption(id: 'timing', category: l10n.consult4Category, method: l10n.consult4Method, icon: LucideIcons.clock),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step < _maxStep) {
      setState(() => _step++);
    }
  }

  void _backStep() {
    if (_step > 0) {
      setState(() => _step--);
    }
  }

  void _resetBooking() {
    setState(() {
      _step = 0;
      _selectedServiceIndex = null;
      _selectedDate = null;
      _selectedTime = null;
      _nameController.clear();
      _phoneController.clear();
      _submitError = null;
    });
  }

  Future<void> _submitBooking() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || phone.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final services = _getServices(l10n);
    final opt = _selectedServiceIndex != null ? services[_selectedServiceIndex!] : null;
    if (opt == null) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final result = await submitAppointmentBooking(
      name: name,
      phone: phone,
      serviceId: opt.id,
      serviceName: '${opt.category} (${opt.method})',
      date: _selectedDate != null ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}' : '',
      time: _selectedTime != null ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}' : '',
    );

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      if (result.success) {
        _step = _maxStep;
      } else {
        _submitError = result.errorMessage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppContent.assetAppsHero,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.expand(),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundDark.withValues(alpha: 0.72),
                        AppColors.backgroundDark.withValues(alpha: 0.88),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120, bottom: 48, left: 24, right: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Breadcrumb(items: [
                          (label: l10n.home, route: '/'),
                          (label: l10n.consultations, route: null),
                        ]),
                        const SizedBox(height: 24),
                        Text(
                          l10n.bookConsultation,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.appointmentIntro,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.onSurfaceVariantDark,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        if (_step < _maxStep) _buildStepper(l10n),
                        const SizedBox(height: 24),
                        if (_step == 0) _buildStepService(l10n),
                        if (_step == 1) _buildStepDateTime(l10n),
                        if (_step == 2) _buildStepDetails(l10n),
                        if (_step == 3) _buildStepConfirm(l10n),
                        if (_step == _maxStep) _buildStepSuccess(l10n),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _SmartMoveSection(),
        ],
      ),
    );
  }

  Widget _buildStepper(AppLocalizations l10n) {
    final steps = [l10n.stepChooseService, l10n.stepDateAndTime, l10n.stepYourDetails, l10n.stepConfirm];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: _step > i ~/ 2 ? AppColors.accent : AppColors.borderDark,
            ),
          );
        }
        final index = i ~/ 2;
        final active = _step == index;
        final done = _step > index;
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.accent : (active ? AppColors.accent : AppColors.surfaceElevatedDark),
                  border: Border.all(
                    color: active || done ? AppColors.accent : AppColors.borderDark,
                    width: 1.5,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, size: 16, color: AppColors.onAccent)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          color: active ? AppColors.onAccent : AppColors.onSurfaceVariantDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[index],
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: active ? AppColors.accent : AppColors.onSurfaceVariantDark,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepService(AppLocalizations l10n) {
    final services = _getServices(l10n);
    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderDark, width: 1),
      boxShadow: AppShadows.card,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(services.length, (i) {
            final s = services[i];
            final selected = _selectedServiceIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _selectedServiceIndex = i),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.borderLight : AppColors.borderDark,
                        width: selected ? 2 : 1,
                      ),
                      color: selected ? AppColors.accent.withValues(alpha: 0.12) : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(s.icon, color: AppColors.accent, size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.category,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                s.method,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onSurfaceVariantDark,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (selected) Icon(Icons.check_circle, color: AppColors.accent, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _selectedServiceIndex != null ? _nextStep : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(l10n.next),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDateTime(AppLocalizations l10n) {
    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderDark, width: 1),
      boxShadow: AppShadows.card,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.selectDate,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.onSurfaceVariantDark),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) => Theme(
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
              if (date != null) setState(() => _selectedDate = date);
            },
            icon: const Icon(LucideIcons.calendar, size: 20),
            label: Text(
              _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : l10n.selectDate,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              side: const BorderSide(color: AppColors.borderLight),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.selectTime,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.onSurfaceVariantDark),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _selectedTime ?? const TimeOfDay(hour: 10, minute: 0),
                builder: (context, child) => Theme(
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
              if (time != null) setState(() => _selectedTime = time);
            },
            icon: const Icon(LucideIcons.clock, size: 20),
            label: Text(
              _selectedTime != null
                  ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                  : l10n.selectTime,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              side: const BorderSide(color: AppColors.borderLight),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              TextButton(
                onPressed: _backStep,
                child: Text(l10n.back, style: const TextStyle(color: AppColors.accent)),
              ),
              const Spacer(),
              FilledButton(
                onPressed: (_selectedDate != null && _selectedTime != null) ? _nextStep : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                ),
                child: Text(l10n.next),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepDetails(AppLocalizations l10n) {
    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderDark, width: 1),
      boxShadow: AppShadows.card,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.yourName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.onSurfaceVariantDark),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            focusNode: _nameFocus,
            decoration: InputDecoration(
              hintText: l10n.yourName,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderLight, width: 2),
              ),
              filled: true,
              fillColor: AppColors.backgroundDark,
            ),
            style: const TextStyle(color: AppColors.onPrimary),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.yourPhone,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.onSurfaceVariantDark),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.phoneHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            focusNode: _phoneFocus,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: l10n.yourPhone,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderLight, width: 2),
              ),
              filled: true,
              fillColor: AppColors.backgroundDark,
            ),
            style: const TextStyle(color: AppColors.onPrimary),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              TextButton(
                onPressed: _backStep,
                child: Text(l10n.back, style: const TextStyle(color: AppColors.accent)),
              ),
              const Spacer(),
              FilledButton(
                onPressed: (_nameController.text.trim().isNotEmpty && _phoneController.text.trim().isNotEmpty)
                    ? _nextStep
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                ),
                child: Text(l10n.next),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepConfirm(AppLocalizations l10n) {
    final services = _getServices(l10n);
    final opt = _selectedServiceIndex != null ? services[_selectedServiceIndex!] : null;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderDark, width: 1),
      boxShadow: AppShadows.card,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ConfirmRow(label: l10n.stepChooseService, value: opt != null ? '${opt.category} (${opt.method})' : '—'),
          const SizedBox(height: 12),
          _ConfirmRow(
            label: l10n.stepDateAndTime,
            value: _selectedDate != null && _selectedTime != null
                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} at ${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                : '—',
          ),
          const SizedBox(height: 12),
          _ConfirmRow(label: l10n.yourName, value: name.isNotEmpty ? name : '—'),
          const SizedBox(height: 12),
          _ConfirmRow(label: l10n.yourPhone, value: phone.isNotEmpty ? phone : '—'),
          if (_submitError != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _submitError!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              TextButton(
                onPressed: _isSubmitting ? null : _backStep,
                child: Text(l10n.back, style: const TextStyle(color: AppColors.accent)),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppShadows.accentButton,
                ),
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submitBooking,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                        )
                      : Text(l10n.confirmAndBook),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepSuccess(AppLocalizations l10n) {
    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5), width: 1),
      boxShadow: AppShadows.card,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.check_circle, size: 64, color: AppColors.accent),
          const SizedBox(height: 24),
          Text(
            l10n.bookingSuccessTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.bookingSuccessMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.messageCircle, color: AppColors.accent, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.smsConfirmationNote,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary,
                          height: 1.4,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Powered by Unimatrix for reliable SMS delivery.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _resetBooking,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(l10n.bookAnother),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.go('/'),
            child: Text(l10n.home, style: const TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

/// "Every Move Can Be A Smart Move" benefits section below the booking form.
class _SmartMoveSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 800;

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isNarrow) ...[
                Text(
                  l10n.smartMoveHeading,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.smartMoveIntro,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onPrimary,
                        height: 1.6,
                      ),
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.smartMoveHeading,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          l10n.smartMoveIntro,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.onPrimary,
                                height: 1.6,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossCount = constraints.maxWidth < 600 ? 1 : (constraints.maxWidth < 900 ? 2 : 3);
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossCount,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.85,
                    children: [
                      _SmartMoveCard(
                        icon: LucideIcons.crosshair,
                        title: l10n.smartMoveCard1Title,
                        description: l10n.smartMoveCard1Desc,
                      ),
                      _SmartMoveCard(
                        icon: LucideIcons.map,
                        title: l10n.smartMoveCard2Title,
                        description: l10n.smartMoveCard2Desc,
                      ),
                      _SmartMoveCard(
                        icon: Icons.warning_amber_rounded,
                        title: l10n.smartMoveCard3Title,
                        description: l10n.smartMoveCard3Desc,
                      ),
                      _SmartMoveCard(
                        icon: LucideIcons.circleDot,
                        title: l10n.smartMoveCard4Title,
                        description: l10n.smartMoveCard4Desc,
                      ),
                      _SmartMoveCard(
                        icon: LucideIcons.hand,
                        title: l10n.smartMoveCard5Title,
                        description: l10n.smartMoveCard5Desc,
                      ),
                      _SmartMoveCard(
                        icon: LucideIcons.arrowRight,
                        title: l10n.smartMoveCard6Title,
                        description: l10n.smartMoveCard6Desc,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmartMoveCard extends StatelessWidget {
  const _SmartMoveCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark, width: 1),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: AppColors.accent),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
