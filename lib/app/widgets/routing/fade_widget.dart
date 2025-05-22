import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';

/// Widget linked to page transition.
/// Will fade in on load and fade out on page change.
class FadeWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeWidget({super.key, required this.child, required this.duration});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<FadeWidget> with TickerProviderStateMixin {
  /// * Animation controller for fadeout and slide-in effect.
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(routerNotifierprovider, (_, next) {
      if (next.status == RoutingAnimationStatus.reverse) {
        _animationController.reverse();
        return;
      }
      if (next.status == RoutingAnimationStatus.forward) {
        _animationController.forward();
        return;
      }
    });

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(opacity: _fadeAnimation.value, child: widget.child);
      },
    );
  }
}
