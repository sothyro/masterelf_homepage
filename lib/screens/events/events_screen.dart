import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/events_data.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/breadcrumb.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _searchQuery = '';

  List<EventItem> get _filteredEvents {
    if (_searchQuery.trim().isEmpty) return kAllEvents;
    final q = _searchQuery.trim().toLowerCase();
    return kAllEvents.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.date.toLowerCase().contains(q) ||
          e.location.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filtered = _filteredEvents;

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Breadcrumb(items: [
              (label: l10n.home, route: '/'),
              (label: l10n.events, route: null),
            ]),
            const SizedBox(height: 16),
            Text(
              l10n.eventsCalendarTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.eventsSubline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchEvent,
                      border: const OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: const Icon(Icons.search, size: 20),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: () => context.push('/contact'),
                  child: Text(l10n.secureYourSeat),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              l10n.comingUpNext,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                  ),
            ),
            const SizedBox(height: 16),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No events match your search.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariantDark,
                        ),
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 600) {
                    return _EventsTable(events: filtered, onViewEvent: () => context.push('/contact'));
                  }
                  return _EventsCardList(events: filtered, onViewEvent: () => context.push('/contact'));
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _EventsTable extends StatelessWidget {
  const _EventsTable({required this.events, required this.onViewEvent});

  final List<EventItem> events;
  final VoidCallback onViewEvent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1.5),
        3: IntrinsicColumnWidth(),
      },
      border: TableBorder.all(color: AppColors.borderDark),
      children: [
        TableRow(
          decoration: BoxDecoration(color: AppColors.surfaceElevatedDark),
          children: [
            _TableHeader(l10n.eventColumn),
            _TableHeader(l10n.dateColumn),
            _TableHeader(l10n.locationColumn),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                '',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onPrimary,
                    ),
              ),
            ),
          ],
        ),
        ...events.map((e) => TableRow(
              decoration: BoxDecoration(color: AppColors.surfaceDark),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimary,
                            ),
                      ),
                      if (e.description.isNotEmpty)
                        Text(
                          e.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurfaceVariantDark,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    e.date,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    e.location,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: onViewEvent,
                    child: Text(l10n.viewEvent),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onPrimary,
            ),
      ),
    );
  }
}

class _EventsCardList extends StatelessWidget {
  const _EventsCardList({required this.events, required this.onViewEvent});

  final List<EventItem> events;
  final VoidCallback onViewEvent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: events.map((e) => _HoverableEventCard(event: e, onViewEvent: onViewEvent)).toList(),
    );
  }
}

class _HoverableEventCard extends StatefulWidget {
  const _HoverableEventCard({required this.event, required this.onViewEvent});

  final EventItem event;
  final VoidCallback onViewEvent;

  @override
  State<_HoverableEventCard> createState() => _HoverableEventCardState();
}

class _HoverableEventCardState extends State<_HoverableEventCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor = _isHovered ? AppColors.borderLight.withValues(alpha: 0.5) : AppColors.borderDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadow,
          ),
          child: ListTile(
            title: Text(
              e.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${e.date} · ${e.location}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                ),
                if (e.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    e.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariantDark,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            trailing: Icon(Icons.arrow_forward, color: AppColors.accent),
            onTap: widget.onViewEvent,
          ),
        ),
      ),
    );
  }
}
