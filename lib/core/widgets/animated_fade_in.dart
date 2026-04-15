import 'package:flutter/material.dart';

/// Wraps [child] in a fade-in + optional slide-up entrance animation.
///
/// Used throughout the app to give sections and cards a polished feel.
/// Provide [delay] to stagger multiple [AnimatedFadeIn] widgets.
class AnimatedFadeIn extends StatefulWidget {
  const AnimatedFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideOffsetFraction = 0.04,
  });

  final Widget child;

  /// How long to wait before starting the animation.
  final Duration delay;

  /// Duration of the fade + slide animation.
  final Duration duration;

  /// Vertical slide distance expressed as a fraction of the widget height.
  final double slideOffsetFraction;

  @override
  State<AnimatedFadeIn> createState() => _AnimatedFadeInState();
}

class _AnimatedFadeInState extends State<AnimatedFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.duration);

    _opacity =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffsetFraction),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}
