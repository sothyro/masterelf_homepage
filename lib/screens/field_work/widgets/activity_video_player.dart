import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _failed = false;
  bool _muted = true;
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
        if (mounted) playMuted();
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
    _hubBinding?.detach();
    final c = _controller;
    if (c != null && _loopListener != null) {
      c.removeListener(_loopListener!);
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  Future<void> playMuted() => _ensurePlaying(muted: true);

  @override
  Future<void> pause() async {
    final c = _controller;
    if (c != null && c.value.isPlaying) {
      await c.pause();
      if (mounted) setState(() {});
    }
  }

  Future<void> _onUserPlayTap() async {
    if (_failed) return;
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
    await _ensurePlaying(muted: true);
  }

  Future<void> _ensurePlaying({required bool muted}) async {
    if (_failed) return;

    if (!_initialized) {
      try {
        final c = VideoPlayerController.asset(
          widget.videoAsset,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        await c.initialize();
        if (!mounted) {
          c.dispose();
          return;
        }
        c.setLooping(true);
        void listener() {
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
        c.addListener(_loopListener!);
        _controller = c;
        _initialized = true;
      } catch (_) {
        if (mounted) setState(() => _failed = true);
        return;
      }
    }

    final c = _controller;
    if (c == null) return;

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

  bool get _isPlaying => _initialized && _controller != null && _controller!.value.isPlaying;

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
                      'Video coming soon',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                          ),
                    ),
                  ],
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
