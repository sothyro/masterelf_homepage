import 'dart:math' as math;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/confirm_cancel_dialog.dart';
import '../../widgets/login_dialog.dart';
import '../../models/appointment.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../services/appointment_booking_service.dart' show getAllAppointments, updateAppointment, updateAppointmentStatus;
import '../../services/appointment_list_pdf_service.dart';
import '../../services/error_service.dart' show AppError, executeWithRetry;
import '../../widgets/khmer_aware_text.dart';
import '../../widgets/page_content_inset.dart';
import 'dashboard_calendar.dart';

const double _kAppointmentTableMinWidth = 880;
const int _kAppointmentsPerPageDesktop = 15;
const int _kAppointmentsPerPageMobile = 5;

/// Visible for widget tests verifying pagination size.
@visibleForTesting
const int kDashboardAppointmentsPerPageDesktop = _kAppointmentsPerPageDesktop;

@visibleForTesting
const int kDashboardAppointmentsPerPageMobile = _kAppointmentsPerPageMobile;

@visibleForTesting
int dashboardAppointmentsPerPageFor(double viewportWidth) =>
    Breakpoints.isMobile(viewportWidth)
        ? _kAppointmentsPerPageMobile
        : _kAppointmentsPerPageDesktop;
const int _kMinVisibleListRows = 5;
const double _kDataTableHeadingHeight = 56;
const double _kDataTableRowHeight = 48;
const double _kAppointmentCardGap = 6;
const double _kAppointmentCardSlotHeight = 120;

double _tableListHeightFor(int visibleRows) =>
    _kDataTableHeadingHeight + visibleRows * _kDataTableRowHeight;

double _cardListHeightFor(int visibleRows) =>
    visibleRows * _kAppointmentCardSlotHeight +
    math.max(0, visibleRows - 1) * _kAppointmentCardGap;

String _displayServiceName(String serviceName) {
  final open = serviceName.lastIndexOf(' (');
  if (open > 0 && serviceName.endsWith(')')) {
    return serviceName.substring(0, open);
  }
  return serviceName;
}

TextStyle _dashboardTextStyle(
  BuildContext context, {
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
}) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
    color: color ?? AppColors.onPrimary,
    fontWeight: fontWeight,
    fontSize: fontSize,
  );
}

class AppointmentsDashboardScreen extends StatefulWidget {
  const AppointmentsDashboardScreen({super.key});

  @override
  State<AppointmentsDashboardScreen> createState() =>
      _AppointmentsDashboardScreenState();
}

class _AppointmentsDashboardScreenState extends State<AppointmentsDashboardScreen> {
  List<AdminAppointmentRecord> _appointments = [];
  bool _loading = false;
  bool _exportingPdf = false;
  String? _error;
  String? _statusFilter;
  String? _updatingId;
  bool _calendarView = true;
  int _listPageIndex = 0;
  int _appointmentsPerPage = _kAppointmentsPerPageDesktop;
  final TextEditingController _listSearchController = TextEditingController();
  DateTime _calendarFocusedDay = DateTime.now();
  DateTime _calendarSelectedDay = DateTime.now();
  bool _loadScheduled = false;
  AuthProvider? _authProvider;

  @override
  void initState() {
    super.initState();
    _listSearchController.addListener(_onListSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthProvider>();
    if (_authProvider != auth) {
      _authProvider?.removeListener(_onAuthChanged);
      _authProvider = auth;
      auth.addListener(_onAuthChanged);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleLoadIfAuthenticated());
  }

  void _onAuthChanged() {
    if (!mounted) return;
    if (_authProvider?.isLoggedIn == true) {
      _scheduleLoadIfAuthenticated();
    } else {
      setState(() {
        _loadScheduled = false;
        _appointments = [];
        _error = null;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _authProvider?.removeListener(_onAuthChanged);
    _listSearchController.removeListener(_onListSearchChanged);
    _listSearchController.dispose();
    super.dispose();
  }

  void _onListSearchChanged() {
    setState(() => _listPageIndex = 0);
  }

  void _scheduleLoadIfAuthenticated() {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      _loadScheduled = false;
      return;
    }
    if (_loadScheduled || _loading) return;
    _loadScheduled = true;
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    if (!mounted) return;
    if (!context.read<AuthProvider>().isLoggedIn) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context)!;
    try {
      final list = await executeWithRetry(
        operation: () => getAllAppointments(
          statusFilter: _statusFilter,
          limit: 200,
        ),
        maxRetries: 2,
        l10n: l10n,
      );
      if (!mounted) return;
      setState(() {
        _appointments = list;
        _loading = false;
        _clampListPage();
      });
    } catch (e) {
      if (!mounted) return;
      final appError = AppError.fromException(e, l10n: l10n);
      setState(() {
        _error = appError.userMessage;
        _loading = false;
      });
    }
  }

  void _clampListPage() {
    if (_filteredAppointments.isEmpty) {
      _listPageIndex = 0;
      return;
    }
    final maxPage = math.max(0, (_filteredAppointments.length / _appointmentsPerPage).ceil() - 1);
    if (_listPageIndex > maxPage) _listPageIndex = maxPage;
  }

  List<AdminAppointmentRecord> get _filteredAppointments {
    final query = _listSearchController.text.trim().toLowerCase();
    if (query.isEmpty) return _appointments;
    return _appointments.where((a) => _matchesListSearch(a, query)).toList();
  }

  bool _matchesListSearch(AdminAppointmentRecord a, String query) {
    return a.name.toLowerCase().contains(query) ||
        a.phone.toLowerCase().contains(query) ||
        a.bookingReference.toLowerCase().contains(query) ||
        a.serviceName.toLowerCase().contains(query) ||
        _displayServiceName(a.serviceName).toLowerCase().contains(query) ||
        a.date.toLowerCase().contains(query) ||
        a.time.toLowerCase().contains(query) ||
        a.status.toLowerCase().contains(query) ||
        a.notes.toLowerCase().contains(query);
  }

  List<AdminAppointmentRecord> get _paginatedAppointments {
    final filtered = _filteredAppointments;
    if (filtered.isEmpty) return const [];
    final start = _listPageIndex * _appointmentsPerPage;
    if (start >= filtered.length) return const [];
    final end = math.min(start + _appointmentsPerPage, filtered.length);
    return filtered.sublist(start, end);
  }

  int get _listPageCount => _filteredAppointments.isEmpty
      ? 1
      : (_filteredAppointments.length / _appointmentsPerPage).ceil();

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'confirmed':
        return l10n.statusConfirmed;
      case 'cancelled':
        return l10n.statusCancelled;
      case 'completed':
        return l10n.statusCompleted;
      default:
        return l10n.statusPending;
    }
  }

  int get _listVisibleRowCount {
    final count = _paginatedAppointments.length;
    if (count == 0) return _kMinVisibleListRows;
    return math.max(count, _kMinVisibleListRows).clamp(1, _appointmentsPerPage);
  }

  Future<void> _requestStatusUpdate(String id, String status) async {
    if (status == 'cancelled') {
      final confirmed = await showCancelBookingConfirm(context);
      if (!confirmed || !mounted) return;
    }
    await _updateStatus(id, status);
  }

  Future<void> _exportAppointmentsPdf(AppLocalizations l10n) async {
    final records = _filteredAppointments;
    if (records.isEmpty || _exportingPdf) return;

    setState(() => _exportingPdf = true);
    try {
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final bytes = await generateAppointmentsListPdf(
        appointments: records,
        labels: AppointmentListPdfLabels(
          title: l10n.appointmentsListPdfTitle,
          ref: l10n.bookingReference,
          name: l10n.appointmentName,
          phone: l10n.appointmentPhone,
          service: l10n.stepChooseService,
          dateTime: l10n.stepDateAndTime,
          status: l10n.statusColumn,
          generatedOn: '$dateStr · ${records.length}',
        ),
        statusLabel: (a) => _statusLabel(l10n, a.status),
        displayServiceName: _displayServiceName,
      );
      final ok = await saveAppointmentsListPdf(bytes, 'appointments-list-$dateStr.pdf');
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.appointmentsPdfExportStarted),
            backgroundColor: AppColors.accent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.appointmentsPdfExportFailed),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.appointmentsPdfExportFailed),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _exportingPdf = false);
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
    final nextPerPage = dashboardAppointmentsPerPageFor(width);
    if (nextPerPage != _appointmentsPerPage) {
      _appointmentsPerPage = nextPerPage;
      _clampListPage();
    }

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
          padding: pageContentPadding(context, bottom: 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isNarrow)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dashboardTitle,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                        const SizedBox(height: 16),
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
                    )
                  else
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
                  _buildStatsCards(
                    context,
                    l10n,
                    total,
                    pending,
                    confirmed,
                    cancelled,
                    completed,
                    statusFilterActive: _statusFilter != null,
                  ),
                  const SizedBox(height: 32),
                  _buildViewToggleAndFilters(context, l10n),
                  if (_calendarView) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.switchToListToSearchExport,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
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
                        onUpdateStatus: _requestStatusUpdate,
                        onComplete: (id) => _requestStatusUpdate(id, 'completed'),
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
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
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
              if (isNarrow)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () => showLoginDialog(
                        context,
                        successActions: [
                          (label: l10n.dashboardTitle, route: '/consultations/dashboard'),
                          (label: l10n.inspectionDashboardTitle, route: '/consultations/inspection-dashboard'),
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
                          (label: l10n.dashboardTitle, route: '/consultations/dashboard'),
                          (label: l10n.inspectionDashboardTitle, route: '/consultations/inspection-dashboard'),
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
    int completed, {
    bool statusFilterActive = false,
  }) {
    final cards = [
      (statusFilterActive ? l10n.dashboardStatsFilteredTotal : l10n.dashboardStatsTotal, total, LucideIcons.calendarCheck, AppColors.accent),
      (l10n.dashboardStatsPending, pending, LucideIcons.clock, AppColors.accent.withValues(alpha: 0.8)),
      (l10n.dashboardStatsConfirmed, confirmed, LucideIcons.checkCircle, const Color(0xFF2E7D32)),
      (l10n.dashboardStatsCancelled, cancelled, LucideIcons.xCircle, AppColors.error),
      (l10n.dashboardStatsCompleted, completed, LucideIcons.checkCircle2, const Color(0xFF1B5E20)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isMobile(constraints.maxWidth)) {
          final totalCard = cards.first;
          final detailCards = cards.sublist(1);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatCard(
                title: totalCard.$1,
                count: totalCard.$2,
                icon: totalCard.$3,
                color: totalCard.$4,
                emphasized: true,
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.75,
                children: [
                  for (final c in detailCards)
                    _StatCard(
                      title: c.$1,
                      count: c.$2,
                      icon: c.$3,
                      color: c.$4,
                      compact: true,
                    ),
                ],
              ),
            ],
          );
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: [
            for (final c in cards)
              _StatCard(
                title: c.$1,
                count: c.$2,
                icon: c.$3,
                color: c.$4,
              ),
          ],
        );
      },
    );
  }

  ButtonStyle _dashboardSegmentedStyle() {
    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.onAccent;
        return AppColors.onPrimary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.accent;
        return AppColors.surfaceElevatedDark;
      }),
      side: WidgetStateProperty.all(
        const BorderSide(color: AppColors.borderDark),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildMobileFilterChip({
    String? label,
    IconData? icon,
    required bool selected,
    required VoidCallback onTap,
    Color? highlightColor,
    String? tooltip,
  }) {
    assert(label != null || icon != null, 'Filter chip needs a label or icon');
    final accent = highlightColor ?? AppColors.accent;
    final bool iconOnly = icon != null && label == null;

    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    if (selected) {
      backgroundColor = accent;
      foregroundColor =
          accent == AppColors.error ? Colors.white : AppColors.onAccent;
      borderColor = accent;
    } else if (highlightColor != null) {
      backgroundColor = accent.withValues(alpha: 0.16);
      foregroundColor = accent;
      borderColor = accent.withValues(alpha: 0.55);
    } else {
      backgroundColor = AppColors.surfaceElevatedDark;
      foregroundColor = AppColors.onPrimary;
      borderColor = AppColors.borderDark;
    }

    final chip = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: iconOnly ? 8 : 6,
              vertical: 9,
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 16, color: foregroundColor)
                  : Text(
                      label!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: foregroundColor,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 12,
                          ),
                    ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: chip);
    }
    return chip;
  }

  Widget _buildMobileActionButtons(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              await showCreateBookingDialog(
                context,
                initialDate: _calendarView ? _calendarSelectedDay : DateTime.now(),
                initialTime: '08:00',
                onCreated: _loadAppointments,
              );
            },
            icon: const Icon(LucideIcons.plus, size: 18),
            label: Text(l10n.createBooking),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: _loading ? null : _loadAppointments,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onAccent,
                    ),
                  )
                : const Icon(LucideIcons.refreshCw, size: 18),
            label: Text(l10n.refresh),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
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
            KhmerAwareText('${l10n.appointmentName}: ${a.name}', style: _dashboardTextStyle(ctx)),
            Text('${l10n.appointmentPhone}: ${a.phone}', style: _dashboardTextStyle(ctx)),
            KhmerAwareText('${l10n.stepChooseService}: ${_displayServiceName(a.serviceName)}', style: _dashboardTextStyle(ctx)),
            Text('${l10n.sessionType}: $sessionLabel', style: _dashboardTextStyle(ctx)),
            Text('${a.date} · ${a.time}', style: _dashboardTextStyle(ctx, color: AppColors.onSurfaceVariantDark)),
            if (a.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l10n.note, style: _dashboardTextStyle(ctx, color: AppColors.onSurfaceVariantDark, fontSize: 12)),
              KhmerAwareText(a.notes, style: _dashboardTextStyle(ctx)),
            ],
            if (a.smsStatus != null) ...[
              const SizedBox(height: 8),
              Text(
                '${l10n.smsStatusLabel}: ${a.smsStatus}${a.smsErrorReason != null ? " (${a.smsErrorReason})" : ""}',
                style: TextStyle(
                  color: a.smsStatus == 'sent' ? const Color(0xFF1B5E20) : AppColors.onSurfaceVariantDark,
                  fontSize: 12,
                ),
              ),
              if (a.smsErrorBody != null && a.smsErrorBody!.isNotEmpty)
                Text(a.smsErrorBody!, style: TextStyle(color: AppColors.error.withValues(alpha: 0.9), fontSize: 11)),
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
    final predefinedSlots = generateHourlySlotLabels();
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
                            initialValue: selectedTime,
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
                              final initial = (int.tryParse(parts.isNotEmpty ? parts[0] : '8') ?? 8) * 60 + (int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0);
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
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    if (isMobile) {
      final filters = <({String? value, String? label, IconData? icon, Color? color, String? tooltip})>[
        (value: null, label: l10n.filterAll, icon: null, color: null, tooltip: null),
        (value: 'pending', label: l10n.statusPending, icon: null, color: null, tooltip: null),
        (value: 'confirmed', label: l10n.statusConfirmed, icon: null, color: null, tooltip: null),
        (
          value: 'completed',
          label: null,
          icon: LucideIcons.check,
          color: AppColors.accent,
          tooltip: l10n.statusCompleted,
        ),
        (
          value: 'cancelled',
          label: null,
          icon: LucideIcons.x,
          color: AppColors.error,
          tooltip: l10n.statusCancelled,
        ),
      ];

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(l10n.calendarView),
                    icon: const Icon(LucideIcons.calendar, size: 18),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(l10n.listView),
                    icon: const Icon(LucideIcons.list, size: 18),
                  ),
                ],
                selected: {_calendarView},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _calendarView = s.first),
                style: _dashboardSegmentedStyle(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.statusColumn,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (var i = 0; i < filters.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: _buildMobileFilterChip(
                      label: filters[i].label,
                      icon: filters[i].icon,
                      highlightColor: filters[i].color,
                      tooltip: filters[i].tooltip,
                      selected: _statusFilter == filters[i].value,
                      onTap: () {
                        setState(() {
                          _statusFilter = filters[i].value;
                          _listPageIndex = 0;
                        });
                        _loadAppointments();
                      },
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _buildMobileActionButtons(l10n),
          ],
        ),
      );
    }

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
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _calendarView = s.first),
            style: _dashboardSegmentedStyle(),
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
            showSelectedIcon: false,
            onSelectionChanged: (s) {
              setState(() {
                _statusFilter = s.isEmpty ? null : s.first;
                _listPageIndex = 0;
                _loadAppointments();
              });
            },
            style: _dashboardSegmentedStyle(),
          ),
          const SizedBox(width: 24),
          TextButton.icon(
            onPressed: () async {
              await showCreateBookingDialog(
                context,
                initialDate: _calendarView ? _calendarSelectedDay : DateTime.now(),
                initialTime: '08:00',
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final useCardLayout = constraints.maxWidth < _kAppointmentTableMinWidth;
        final filtered = _filteredAppointments;
        final visibleRows = _listVisibleRowCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: useCardLayout
                  ? _cardListHeightFor(visibleRows)
                  : _tableListHeightFor(visibleRows),
              child: Stack(
                children: [
                  if (useCardLayout)
                    _buildAppointmentCards(context, l10n)
                  else
                    _buildScrollableDataTable(context, l10n, constraints.maxWidth),
                  if (filtered.isEmpty)
                    Center(
                      child: Text(
                        l10n.noAppointmentsMatchSearch,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            _buildListToolbar(context, l10n, isNarrow),
          ],
        );
      },
    );
  }

  Widget _buildListToolbar(BuildContext context, AppLocalizations l10n, bool isNarrow) {
    if (_appointments.isEmpty) return const SizedBox.shrink();

    if (isNarrow) {
      return _buildMobileListToolbar(context, l10n);
    }

    final search = _buildListSearchField(context, l10n, isNarrow);
    final pagination = _buildPaginationControls(context, l10n);
    final export = _buildExportListButton(context, l10n);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: search,
            ),
          ),
          Expanded(
            child: Center(child: pagination),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: export,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileListToolbar(BuildContext context, AppLocalizations l10n) {
    final hasResults = _filteredAppointments.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.searchAppointments,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
            ),
            const SizedBox(height: 10),
            _buildListSearchField(context, l10n, true, embedded: true),
            if (hasResults) ...[
              const SizedBox(height: 16),
              const Divider(color: AppColors.borderDark, height: 1),
              const SizedBox(height: 16),
              _buildMobilePaginationControls(context, l10n),
            ],
            const SizedBox(height: 16),
            _buildExportListButton(context, l10n, fullWidth: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePaginationControls(BuildContext context, AppLocalizations l10n) {
    final total = _filteredAppointments.length;
    final start = _listPageIndex * _appointmentsPerPage + 1;
    final end = math.min((_listPageIndex + 1) * _appointmentsPerPage, total);
    final canGoBack = _listPageIndex > 0;
    final canGoForward = _listPageIndex < _listPageCount - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.appointmentsListRange(start, end, total),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.appointmentsListPage(_listPageIndex + 1, _listPageCount),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canGoBack ? () => setState(() => _listPageIndex--) : null,
                icon: const Icon(LucideIcons.chevronLeft, size: 18),
                label: Text(l10n.back),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  disabledForegroundColor: AppColors.onSurfaceVariantDark,
                  side: BorderSide(
                    color: canGoBack ? AppColors.accent : AppColors.borderDark,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canGoForward ? () => setState(() => _listPageIndex++) : null,
                icon: const Icon(LucideIcons.chevronRight, size: 18),
                label: Text(l10n.next),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  disabledForegroundColor: AppColors.onSurfaceVariantDark,
                  side: BorderSide(
                    color: canGoForward ? AppColors.accent : AppColors.borderDark,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListSearchField(
    BuildContext context,
    AppLocalizations l10n,
    bool isNarrow, {
    bool embedded = false,
  }) {
    return SizedBox(
      width: isNarrow ? double.infinity : 280,
      child: TextField(
        controller: _listSearchController,
        style: _dashboardTextStyle(context),
        decoration: InputDecoration(
          hintText: l10n.searchAppointments,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
          prefixIcon: const Icon(LucideIcons.search, size: 18, color: AppColors.onSurfaceVariantDark),
          suffixIcon: _listSearchController.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(LucideIcons.x, size: 16, color: AppColors.onSurfaceVariantDark),
                  onPressed: () {
                    _listSearchController.clear();
                  },
                ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          filled: true,
          fillColor: embedded
              ? AppColors.backgroundDark.withValues(alpha: 0.55)
              : AppColors.surfaceElevatedDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(embedded ? 12 : 8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(embedded ? 12 : 8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(embedded ? 12 : 8),
            borderSide: const BorderSide(color: AppColors.accent),
          ),
        ),
      ),
    );
  }

  Widget _buildExportListButton(
    BuildContext context,
    AppLocalizations l10n, {
    bool fullWidth = false,
  }) {
    final disabled = _filteredAppointments.isEmpty || _exportingPdf;
    final button = OutlinedButton.icon(
      onPressed: disabled ? null : () => _exportAppointmentsPdf(l10n),
      icon: _exportingPdf
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
            )
          : const Icon(LucideIcons.fileDown, size: 16),
      label: Text(l10n.exportAppointmentsList),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        disabledForegroundColor: AppColors.onSurfaceVariantDark,
        side: const BorderSide(color: AppColors.borderLight),
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: fullWidth ? 14 : 10,
        ),
      ),
    );

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildPaginationControls(BuildContext context, AppLocalizations l10n) {
    if (_filteredAppointments.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = _filteredAppointments.length;
    final start = _listPageIndex * _appointmentsPerPage + 1;
    final end = math.min((_listPageIndex + 1) * _appointmentsPerPage, total);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _listPageIndex > 0 ? () => setState(() => _listPageIndex--) : null,
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.accent),
          tooltip: l10n.back,
        ),
        Text(
          l10n.appointmentsListRange(start, end, total),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
        ),
        const SizedBox(width: 4),
        Text(
          l10n.appointmentsListPage(_listPageIndex + 1, _listPageCount),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
        ),
        IconButton(
          onPressed: _listPageIndex < _listPageCount - 1
              ? () => setState(() => _listPageIndex++)
              : null,
          icon: const Icon(LucideIcons.chevronRight, color: AppColors.accent),
          tooltip: l10n.next,
        ),
      ],
    );
  }

  Widget _buildAppointmentCards(BuildContext context, AppLocalizations l10n) {
    final items = _paginatedAppointments;
    final visibleRows = _listVisibleRowCount;

    return Column(
      children: [
        for (var i = 0; i < visibleRows; i++) ...[
          if (i > 0) const SizedBox(height: _kAppointmentCardGap),
          Expanded(
            child: i < items.length
                ? _DashboardAppointmentCard(
                    record: items[i],
                    l10n: l10n,
                    isUpdating: _updatingId == items[i].id,
                    compact: true,
                    onConfirm: () => _requestStatusUpdate(items[i].id, 'confirmed'),
                    onComplete: () => _requestStatusUpdate(items[i].id, 'completed'),
                    onCancel: () => _requestStatusUpdate(items[i].id, 'cancelled'),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }

  Widget _buildScrollableDataTable(
    BuildContext context,
    AppLocalizations l10n,
    double viewportWidth,
  ) {
    final headerStyle = Theme.of(context).textTheme.titleSmall!.copyWith(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.w600,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      clipBehavior: Clip.none,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: math.max(viewportWidth, _kAppointmentTableMinWidth),
            ),
            child: DataTable(
              columnSpacing: 20,
              horizontalMargin: 16,
              headingRowHeight: _kDataTableHeadingHeight,
              dataRowMinHeight: _kDataTableRowHeight,
              dataRowMaxHeight: _kDataTableRowHeight,
              headingRowColor: WidgetStateProperty.all(AppColors.primary),
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: 88,
                    child: Text(l10n.bookingReference, style: headerStyle),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 120,
                    child: Text(l10n.appointmentName, style: headerStyle),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 120,
                    child: Text(l10n.appointmentPhone, style: headerStyle),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 180,
                    child: Text(l10n.stepChooseService, style: headerStyle),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 140,
                    child: Text(l10n.stepDateAndTime, style: headerStyle),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 100,
                    child: Text(l10n.statusColumn, style: headerStyle),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 120,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(l10n.actionsColumn, style: headerStyle),
                    ),
                  ),
                ),
              ],
              rows: _buildPaddedDataRows(context, l10n),
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildPaddedDataRows(BuildContext context, AppLocalizations l10n) {
    final rows = _paginatedAppointments
        .map((a) => _buildDataRow(context, l10n, a))
        .toList();
    while (rows.length < _listVisibleRowCount) {
      rows.add(_buildEmptyDataRow());
    }
    return rows;
  }

  DataRow _buildEmptyDataRow() {
    return DataRow(
      cells: List.generate(
        7,
        (_) => DataCell(SizedBox(height: _kDataTableRowHeight)),
      ),
    );
  }

  DataRow _buildDataRow(
    BuildContext context,
    AppLocalizations l10n,
    AdminAppointmentRecord a,
  ) {
    final statusLabel = _statusLabel(l10n, a.status);
    final isUpdating = _updatingId == a.id;

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 88,
            child: Text(
              a.bookingReference,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.accent),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: KhmerAwareText(
              a.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _dashboardTextStyle(context),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Text(
              a.phone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _dashboardTextStyle(context),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 180,
            child: KhmerAwareText(
              _displayServiceName(a.serviceName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _dashboardTextStyle(context),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 140,
            child: Text(
              '${a.date} ${a.time}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _dashboardTextStyle(context),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
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
                    color: a.status == 'cancelled'
                        ? AppColors.error
                        : a.status == 'completed'
                            ? const Color(0xFF1B5E20)
                            : AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: _AppointmentActionIcons(
              status: a.status,
              l10n: l10n,
              isUpdating: isUpdating,
              onConfirm: () => _requestStatusUpdate(a.id, 'confirmed'),
              onComplete: () => _requestStatusUpdate(a.id, 'completed'),
              onCancel: () => _requestStatusUpdate(a.id, 'cancelled'),
            ),
          ),
        ),
      ],
    );
  }
}

class _AppointmentActionIcons extends StatelessWidget {
  const _AppointmentActionIcons({
    required this.status,
    required this.l10n,
    required this.isUpdating,
    required this.onConfirm,
    required this.onComplete,
    required this.onCancel,
  });

  final String status;
  final AppLocalizations l10n;
  final bool isUpdating;
  final VoidCallback onConfirm;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  static const Color _completedColor = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    if (status == 'cancelled' || status == 'completed') {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actionButtons(
        status: status,
        l10n: l10n,
        isUpdating: isUpdating,
        compact: false,
        onConfirm: onConfirm,
        onComplete: onComplete,
        onCancel: onCancel,
      ),
    );
  }

  static List<Widget> actionButtons({
    required String status,
    required AppLocalizations l10n,
    required bool isUpdating,
    required bool compact,
    required VoidCallback onConfirm,
    required VoidCallback onComplete,
    required VoidCallback onCancel,
  }) {
    if (status == 'cancelled' || status == 'completed') {
      return const [];
    }

    final actionSize = compact ? 24.0 : 40.0;
    final iconSize = compact ? 15.0 : 20.0;
    final iconStyle = IconButton.styleFrom(
      minimumSize: Size(actionSize, actionSize),
      maximumSize: Size(actionSize, actionSize),
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );

    return <Widget>[
      if (status == 'pending')
        isUpdating
            ? SizedBox(
                width: actionSize,
                height: actionSize,
                child: Center(
                  child: SizedBox(
                    width: compact ? 14 : 18,
                    height: compact ? 14 : 18,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              )
            : IconButton(
                onPressed: onConfirm,
                icon: Icon(LucideIcons.checkCircle, size: iconSize),
                color: AppColors.accent,
                tooltip: l10n.confirmAppointment,
                style: iconStyle,
              ),
      IconButton(
        onPressed: isUpdating ? null : onComplete,
        icon: Icon(LucideIcons.checkCircle2, size: iconSize),
        color: _completedColor,
        tooltip: l10n.markAsCompleted,
        style: iconStyle,
      ),
      IconButton(
        onPressed: isUpdating ? null : onCancel,
        icon: Icon(LucideIcons.xCircle, size: iconSize),
        color: AppColors.error,
        tooltip: l10n.cancelBookingButton,
        style: iconStyle,
      ),
    ];
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.compact = false,
    this.emphasized = false,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final bool compact;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
        : EdgeInsets.all(emphasized ? 16 : 20);
    final iconSize = compact ? 22.0 : (emphasized ? 28.0 : 32.0);
    final countStyle = compact
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.headlineSmall;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: emphasized
            ? AppColors.surfaceElevatedDark.withValues(alpha: 0.9)
            : AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: emphasized ? AppColors.accent.withValues(alpha: 0.35) : AppColors.borderDark,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(width: compact ? 10 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        fontSize: compact ? 11 : null,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: countStyle?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
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
    this.compact = false,
  });

  final AdminAppointmentRecord record;
  final AppLocalizations l10n;
  final bool isUpdating;
  final VoidCallback onConfirm;
  final VoidCallback onComplete;
  final VoidCallback onCancel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final statusLabel = record.status == 'confirmed'
        ? l10n.statusConfirmed
        : record.status == 'cancelled'
            ? l10n.statusCancelled
            : record.status == 'completed'
                ? l10n.statusCompleted
                : l10n.statusPending;

    final statusChip = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
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
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          color: record.status == 'cancelled'
              ? AppColors.error
              : record.status == 'completed'
                  ? const Color(0xFF1B5E20)
                  : AppColors.accent,
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    if (compact) {
      return Card(
        margin: EdgeInsets.zero,
        color: AppColors.surfaceElevatedDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      record.bookingReference,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                    ),
                    const SizedBox(height: 4),
                    KhmerAwareText(
                      record.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _dashboardTextStyle(
                        context,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      record.phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _dashboardTextStyle(
                        context,
                        color: AppColors.onSurfaceVariantDark,
                        fontSize: 11,
                      ),
                    ),
                    KhmerAwareText(
                      _displayServiceName(record.serviceName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _dashboardTextStyle(context, fontSize: 11),
                    ),
                    Text(
                      '${record.date} · ${record.time}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariantDark,
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  statusChip,
                  if (record.status != 'cancelled' && record.status != 'completed')
                    Expanded(
                      child: Column(
                        children: [
                          for (final button in _AppointmentActionIcons.actionButtons(
                            status: record.status,
                            l10n: l10n,
                            isUpdating: isUpdating,
                            compact: true,
                            onConfirm: onConfirm,
                            onComplete: onComplete,
                            onCancel: onCancel,
                          ))
                            Expanded(
                              child: Center(child: button),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }

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
                statusChip,
              ],
            ),
            const SizedBox(height: 8),
            KhmerAwareText(record.name, style: _dashboardTextStyle(context)),
            Text(record.phone, style: _dashboardTextStyle(context, color: AppColors.onSurfaceVariantDark, fontSize: 14)),
            KhmerAwareText(_displayServiceName(record.serviceName), style: _dashboardTextStyle(context, fontWeight: FontWeight.w500)),
            Text('${record.date} · ${record.time}', style: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 14)),
            if (record.status != 'cancelled' && record.status != 'completed') ...[
              const SizedBox(height: 12),
              _AppointmentActionIcons(
                status: record.status,
                l10n: l10n,
                isUpdating: isUpdating,
                onConfirm: onConfirm,
                onComplete: onComplete,
                onCancel: onCancel,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
