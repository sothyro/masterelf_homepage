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
import '../../services/appointment_booking_service.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorUpdatingStatus),
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

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 120,
            bottom: 48,
            left: isNarrow ? 16 : 32,
            right: isNarrow ? 16 : 32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Breadcrumb(items: [
                    (label: l10n.home, route: '/'),
                    (label: l10n.consultations, route: '/appointments'),
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
                            onPressed: () => context.go('/appointments'),
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
                  _buildStatsCards(context, l10n, total, pending, confirmed, cancelled),
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
              onPressed: () => context.go('/appointments'),
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

  Widget _buildStatsCards(
    BuildContext context,
    AppLocalizations l10n,
    int total,
    int pending,
    int confirmed,
    int cancelled,
  ) {
    final cards = [
      (l10n.dashboardStatsTotal, total, LucideIcons.calendarCheck, AppColors.accent),
      (l10n.dashboardStatsPending, pending, LucideIcons.clock, AppColors.accent.withValues(alpha: 0.8)),
      (l10n.dashboardStatsConfirmed, confirmed, LucideIcons.checkCircle, const Color(0xFF2E7D32)),
      (l10n.dashboardStatsCancelled, cancelled, LucideIcons.xCircle, AppColors.error),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth < 600 ? 2 : 4;
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
              a.status == 'confirmed' ? l10n.statusConfirmed : a.status == 'cancelled' ? l10n.statusCancelled : l10n.statusPending,
              style: TextStyle(
                color: a.status == 'cancelled' ? AppColors.error : AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close, style: const TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleAndFilters(BuildContext context, AppLocalizations l10n) {
    return Row(
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
        Text(
          l10n.filterByStatus,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
        ),
        const SizedBox(width: 12),
        SegmentedButton<String?>(
          segments: [
            ButtonSegment(value: null, label: Text(l10n.filterAll)),
            ButtonSegment(value: 'pending', label: Text(l10n.statusPending)),
            ButtonSegment(value: 'confirmed', label: Text(l10n.statusConfirmed)),
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
        const Spacer(),
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
            : l10n.statusPending;
    final isUpdating = _updatingId == a.id;

    return DataRow(
      cells: [
        DataCell(Text(a.bookingReference, style: const TextStyle(color: AppColors.accent, fontFamily: 'monospace'))),
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
                  : AppColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: a.status == 'cancelled' ? AppColors.error : AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          a.status == 'cancelled'
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
    required this.onCancel,
  });

  final AdminAppointmentRecord record;
  final AppLocalizations l10n;
  final bool isUpdating;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final statusLabel = record.status == 'confirmed'
        ? l10n.statusConfirmed
        : record.status == 'cancelled'
            ? l10n.statusCancelled
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
                        : AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: record.status == 'cancelled' ? AppColors.error : AppColors.accent,
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
            if (record.status != 'cancelled') ...[
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
