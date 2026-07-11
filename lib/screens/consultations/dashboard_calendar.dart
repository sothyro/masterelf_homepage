import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../l10n/app_localizations.dart';
import '../../models/appointment.dart' show AdminAppointmentRecord, defaultSessionDurationMinutes, durationHoursLabel, generateHourlySlotLabels, selectableDurationsMinutes, sessionTypeOnline, sessionTypeVisit;
import '../../theme/app_theme.dart';
import '../../utils/appointment_slot_utils.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/khmer_aware_text.dart';
import '../../services/appointment_booking_service.dart' show getAvailableSlots, submitAppointmentBooking;
import '../../services/error_service.dart' show AppError;

/// Consultation option for booking.
class _ConsultationOption {
  const _ConsultationOption({
    required this.id,
    required this.category,
    required this.method,
  });

  final String id;
  final String category;
  final String method;
}

final List<String> _timeSlots = generateHourlySlotLabels();

List<String> _slotsForDay(List<AdminAppointmentRecord> appointments, DateTime day) {
  final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
  final customTimes = appointments
      .where((a) => a.date == dateStr && a.status != 'cancelled' && !_timeSlots.contains(a.time))
      .map((a) => a.time)
      .toSet()
      .toList();
  final all = [..._timeSlots, ...customTimes]..sort();
  return all;
}

class DashboardCalendar extends StatelessWidget {
  const DashboardCalendar({
    super.key,
    required this.appointments,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onAppointmentTap,
    required this.onCreateBooking,
    this.onPageChanged,
    required this.loading,
    required this.updatingId,
    required this.onUpdateStatus,
    this.onComplete,
  });

  final List<AdminAppointmentRecord> appointments;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime>? onPageChanged;
  final ValueChanged<AdminAppointmentRecord> onAppointmentTap;
  final void Function(DateTime date, String time) onCreateBooking;
  final bool loading;
  final String? updatingId;
  final void Function(String id, String status) onUpdateStatus;
  final void Function(String id)? onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => _isSameDay(selectedDay, day),
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) {
              final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
              return appointments
                  .where((a) => a.date == dateStr && a.status != 'cancelled')
                  .map((a) => a.id)
                  .toSet()
                  .toList();
            },
            onDaySelected: (selected, focused) {
              onDaySelected(selected);
            },
            onPageChanged: onPageChanged,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: const Icon(LucideIcons.chevronLeft, color: AppColors.accent, size: 24),
              rightChevronIcon: const Icon(LucideIcons.chevronRight, color: AppColors.accent, size: 24),
              titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              headerPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 12),
              weekendStyle: TextStyle(color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.8)),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: AppColors.onSurfaceVariantDark),
              outsideTextStyle: TextStyle(color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.4)),
              selectedDecoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: AppColors.onAccent, fontWeight: FontWeight.w600),
              todayDecoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 2),
              ),
              todayTextStyle: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
              markerDecoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                return Positioned(
                  bottom: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: events.take(3).map((_) => Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(right: 1),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    )).toList(),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${l10n.selectDateAndTime} — ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
        ),
        const SizedBox(height: 12),
        if (loading)
          const Center(child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: AppColors.accent),
          ))
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Column(
              children: _slotsForDay(appointments, selectedDay).map((slot) {
                final starting =
                    startingAppointmentsForSlot(appointments, selectedDay, slot);
                final continuations =
                    continuationAppointmentsForSlot(appointments, selectedDay, slot);
                return _TimeSlotRow(
                  slot: slot,
                  day: selectedDay,
                  startingAppointments: starting,
                  continuationAppointments: continuations,
                  l10n: l10n,
                  updatingId: updatingId,
                  onSlotTap: () => onCreateBooking(selectedDay, slot),
                  onAppointmentTap: onAppointmentTap,
                  onUpdateStatus: onUpdateStatus,
                  onComplete: onComplete,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _TimeSlotRow extends StatelessWidget {
  const _TimeSlotRow({
    required this.slot,
    required this.day,
    required this.startingAppointments,
    required this.continuationAppointments,
    required this.l10n,
    this.updatingId,
    required this.onSlotTap,
    required this.onAppointmentTap,
    required this.onUpdateStatus,
    this.onComplete,
  });

  final String slot;
  final DateTime day;
  final List<AdminAppointmentRecord> startingAppointments;
  final List<AdminAppointmentRecord> continuationAppointments;
  final AppLocalizations l10n;
  final String? updatingId;
  final VoidCallback onSlotTap;
  final ValueChanged<AdminAppointmentRecord> onAppointmentTap;
  final void Function(String id, String status) onUpdateStatus;
  final void Function(String id)? onComplete;

  @override
  Widget build(BuildContext context) {
    final isOccupied =
        startingAppointments.isNotEmpty || continuationAppointments.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderDark),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Text(
              slot,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: isOccupied
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...startingAppointments.map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _CalendarAppointmentChip(
                            record: a,
                            day: day,
                            slot: slot,
                            l10n: l10n,
                            isUpdating: updatingId == a.id,
                            onTap: () => onAppointmentTap(a),
                            onConfirm: () => onUpdateStatus(a.id, 'confirmed'),
                            onComplete:
                                onComplete != null ? () => onComplete!(a.id) : null,
                            onCancel: () => onUpdateStatus(a.id, 'cancelled'),
                          ),
                        ),
                      ),
                      ...continuationAppointments.map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _ContinuedAppointmentBlock(
                            record: a,
                            day: day,
                            slot: slot,
                            l10n: l10n,
                            onTap: () => onAppointmentTap(a),
                          ),
                        ),
                      ),
                    ],
                  )
                : _AddSlotChip(onTap: onSlotTap),
          ),
        ],
      ),
    );
  }
}

class _ContinuedAppointmentBlock extends StatelessWidget {
  const _ContinuedAppointmentBlock({
    required this.record,
    required this.day,
    required this.slot,
    required this.l10n,
    required this.onTap,
  });

  final AdminAppointmentRecord record;
  final DateTime day;
  final String slot;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final position = spanPosition(record, day, slot);
    final isCancelled = record.status == 'cancelled';
    final isCompleted = record.status == 'completed';
    final completedColor = const Color(0xFF1B5E20);
    final accentColor =
        isCancelled ? AppColors.error : isCompleted ? completedColor : AppColors.accent;
    final endLabel = formatTimeLabel(appointmentEnd(record));
    final showEndLabel = position == SpanPosition.end;

    BorderRadius borderRadius;
    switch (position) {
      case SpanPosition.end:
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        );
      case SpanPosition.middle:
        borderRadius = BorderRadius.zero;
      case SpanPosition.start:
      case SpanPosition.none:
        borderRadius = BorderRadius.circular(8);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isCancelled ? null : onTap,
        borderRadius: borderRadius,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: borderRadius,
            border: Border(
              left: BorderSide(color: accentColor.withValues(alpha: 0.7), width: 3),
              right: BorderSide(color: accentColor.withValues(alpha: 0.35)),
              top: position == SpanPosition.middle || position == SpanPosition.end
                  ? BorderSide.none
                  : BorderSide(color: accentColor.withValues(alpha: 0.35)),
              bottom: position == SpanPosition.middle || position == SpanPosition.start
                  ? BorderSide.none
                  : BorderSide(color: accentColor.withValues(alpha: 0.35)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: KhmerAwareText(
                  showEndLabel
                      ? '${record.name} · ${l10n.bookingUntilTime(endLabel)}'
                      : l10n.bookingContinued,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        fontStyle: FontStyle.italic,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarAppointmentChip extends StatelessWidget {
  const _CalendarAppointmentChip({
    required this.record,
    required this.day,
    required this.slot,
    required this.l10n,
    required this.isUpdating,
    required this.onTap,
    required this.onConfirm,
    this.onComplete,
    required this.onCancel,
  });

  final AdminAppointmentRecord record;
  final DateTime day;
  final String slot;
  final AppLocalizations l10n;
  final bool isUpdating;
  final VoidCallback onTap;
  final VoidCallback onConfirm;
  final VoidCallback? onComplete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final statusLabel = record.status == 'confirmed'
        ? l10n.statusConfirmed
        : record.status == 'cancelled'
            ? l10n.statusCancelled
            : record.status == 'completed'
                ? l10n.statusCompleted
                : l10n.statusPending;
    final isCancelled = record.status == 'cancelled';
    final isCompleted = record.status == 'completed';

    final completedColor = const Color(0xFF1B5E20);
    final durationHours = durationHoursLabel(effectiveDurationMinutes(record));
    final endLabel = formatTimeLabel(appointmentEnd(record));
    final durationLine =
        '${l10n.durationHours(durationHours)} · ${l10n.bookingUntilTime(endLabel)}';
    final spansMultipleHours = effectiveDurationMinutes(record) > 60;
    final borderColor = isCancelled
        ? AppColors.error.withValues(alpha: 0.5)
        : isCompleted
            ? completedColor.withValues(alpha: 0.5)
            : AppColors.accent.withValues(alpha: 0.5);
    final fillColor = isCancelled
        ? AppColors.error.withValues(alpha: 0.15)
        : isCompleted
            ? completedColor.withValues(alpha: 0.2)
            : AppColors.accent.withValues(alpha: 0.2);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isCancelled ? null : onTap,
        borderRadius: spansMultipleHours
            ? const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )
            : BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: spansMultipleHours
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )
                : BorderRadius.circular(8),
            border: Border(
              left: BorderSide(color: borderColor),
              right: BorderSide(color: borderColor),
              top: BorderSide(color: borderColor),
              bottom: spansMultipleHours ? BorderSide.none : BorderSide(color: borderColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KhmerAwareText(
                    record.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isCancelled ? AppColors.error.withValues(alpha: 0.3) : isCompleted ? completedColor.withValues(alpha: 0.5) : AppColors.accent.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isCancelled ? AppColors.error : isCompleted ? completedColor : AppColors.onAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                durationLine,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                record.serviceName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isCancelled && !isCompleted) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (record.status == 'pending')
                      TextButton(
                        onPressed: isUpdating ? null : onConfirm,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: isUpdating
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent))
                            : Text(l10n.confirmAppointment, style: const TextStyle(color: AppColors.accent, fontSize: 12)),
                      ),
                    if (onComplete != null)
                      TextButton(
                        onPressed: isUpdating ? null : onComplete,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(l10n.markAsCompleted, style: const TextStyle(color: Color(0xFF1B5E20), fontSize: 12)),
                      ),
                    TextButton(
                      onPressed: isUpdating ? null : onCancel,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(l10n.cancelBookingButton, style: const TextStyle(color: AppColors.error, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddSlotChip extends StatelessWidget {
  const _AddSlotChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.borderDark.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderDark, width: 1.5, strokeAlign: BorderSide.strokeAlignInside),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.plus, size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.addBooking,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w500,
                    ) ?? TextStyle(color: AppColors.accent, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog for admin to create a booking on behalf of a client.
Future<void> showCreateBookingDialog(
  BuildContext context, {
  required DateTime initialDate,
  required String initialTime,
  required VoidCallback onCreated,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  DateTime selectedDate = initialDate;
  String selectedTime = initialTime;
  int selectedServiceIndex = 0;
  String selectedSessionType = sessionTypeVisit;
  int selectedDurationMinutes = defaultSessionDurationMinutes;
  bool submitting = false;
  String? error;

  List<_ConsultationOption> getServices() => [
    _ConsultationOption(id: 'bazi', category: l10n.consult1Category, method: l10n.consult1Method),
    _ConsultationOption(id: 'fengshui', category: l10n.consult2Category, method: l10n.consult2Method),
    _ConsultationOption(id: 'dateselection', category: l10n.consult3Category, method: l10n.consult3Method),
    _ConsultationOption(id: 'qimeniching', category: l10n.consult4Category, method: l10n.consult4Method),
    _ConsultationOption(id: 'maosan', category: l10n.consult5Category, method: l10n.consult5Method),
    _ConsultationOption(id: 'publications', category: l10n.consult6Category, method: l10n.consult6Method),
  ];

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final services = getServices();
        final service = services[selectedServiceIndex];
        final serviceName = '${service.category} (${service.method})';

        final isNarrow = MediaQuery.sizeOf(context).width < Breakpoints.mobile;
        final maxContentHeight = MediaQuery.sizeOf(context).height * 0.75;

        return AlertDialog(
          backgroundColor: AppColors.surfaceElevatedDark,
          insetPadding: isNarrow
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
              : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          title: Text(
            l10n.createBookingFor,
            style: const TextStyle(color: AppColors.onPrimary),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 420,
                maxHeight: maxContentHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.appointmentName,
                      labelStyle: const TextStyle(color: AppColors.onSurfaceVariantDark),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    style: const TextStyle(color: AppColors.onPrimary),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.appointmentPhone,
                      labelStyle: const TextStyle(color: AppColors.onSurfaceVariantDark),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    style: const TextStyle(color: AppColors.onPrimary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.stepChooseService,
                    style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                    initialValue: selectedServiceIndex,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    dropdownColor: AppColors.surfaceElevatedDark,
                    items: List.generate(services.length, (i) => DropdownMenuItem(
                      value: i,
                      child: Text(services[i].category, style: const TextStyle(color: AppColors.onPrimary)),
                    )),
                    onChanged: (v) => setState(() => selectedServiceIndex = v ?? 0),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.sessionType,
                    style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: sessionTypeVisit, label: Text(l10n.sessionTypeVisit)),
                      ButtonSegment(value: sessionTypeOnline, label: Text(l10n.sessionTypeOnline)),
                    ],
                    selected: {selectedSessionType},
                    onSelectionChanged: (s) => setState(() => selectedSessionType = s.first),
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) return AppColors.onAccent;
                        return AppColors.onPrimary;
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) return AppColors.accent;
                        return AppColors.surfaceElevatedDark;
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.selectDuration,
                    style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectableDurationsMinutes.map((minutes) {
                      final selected = selectedDurationMinutes == minutes;
                      final hours = durationHoursLabel(minutes);
                      return ChoiceChip(
                        label: Text(l10n.durationHours(hours)),
                        selected: selected,
                        onSelected: (v) {
                          if (v) setState(() => selectedDurationMinutes = minutes);
                        },
                        selectedColor: AppColors.accent.withValues(alpha: 0.3),
                        side: BorderSide(
                          color: selected ? AppColors.accent : AppColors.borderDark,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.selectDateAndTime,
                    style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              builder: (ctx, child) => Theme(
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
                            if (date != null) setState(() => selectedDate = date);
                          },
                          icon: const Icon(LucideIcons.calendar, size: 18),
                          label: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onPrimary,
                            side: const BorderSide(color: AppColors.borderLight),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedTime,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                dropdownColor: AppColors.surfaceElevatedDark,
                                isExpanded: true,
                                items: [
                                  ..._timeSlots.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: AppColors.onPrimary)))),
                                  if (!_timeSlots.contains(selectedTime) && selectedTime.isNotEmpty)
                                    DropdownMenuItem(value: selectedTime, child: Text(selectedTime, style: const TextStyle(color: AppColors.onPrimary))),
                                  DropdownMenuItem(
                                    value: '__custom__',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.clock, size: 16, color: AppColors.accent),
                                        const SizedBox(width: 8),
                                        Text(l10n.customTime, style: const TextStyle(color: AppColors.accent)),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (v) async {
                                  if (v == '__custom__') {
                                    final initial = selectedTime.isNotEmpty
                                        ? (int.tryParse(selectedTime.split(':')[0]) ?? 8) * 60 + (int.tryParse(selectedTime.split(':').length > 1 ? selectedTime.split(':')[1] : '0') ?? 0)
                                        : 8 * 60;
                                    final t = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(hour: initial ~/ 60, minute: initial % 60),
                                      builder: (ctx, child) => Theme(
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
                                    if (t != null) {
                                      setState(() => selectedTime = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
                                    }
                                  } else if (v != null) {
                                    setState(() => selectedTime = v);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: IconButton(
                                onPressed: () async {
                                  final initial = selectedTime.isNotEmpty
                                      ? (int.tryParse(selectedTime.split(':')[0]) ?? 8) * 60 + (int.tryParse(selectedTime.split(':').length > 1 ? selectedTime.split(':')[1] : '0') ?? 0)
                                      : 8 * 60;
                                  final t = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: initial ~/ 60, minute: initial % 60),
                                    builder: (ctx, child) => Theme(
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
                                  if (t != null) {
                                    setState(() => selectedTime = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
                                  }
                                },
                                icon: Icon(LucideIcons.clock, color: AppColors.accent, size: 20),
                                tooltip: l10n.customTime,
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.borderDark.withValues(alpha: 0.3),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noteController,
                    minLines: 3,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      labelText: l10n.note,
                      hintText: l10n.noteHint,
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(color: AppColors.onSurfaceVariantDark),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    style: const TextStyle(color: AppColors.onPrimary),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(error!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close, style: const TextStyle(color: AppColors.accent)),
            ),
            FilledButton(
              onPressed: submitting ? null : () async {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();
                if (name.isEmpty || phone.isEmpty) {
                  setState(() => error = l10n.pleaseEnterNameAndPhone);
                  return;
                }
                setState(() {
                  submitting = true;
                  error = null;
                });
                final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                try {
                  final availability = await getAvailableSlots(
                    dateStr,
                    durationMinutes: selectedDurationMinutes,
                  );
                  if (!availability.slots.contains(selectedTime)) {
                    if (!context.mounted) return;
                    setState(() {
                      error = l10n.slotTimeNotAvailable;
                      submitting = false;
                    });
                    return;
                  }
                  final note = noteController.text.trim();
                  final result = await submitAppointmentBooking(
                    name: name,
                    phone: phone,
                    serviceId: service.id,
                    serviceName: serviceName,
                    date: dateStr,
                    time: selectedTime,
                    sessionType: selectedSessionType,
                    notes: note.isEmpty ? null : note,
                    durationMinutes: selectedDurationMinutes,
                    createdByAdmin: true,
                  );
                  if (!context.mounted) return;
                  if (result.success) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.bookingCreated), backgroundColor: AppColors.accent),
                    );
                    onCreated();
                  } else {
                    setState(() {
                      error = result.errorMessage ?? l10n.errorCreatingBooking;
                      submitting = false;
                    });
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  setState(() {
                    error = AppError.fromException(e, l10n: l10n).userMessage;
                    submitting = false;
                  });
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
              ),
              child: submitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent))
                  : Text(l10n.createBooking),
            ),
          ],
        );
      },
    ),
  );
  noteController.dispose();
}
