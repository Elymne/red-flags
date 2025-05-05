import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';

class FantomWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Duration duration;

  final bool hasOpacityAnimation;
  final bool hasSliceAnimation;

  const FantomWidget({
    super.key,
    required this.child,
    this.hasOpacityAnimation = true,
    this.hasSliceAnimation = true,
    required this.duration,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<FantomWidget> with TickerProviderStateMixin {
  /// * Animation controller for fadeout and slide-in effect.
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    /// *  Initialize the animation controller.
    _animationController = AnimationController(vsync: this, duration: widget.duration);
    _animationController.addListener(() {
      setState(() {});
    });

    /// * Define the slide animation.
    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.hasSliceAnimation ? -100 : 0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    /// * Define the fade animation.
    final begin = widget.hasOpacityAnimation ? 0.0 : 1.0;
    _fadeAnimation = Tween<double>(begin: begin, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

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
    /// * Listen to screen changes. When it occur,k I just reverse the fadein animation.
    ref.listen(routerNotifierprovider, (previous, next) {
      if (next.status == RouterStatus.changing) {
        _animationController.reverse();
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
