import 'package:flutter/material.dart';

class AnimationBackground extends StatefulWidget {
  const AnimationBackground({super.key});

  @override
  createState() => _AnimationBackgroundState();
}

class _AnimationBackgroundState extends State<AnimationBackground>
    with SingleTickerProviderStateMixin {
  /// The main controller for all my animation in this view. The animation ru
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..forward();

  /// The slide animation value.
  late final Animation<Offset> _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
    ..addListener(() {
      setState(() {}); // Met à jour le widget à chaque tick
    });

  /// The fade Animation value.
  late final Animation<double> _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
    ..addListener(() {
      setState(() {}); // Met à jour le widget à chaque tick
    });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cloud n°1
        Positioned(
          top: 100,
          left: 40,
          child: Icon(Icons.cloud, size: 100, color: Colors.white),
        ),

        // Cloud n°1
        Positioned(
          top: 80,
          right: 40,
          child: Icon(Icons.cloud, size: 100, color: Colors.white),
        ),

        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.pink[200],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
