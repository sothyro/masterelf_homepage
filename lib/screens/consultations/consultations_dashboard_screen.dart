import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/appointment.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/breadcrumb.dart';
import '../../services/appointment_booking_service.dart' show getAllAppointments, updateAppointment, updateAppointmentStatus;
import 'dashboard_calendar.dart';

class AppointmentsDashboardScreen extends StatefulWidget {
  const AppointmentsDashboardScreen({super.key});

  @override
  State<AppointmentsDashboardScreen> createState() =>
      _AppointmentsDashboardScreenState();
}

class _AppointmentsDashboardScreenState extends State<AppointmentsDashboardScreen> {
  List<AdminAppointmentRecord> _appointments = [];
  bool _loading = false;
  String? _error;
  String? _statusFilter;
  String? _updatingId;
  bool _calendarView = true;
  DateTime _calendarFocusedDay = DateTime.now();
  DateTime _calendarSelectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await getAllAppointments(
        statusFilter: _statusFilter,
        limit: 200,
      );
      if (!mounted) return;
      setState(() {
        _appointments = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    setState(() => _updatingId = id);
    try {
      await updateAppointmentStatus(id, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.statusUpdated),
          backgroundColor: AppColors.accent,
        ),
      );
      await _loadAppointments();
    } catch (e) {
      if (!mounted) return;
      final msg = e is FirebaseFunctionsException
          ? (e.message ?? AppLocalizations.of(context)!.errorUpdatingStatus)
          : AppLocalizations.of(context)!.errorUpdatingStatus;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _updatingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    if (!auth.isLoggedIn) {
      return _buildLoginRequired(context, l10n);
    }

    final total = _appointments.length;
    final pending = _appointments.where((a) => a.status == 'pending').length;
    final confirmed = _appointments.where((a) => a.status == 'confirmed').length;
    final cancelled = _appointments.where((a) => a.status == 'cancelled').length;
    final completed = _appointments.where((a) => a.status == 'completed').length;

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 120,
            bottom: 48,
            left: isNarrow ? 16 : 24,
            right: isNarrow ? 16 : 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Breadcrumb(items: [
                    (label: l10n.home, route: '/'),
                    (label: l10n.consultations, route: '/consultations'),
                    (label: l10n.dashboardTitle, route: null),
                  ]),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dashboardTitle,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.dashboardSubtitle,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.onSurfaceVariantDark,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          TextButton.icon(
                            onPressed: () => context.go('/consultations'),
                            icon: const Icon(LucideIcons.arrowLeft),
                            label: Text(l10n.back),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.accent,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: auth.signOut,
                            icon: const Icon(LucideIcons.logOut, size: 18),
                            label: Text(l10n.logoutButton),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.onPrimary,
                              side: const BorderSide(color: AppColors.borderLight),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildStatsCards(context, l10n, total, pending, confirmed, cancelled, completed),
                  const SizedBox(height: 32),
                  _buildViewToggleAndFilters(context, l10n),
                  const SizedBox(height: 24),
                  if (_error != null) _buildError(context, l10n),
                  if (_loading) _buildLoading(context, l10n),
                  if (!_loading && _error == null) ...[
                    if (_calendarView)
                      DashboardCalendar(
                        appointments: _appointments,
                        focusedDay: _calendarFocusedDay,
                        selectedDay: _calendarSelectedDay,
                        onDaySelected: (day) {
                          setState(() {
                            _calendarSelectedDay = day;
                            _calendarFocusedDay = day;
                          });
                        },
                        onPageChanged: (day) {
                          setState(() => _calendarFocusedDay = day);
                        },
                        onAppointmentTap: (a) => _showAppointmentDetail(context, l10n, a),
                        onCreateBooking: (date, time) async {
                          await showCreateBookingDialog(
                            context,
                            initialDate: date,
                            initialTime: time,
                            onCreated: _loadAppointments,
                          );
                        },
                        loading: _loading,
                        updatingId: _updatingId,
                        onUpdateStatus: _updateStatus,
                        onComplete: (id) => _updateStatus(id, 'completed'),
                      )
                    else
                      _buildAppointmentsTable(context, l10n, isNarrow),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRequired(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.lock, size: 64, color: AppColors.accent),
              const SizedBox(height: 24),
              Text(
                l10n.loginRequired,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onPrimary,
                    ),
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
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    AppLocalizations l10n,
    int total,
    int pending,
    int confirmed,
    int cancelled,
    int completed,
  ) {
    final cards = [
      (l10n.dashboardStatsTotal, total, LucideIcons.calendarCheck, AppColors.accent),
      (l10n.dashboardStatsPending, pending, LucideIcons.clock, AppColors.accent.withValues(alpha: 0.8)),
      (l10n.dashboardStatsConfirmed, confirmed, LucideIcons.checkCircle, const Color(0xFF2E7D32)),
      (l10n.dashboardStatsCancelled, cancelled, LucideIcons.xCircle, AppColors.error),
      (l10n.dashboardStatsCompleted, completed, LucideIcons.checkCircle2, const Color(0xFF1B5E20)),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth < 600 ? 2 : 5;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: cards.map((c) => _StatCard(
            title: c.$1,
            count: c.$2,
            icon: c.$3,
            color: c.$4,
          )).toList(),
        );
      },
    );
  }

  void _showAppointmentDetail(BuildContext context, AppLocalizations l10n, AdminAppointmentRecord a) {
    final sessionLabel = a.sessionType == 'ONLINE' ? l10n.sessionTypeOnline : l10n.sessionTypeVisit;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevatedDark,
        title: Text(a.bookingReference, style: const TextStyle(color: AppColors.accent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.appointmentName}: ${a.name}', style: const TextStyle(color: AppColors.onPrimary)),
            Text('${l10n.appointmentPhone}: ${a.phone}', style: const TextStyle(color: AppColors.onPrimary)),
            Text('${l10n.stepChooseService}: ${a.serviceName}', style: const TextStyle(color: AppColors.onPrimary)),
            Text('${l10n.sessionType}: $sessionLabel', style: const TextStyle(color: AppColors.onPrimary)),
            Text('${a.date} · ${a.time}', style: const TextStyle(color: AppColors.onSurfaceVariantDark)),
            if (a.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l10n.note, style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 12)),
              Text(a.notes, style: const TextStyle(color: AppColors.onPrimary)),
            ],
            const SizedBox(height: 8),
            Text(
              a.status == 'confirmed' ? l10n.statusConfirmed : a.status == 'cancelled' ? l10n.statusCancelled : a.status == 'completed' ? l10n.statusCompleted : l10n.statusPending,
              style: TextStyle(
                color: a.status == 'cancelled' ? AppColors.error : a.status == 'completed' ? const Color(0xFF1B5E20) : AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          if (a.status != 'cancelled' && a.status != 'completed')
            TextButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                _showEditAppointmentTime(context, l10n, a);
              },
              icon: const Icon(LucideIcons.clock, size: 18),
              label: Text(l10n.editTime, style: const TextStyle(color: AppColors.accent)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close, style: const TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditAppointmentTime(BuildContext context, AppLocalizations l10n, AdminAppointmentRecord a) async {
    DateTime selectedDate = _parseDate(a.date) ?? DateTime.now();
    String selectedTime = a.time;
    const predefinedSlots = ['09:00', '12:00', '15:00', '18:00', '21:00'];
    bool updating = false;
    String? error;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.surfaceElevatedDark,
          title: Text(l10n.editTime, style: const TextStyle(color: AppColors.accent)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${l10n.bookingReference}: ${a.bookingReference}', style: const TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 12)),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
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
                        if (date != null) setState(() => selectedDate = date);
                      },
                      icon: const Icon(LucideIcons.calendar, size: 18),
                      label: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.onPrimary, side: const BorderSide(color: AppColors.borderLight)),
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
                              ...predefinedSlots.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: AppColors.onPrimary)))),
                              if (!predefinedSlots.contains(selectedTime) && selectedTime.isNotEmpty)
                                DropdownMenuItem(value: selectedTime, child: Text(selectedTime, style: const TextStyle(color: AppColors.onPrimary))),
                            ],
                            onChanged: (v) => setState(() => selectedTime = v ?? selectedTime),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: IconButton(
                            onPressed: () async {
                              final parts = selectedTime.split(':');
                              final initial = (int.tryParse(parts.isNotEmpty ? parts[0] : '9') ?? 9) * 60 + (int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0);
                              final t = await showTimePicker(
                                context: ctx,
                                initialTime: TimeOfDay(hour: initial ~/ 60, minute: initial % 60),
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
                              if (t != null) setState(() => selectedTime = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
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
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.close, style: const TextStyle(color: AppColors.accent)),
            ),
            FilledButton(
              onPressed: updating
                  ? null
                  : () async {
                      setState(() { updating = true; error = null; });
                      try {
                        final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                        await updateAppointment(a.id, dateStr, selectedTime);
                        if (!ctx.mounted) return;
                        Navigator.pop(ctx, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.statusUpdated), backgroundColor: AppColors.accent),
                        );
                        await _loadAppointments();
                      } catch (e) {
                        if (!ctx.mounted) return;
                        setState(() {
                          updating = false;
                          error = e is FirebaseFunctionsException ? e.message : e.toString();
                        });
                      }
                    },
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent),
              child: updating ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent)) : Text(l10n.reschedule),
            ),
          ],
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  DateTime? _parseDate(String dateStr) {
    final parts = dateStr.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  Widget _buildViewToggleAndFilters(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(l10n.calendarView), icon: const Icon(LucideIcons.calendar, size: 18)),
              ButtonSegment(value: false, label: Text(l10n.listView), icon: const Icon(LucideIcons.list, size: 18)),
            ],
            selected: {_calendarView},
            onSelectionChanged: (s) => setState(() => _calendarView = s.first),
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
          const SizedBox(width: 24),
          SegmentedButton<String?>(
            segments: [
              ButtonSegment(value: null, label: Text(l10n.filterAll)),
              ButtonSegment(value: 'pending', label: Text(l10n.statusPending)),
              ButtonSegment(value: 'confirmed', label: Text(l10n.statusConfirmed)),
              ButtonSegment(value: 'completed', label: Text(l10n.statusCompleted)),
              ButtonSegment(value: 'cancelled', label: Text(l10n.statusCancelled)),
            ],
            selected: {_statusFilter},
            onSelectionChanged: (s) {
              setState(() {
                _statusFilter = s.isEmpty ? null : s.first;
                _loadAppointments();
              });
            },
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
          const SizedBox(width: 24),
          TextButton.icon(
            onPressed: () async {
              await showCreateBookingDialog(
                context,
                initialDate: _calendarView ? _calendarSelectedDay : DateTime.now(),
                initialTime: '09:00',
                onCreated: _loadAppointments,
              );
            },
            icon: const Icon(LucideIcons.plus, size: 18),
            label: Text(l10n.createBooking),
            style: TextButton.styleFrom(foregroundColor: AppColors.accent),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _loading ? null : _loadAppointments,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                  )
                : const Icon(LucideIcons.refreshCw, size: 18),
            label: Text(l10n.refresh),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.alertCircle, color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error ?? l10n.errorLoadingAppointments,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: _loadAppointments,
            child: Text(l10n.refresh, style: const TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
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
    );
  }

  Widget _buildAppointmentsTable(
    BuildContext context,
    AppLocalizations l10n,
    bool isNarrow,
  ) {
    if (_appointments.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Column(
            children: [
              Icon(LucideIcons.calendarX, size: 48, color: AppColors.onSurfaceVariantDark),
              const SizedBox(height: 16),
              Text(
                l10n.noAppointments,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    if (isNarrow) {
      return Column(
        children: _appointments.map((a) => _DashboardAppointmentCard(
          record: a,
          l10n: l10n,
          isUpdating: _updatingId == a.id,
          onConfirm: () => _updateStatus(a.id, 'confirmed'),
          onComplete: () => _updateStatus(a.id, 'completed'),
          onCancel: () => _updateStatus(a.id, 'cancelled'),
        )).toList(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primary),
          columns: [
            DataColumn(label: Text(l10n.bookingReference, style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600))),
            DataColumn(label: Text(l10n.appointmentName, style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600))),
            DataColumn(label: Text(l10n.appointmentPhone, style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600))),
            DataColumn(label: Text(l10n.stepChooseService, style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600))),
            DataColumn(label: Text(l10n.stepDateAndTime, style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600))),
            DataColumn(label: Text(l10n.statusColumn, style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600))),
            const DataColumn(label: SizedBox(width: 140)),
          ],
          rows: _appointments.map((a) => _buildDataRow(context, l10n, a)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
    BuildContext context,
    AppLocalizations l10n,
    AdminAppointmentRecord a,
  ) {
    final statusLabel = a.status == 'confirmed'
        ? l10n.statusConfirmed
        : a.status == 'cancelled'
            ? l10n.statusCancelled
            : a.status == 'completed'
                ? l10n.statusCompleted
                : l10n.statusPending;
    final isUpdating = _updatingId == a.id;

    return DataRow(
      cells: [
        DataCell(Text(a.bookingReference, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.accent))),
        DataCell(Text(a.name, style: const TextStyle(color: AppColors.onPrimary))),
        DataCell(Text(a.phone, style: const TextStyle(color: AppColors.onPrimary))),
        DataCell(Text(a.serviceName, style: const TextStyle(color: AppColors.onPrimary))),
        DataCell(Text('${a.date} ${a.time}', style: const TextStyle(color: AppColors.onPrimary))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: a.status == 'cancelled'
                  ? AppColors.error.withValues(alpha: 0.2)
                  : a.status == 'completed'
                      ? const Color(0xFF1B5E20).withValues(alpha: 0.2)
                      : AppColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: a.status == 'cancelled' ? AppColors.error : a.status == 'completed' ? const Color(0xFF1B5E20) : AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          a.status == 'cancelled' || a.status == 'completed'
              ? const SizedBox.shrink()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (a.status == 'pending')
                      TextButton(
                        onPressed: isUpdating ? null : () => _updateStatus(a.id, 'confirmed'),
                        child: isUpdating
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent))
                            : Text(l10n.confirmAppointment, style: const TextStyle(color: AppColors.accent)),
                      ),
                    TextButton(
                      onPressed: isUpdating ? null : () => _updateStatus(a.id, 'completed'),
                      child: Text(l10n.markAsCompleted, style: const TextStyle(color: Color(0xFF1B5E20))),
                    ),
                    TextButton(
                      onPressed: isUpdating ? null : () => _updateStatus(a.id, 'cancelled'),
                      child: Text(l10n.cancelBookingButton, style: const TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                ),
                Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardAppointmentCard extends StatelessWidget {
  const _DashboardAppointmentCard({
    required this.record,
    required this.l10n,
    required this.isUpdating,
    required this.onConfirm,
    required this.onComplete,
    required this.onCancel,
  });

  final AdminAppointmentRecord record;
  final AppLocalizations l10n;
  final bool isUpdating;
  final VoidCallback onConfirm;
  final VoidCallback onComplete;
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surfaceElevatedDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  record.bookingReference,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: record.status == 'cancelled'
                        ? AppColors.error.withValues(alpha: 0.2)
                        : record.status == 'completed'
                            ? const Color(0xFF1B5E20).withValues(alpha: 0.2)
                            : AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: record.status == 'cancelled' ? AppColors.error : record.status == 'completed' ? const Color(0xFF1B5E20) : AppColors.accent,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(record.name, style: const TextStyle(color: AppColors.onPrimary)),
            Text(record.phone, style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 14)),
            Text(record.serviceName, style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w500)),
            Text('${record.date} · ${record.time}', style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 14)),
            if (record.status != 'cancelled' && record.status != 'completed') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (record.status == 'pending')
                    TextButton(
                      onPressed: isUpdating ? null : onConfirm,
                      child: isUpdating
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent))
                          : Text(l10n.confirmAppointment, style: const TextStyle(color: AppColors.accent)),
                    ),
                  TextButton(
                    onPressed: isUpdating ? null : onComplete,
                    child: Text(l10n.markAsCompleted, style: const TextStyle(color: Color(0xFF1B5E20))),
                  ),
                  TextButton(
                    onPressed: isUpdating ? null : onCancel,
                    child: Text(l10n.cancelBookingButton, style: const TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
