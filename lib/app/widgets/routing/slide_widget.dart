import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';

/// Widget linked to page transition.
/// Will slide and fadein on load and slide fade out on page change.
class SlideWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Duration duration;

  const SlideWidget({super.key, required this.child, required this.duration});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SlideWidget> with TickerProviderStateMixin {
  /// * Animation controller for fadeout and slide-in effect.
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    /// *  Initialize the animation controller.
    _animationController = AnimationController(vsync: this, duration: widget.duration);

    /// * Define the slide animation.
    _slideAnimation = Tween<Offset>(
      begin: Offset(-100, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    /// * Define the fade animation.
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    /// * On init, I just need to run the animation.
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
        return Opacity(opacity: _fadeAnimation.value, child: Transform.translate(offset: _slideAnimation.value, child: widget.child));
      },
    );
  }
}
