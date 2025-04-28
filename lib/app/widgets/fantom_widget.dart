import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FantomWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Duration duration;

  const FantomWidget({super.key, required this.child, required this.duration});

  @override
  ConsumerState<FantomWidget> createState() => _State();
}

class _State extends ConsumerState<FantomWidget> with TickerProviderStateMixin {
  /// Animation controller for fadeout and slide-in effect.
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller.
    _animationController = AnimationController(vsync: this, duration: widget.duration);
    // Define the slide animation.
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-100, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    // Define the fade animation.
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Start the animation on init.
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(opacity: _fadeAnimation.value, child: Transform.translate(offset: _slideAnimation.value, child: widget.child));
      },
    );
  }
}
