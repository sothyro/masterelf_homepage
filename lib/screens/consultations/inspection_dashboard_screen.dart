import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/site_inspection_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/login_dialog.dart';
import '../../widgets/logo_with_shape_shadow.dart';
import '../../widgets/page_content_inset.dart';

/// Inspection Dashboard: lists existing inspections with Master Elf logo and name.
/// User can select an inspection to edit/continue, or start a new one.
class InspectionDashboardScreen extends StatefulWidget {
  const InspectionDashboardScreen({super.key});

  @override
  State<InspectionDashboardScreen> createState() =>
      _InspectionDashboardScreenState();
}

class _InspectionDashboardScreenState extends State<InspectionDashboardScreen> {
  List<InspectionRecord> _inspections = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  Future<void> _loadInspections() async {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn || auth.userEmail == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await listInspections(auth.userEmail!);
      if (!mounted) return;
      setState(() {
        _inspections = list;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    if (!auth.isLoggedIn) {
      return _buildLoginRequired(context, l10n);
    }

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: SingleChildScrollView(
        child: Padding(
          padding: pageContentPadding(context, bottom: 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
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
                              l10n.inspectionDashboardTitle,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.inspectionDashboardSubtitle,
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
                            FilledButton.icon(
                              onPressed: () =>
                                  context.go('/consultations/site-inspection'),
                              icon: const Icon(LucideIcons.plus, size: 18),
                              label: Text(l10n.inspectionNewInspection),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.onAccent,
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
                                l10n.inspectionDashboardTitle,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.inspectionDashboardSubtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
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
                            FilledButton.icon(
                              onPressed: () =>
                                  context.go('/consultations/site-inspection'),
                              icon: const Icon(LucideIcons.plus, size: 18),
                              label: Text(l10n.inspectionNewInspection),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.onAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),
                  if (_error != null) _buildError(context, l10n),
                  if (_loading) _buildLoading(context, l10n),
                  if (!_loading && _error == null) ...[
                    if (_inspections.isEmpty)
                      _buildEmptyState(context, l10n)
                    else
                      _buildInspectionGrid(context, l10n, isNarrow),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () => showLoginDialog(
                    context,
                    successActions: [
                      (label: l10n.inspectionDashboardTitle, route: '/consultations/inspection-dashboard'),
                      (label: l10n.inspectionNewInspection, route: '/consultations/site-inspection'),
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
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: _loadInspections,
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

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderDark, width: 1),
      boxShadow: AppShadows.card,
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.clipboardList,
            size: 64,
            color: AppColors.onSurfaceVariantDark,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.inspectionNoInspections,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.inspectionStartFirst,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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
        ],
      ),
    );
  }

  Widget _buildInspectionGrid(
    BuildContext context,
    AppLocalizations l10n,
    bool isNarrow,
  ) {
    final crossCount = isNarrow ? 1 : 2;
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: isNarrow ? 0.72 : 0.68,
          ),
          itemCount: _inspections.length,
          itemBuilder: (context, index) {
            final inspection = _inspections[index];
            return _InspectionCard(
              inspection: inspection,
              l10n: l10n,
              onTap: () => context.go(
                '/consultations/site-inspection/${inspection.id}',
              ),
            );
          },
        );
      },
    );
  }
}

class _InspectionCard extends StatelessWidget {
  const _InspectionCard({
    required this.inspection,
    required this.l10n,
    required this.onTap,
  });

  final InspectionRecord inspection;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visitOrCreated =
        inspection.visitDateTime ?? inspection.updatedAt ?? inspection.createdAt;
    final updatedStr = visitOrCreated != null
        ? '${visitOrCreated.day}/${visitOrCreated.month}/${visitOrCreated.year} '
            '${visitOrCreated.hour.toString().padLeft(2, '0')}:${visitOrCreated.minute.toString().padLeft(2, '0')}'
        : null;
    final stepStr = l10n.inspectionStepOf(inspection.lastStep + 1, 18);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDark, width: 1),
            boxShadow: [
              ...AppShadows.card,
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: Container(
                  width: double.infinity,
                  color: AppColors.backgroundDark,
                  padding: const EdgeInsets.all(28),
                  alignment: Alignment.center,
                  child: LogoWithShapeShadow(
                    assetPath: AppContent.assetLogo,
                    errorBuilder: (_, __, ___) => Icon(
                      LucideIcons.clipboardList,
                      size: 64,
                      color: AppColors.accent.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      inspection.inspectionName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (updatedStr != null)
                          Text(
                            updatedStr,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariantDark,
                                ),
                          )
                        else
                          const SizedBox.shrink(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            stepStr,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          l10n.inspectionContinue,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          LucideIcons.arrowRight,
                          size: 16,
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
