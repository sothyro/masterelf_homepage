import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/mobile_web_performance.dart';
import '../../../services/activity_video_platform.dart';
import '../../../theme/app_theme.dart';
import 'activity_video_playback_hub.dart';

/// Lazy-loaded 9:16 activity video with poster frame until play.
class ActivityVideoPlayer extends StatefulWidget {
  const ActivityVideoPlayer({
    super.key,
    required this.videoAsset,
    required this.posterImage,
    this.playbackId,
    this.autoPlay = false,
    this.autoplayWhenVisible = false,
    this.borderRadius = 18,
    this.maxWidth,
  });

  final String videoAsset;
  final String posterImage;
  /// When set with [autoplayWhenVisible], participates in scroll-based autoplay.
  final String? playbackId;
  final bool autoPlay;
  final bool autoplayWhenVisible;
  final double borderRadius;
  final double? maxWidth;

  @override
  State<ActivityVideoPlayer> createState() => _ActivityVideoPlayerState();
}

class _ActivityVideoPlayerState extends State<ActivityVideoPlayer>
    implements ActivityVideoPlaybackDelegate {
  static const _maxInitAttempts = 3;

  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _failed = false;
  bool _muted = true;
  int _initGeneration = 0;
  int _initAttempts = 0;
  Future<void>? _initFuture;
  void Function()? _loopListener;
  _VideoPlaybackDelegateBinding? _hubBinding;
  final _playerKey = GlobalKey();
  ActivityVideoPlaybackHub? _playbackHub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.playbackId != null && widget.autoplayWhenVisible) {
      _playbackHub = ActivityVideoPlaybackScope.maybeOf(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) playMuted(retryAfterFailure: true);
      });
    }
    if (widget.playbackId != null && widget.autoplayWhenVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final hub = _playbackHub ?? ActivityVideoPlaybackScope.maybeOf(context);
        if (hub != null) {
          _hubBinding = _VideoPlaybackDelegateBinding(
            hub: hub,
            id: widget.playbackId!,
            delegate: this,
          )..attach();
        }
      });
    }
  }

  @override
  void dispose() {
    _initGeneration++;
    _initFuture = null;
    _hubBinding?.detach();
    if (widget.playbackId != null && widget.autoplayWhenVisible) {
      VisibilityDetectorController.instance.forget(
        Key('activity-video-${widget.playbackId}'),
      );
    }
    _disposeController();
    super.dispose();
  }

  void _disposeController() {
    final c = _controller;
    if (c != null && _loopListener != null) {
      c.removeListener(_loopListener!);
    }
    _loopListener = null;
    _controller?.dispose();
    _controller = null;
    _initialized = false;
  }

  void _resetFailureForRetry() {
    _failed = false;
    _initAttempts = 0;
  }

  @override
  Future<void> playMuted({bool retryAfterFailure = false}) async {
    if (_failed && !retryAfterFailure) return;

    if (_failed) {
      _resetFailureForRetry();
    }

    if (_initialized && _controller != null) {
      await _startPlayback(muted: true);
      return;
    }

    if (_initFuture != null) {
      await _initFuture;
      if (_initialized) {
        await _startPlayback(muted: true);
      }
      return;
    }

    await _ensurePlaying(muted: true);
  }

  @override
  Future<void> pause() async {
    _initGeneration++;
    _initFuture = null;

    final c = _controller;
    if (c != null && c.value.isPlaying) {
      await c.pause();
      if (mounted) setState(() {});
    }
  }

  Future<void> _onUserPlayTap() async {
    if (widget.autoplayWhenVisible) {
      _scrollIntoViewIfNeeded();
    }
    if (widget.playbackId != null) {
      _playbackHub?.requestUserPlay(widget.playbackId!);
      return;
    }
    if (_initialized && _controller != null) {
      if (_controller!.value.isPlaying) {
        await _controller!.pause();
      } else {
        await _controller!.play();
      }
      if (mounted) setState(() {});
      return;
    }
    await playMuted(retryAfterFailure: true);
  }

  Future<void> _ensurePlaying({required bool muted}) async {
    final initialized = await _initializeController();
    if (!initialized || !mounted) return;
    await _startPlayback(muted: muted);
  }

  Future<bool> _initializeController() async {
    if (_initialized && _controller != null) return true;

    final existing = _initFuture;
    if (existing != null) {
      await existing;
      return _initialized;
    }

    final generation = ++_initGeneration;
    final init = _loadController(generation);
    _initFuture = init;
    try {
      await init;
    } finally {
      if (identical(_initFuture, init)) {
        _initFuture = null;
      }
    }
    return _initialized;
  }

  Future<void> _loadController(int generation) async {
    VideoPlayerController? pending;
    try {
      final layoutWidth = MediaQuery.sizeOf(context).width;
      pending = ActivityVideoPlatform.createController(
        videoAsset: widget.videoAsset,
        layoutWidth: layoutWidth,
      );
      await pending.initialize();

      if (!mounted || generation != _initGeneration) {
        await pending.dispose();
        return;
      }

      await pending.setLooping(true);
      _controller = pending;
      pending = null;
      void listener() {
        final c = _controller;
        if (c == null) return;
        final duration = c.value.duration;
        if (!c.value.isPlaying || duration.inMilliseconds <= 0) return;
        final pos = c.value.position.inMilliseconds;
        final end = duration.inMilliseconds - 200;
        if (pos >= end) {
          c.seekTo(Duration.zero);
          c.play();
        }
      }

      _loopListener = listener;
      _controller!.addListener(_loopListener!);
      _initialized = true;
      _initAttempts = 0;
      if (mounted) setState(() {});
    } catch (_) {
      await pending?.dispose();
      if (!mounted || generation != _initGeneration) return;

      _initAttempts++;
      if (_initAttempts >= _maxInitAttempts) {
        setState(() => _failed = true);
      } else if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _startPlayback({required bool muted}) async {
    final c = _controller;
    if (c == null || !_initialized) return;

    _muted = muted;
    await c.setVolume(muted ? 0 : 1);
    if (!c.value.isPlaying) {
      await c.play();
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggleMute() async {
    final c = _controller;
    if (c == null || !_initialized) return;
    final next = !_muted;
    await c.setVolume(next ? 0 : 1);
    if (mounted) setState(() => _muted = next);
  }

  bool get _isPlaying =>
      _initialized && _controller != null && _controller!.value.isPlaying;

  void _scrollIntoViewIfNeeded() {
    final ctx = _playerKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.35,
    );
  }

  Widget _buildPlayerStack() {
    final layoutWidth = widget.maxWidth ??
        (MediaQuery.sizeOf(context).width - 32).clamp(200.0, 400.0);

    return AspectRatio(
      aspectRatio: 9 / 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_initialized && _controller != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              Image.asset(
                widget.posterImage,
                fit: BoxFit.cover,
                cacheWidth: MobileWebPerformance.cardImageCacheWidth(
                  context,
                  layoutWidth,
                ),
                errorBuilder: (_, __, ___) => ColoredBox(
                  color: AppColors.borderDark,
                  child: Icon(
                    LucideIcons.video,
                    color: AppColors.accent.withValues(alpha: 0.5),
                    size: 40,
                  ),
                ),
              ),
            if (!_isPlaying)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
            if (!_initialized && !_failed)
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _onUserPlayTap,
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.75),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        LucideIcons.play,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            if (_failed)
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _onUserPlayTap,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.videoOff,
                            color: AppColors.onSurfaceVariantDark,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.fieldWorkVideoTapToRetry,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariantDark,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (_initialized && _controller != null)
              Positioned(
                right: 10,
                bottom: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ControlChip(
                      icon: _isPlaying ? LucideIcons.pause : LucideIcons.play,
                      onTap: _onUserPlayTap,
                    ),
                    const SizedBox(width: 8),
                    _ControlChip(
                      icon: _muted ? LucideIcons.volumeX : LucideIcons.volume2,
                      onTap: _toggleMute,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget player = _buildPlayerStack();

    if (widget.playbackId != null && widget.autoplayWhenVisible) {
      player = VisibilityDetector(
        key: Key('activity-video-${widget.playbackId}'),
        onVisibilityChanged: (info) {
          if (!mounted) return;
          _playbackHub?.reportVisibility(
            widget.playbackId!,
            info.visibleFraction,
          );
        },
        child: player,
      );
    }

    if (widget.maxWidth != null) {
      return ConstrainedBox(
        key: _playerKey,
        constraints: BoxConstraints(maxWidth: widget.maxWidth!),
        child: player,
      );
    }
    return KeyedSubtree(key: _playerKey, child: player);
  }
}

class _VideoPlaybackDelegateBinding {
  _VideoPlaybackDelegateBinding({
    required this.hub,
    required this.id,
    required this.delegate,
  });

  final ActivityVideoPlaybackHub hub;
  final String id;
  final ActivityVideoPlaybackDelegate delegate;

  void attach() => hub.register(id, delegate);

  void detach() => hub.unregister(id);
}

class _ControlChip extends StatelessWidget {
  const _ControlChip({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
