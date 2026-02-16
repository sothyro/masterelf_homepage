import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../l10n/app_localizations.dart';
import '../../models/appointment.dart' show AdminAppointmentRecord, defaultSessionDurationMinutes, sessionTypeOnline, sessionTypeVisit;
import '../../theme/app_theme.dart';
import '../../services/appointment_booking_service.dart' show submitAppointmentBooking;

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

/// Default time slots (2h session, 1h break): 09:00, 12:00, 15:00, 18:00, 21:00 (special: 1h or 2h to 23:00)
const List<String> _timeSlots = ['09:00', '12:00', '15:00', '18:00', '21:00'];

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

bool _appointmentMatchesSlot(AdminAppointmentRecord a, DateTime day, String slot) {
  if (a.status == 'cancelled') return false;
  final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
  if (a.date != dateStr) return false;
  return a.time == slot;
}

List<AdminAppointmentRecord> _appointmentsForSlot(
  List<AdminAppointmentRecord> all,
  DateTime day,
  String slot,
) {
  return all.where((a) => _appointmentMatchesSlot(a, day, slot)).toList();
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
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 900;

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
            calendarFormat: isNarrow ? CalendarFormat.month : CalendarFormat.month,
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
                final slotAppointments = _appointmentsForSlot(appointments, selectedDay, slot);
                return _TimeSlotRow(
                  slot: slot,
                  appointments: slotAppointments,
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
    required this.appointments,
    required this.l10n,
    this.updatingId,
    required this.onSlotTap,
    required this.onAppointmentTap,
    required this.onUpdateStatus,
    this.onComplete,
  });

  final String slot;
  final List<AdminAppointmentRecord> appointments;
  final AppLocalizations l10n;
  final String? updatingId;
  final VoidCallback onSlotTap;
  final ValueChanged<AdminAppointmentRecord> onAppointmentTap;
  final void Function(String id, String status) onUpdateStatus;
  final void Function(String id)? onComplete;

  @override
  Widget build(BuildContext context) {
    final hasAppointments = appointments.isNotEmpty;

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
            child: hasAppointments
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...appointments.map((a) => _CalendarAppointmentChip(
                        record: a,
                        l10n: l10n,
                        isUpdating: updatingId == a.id,
                        onTap: () => onAppointmentTap(a),
                        onConfirm: () => onUpdateStatus(a.id, 'confirmed'),
                        onComplete: onComplete != null ? () => onComplete!(a.id) : null,
                        onCancel: () => onUpdateStatus(a.id, 'cancelled'),
                      )),
                      _AddSlotChip(onTap: onSlotTap),
                    ],
                  )
                : _AddSlotChip(onTap: onSlotTap),
          ),
        ],
      ),
    );
  }
}

class _CalendarAppointmentChip extends StatelessWidget {
  const _CalendarAppointmentChip({
    required this.record,
    required this.l10n,
    required this.isUpdating,
    required this.onTap,
    required this.onConfirm,
    this.onComplete,
    required this.onCancel,
  });

  final AdminAppointmentRecord record;
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isCancelled ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isCancelled
                ? AppColors.error.withValues(alpha: 0.15)
                : isCompleted
                    ? completedColor.withValues(alpha: 0.2)
                    : AppColors.accent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCancelled ? AppColors.error.withValues(alpha: 0.5) : isCompleted ? completedColor.withValues(alpha: 0.5) : AppColors.accent.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
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

        return AlertDialog(
          backgroundColor: AppColors.surfaceElevatedDark,
          title: Text(
            l10n.createBookingFor,
            style: const TextStyle(color: AppColors.onPrimary),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
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
                    value: selectedServiceIndex,
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
                                value: selectedTime,
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
                                        ? (int.tryParse(selectedTime.split(':')[0]) ?? 9) * 60 + (int.tryParse(selectedTime.split(':').length > 1 ? selectedTime.split(':')[1] : '0') ?? 0)
                                        : 9 * 60;
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
                                      ? (int.tryParse(selectedTime.split(':')[0]) ?? 9) * 60 + (int.tryParse(selectedTime.split(':').length > 1 ? selectedTime.split(':')[1] : '0') ?? 0)
                                      : 9 * 60;
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
                    durationMinutes: defaultSessionDurationMinutes,
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
                    error = e.toString();
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
