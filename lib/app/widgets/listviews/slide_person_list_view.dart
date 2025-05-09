import 'package:flutter/material.dart';

class SlideListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const SlideListView({super.key, required this.itemBuilder, required this.itemCount});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SlideListView> with SingleTickerProviderStateMixin {
  bool runItemAnimation = true;

  @override
  void initState() {
    super.initState();

    /// * When animation have run once, never run them again.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runItemAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.itemCount,

      itemBuilder: (context, index) {
        return AnimatedChild(
          /// *
          index: index,
          runAnimation: runItemAnimation,
          child: widget.itemBuilder(context, index),
        );
      },
    );
  }
}

class AnimatedChild extends StatefulWidget {
  final int index;
  final bool runAnimation;
  final Widget child;

  const AnimatedChild({super.key, required this.child, required this.index, required this.runAnimation});

  @override
  State<StatefulWidget> createState() => _ChildState();
}

class _ChildState extends State<AnimatedChild> with SingleTickerProviderStateMixin {
  /// * Slide duration animation.
  late final Duration _slideDuration;

  /// * Slide animation.
  late final AnimationController _animController;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    /// * No animation after the 10th item or if parent have already run the animation once.
    if (widget.index > 10 || !widget.runAnimation) {
      return;
    }

    /// * Set the slide anim duration.
    _slideDuration = Duration(milliseconds: 200 * widget.index);

    /// * Set the slide animation.
    _animController = AnimationController(vsync: this, duration: _slideDuration);
    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(_animController);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animController);

    /// * Start the animation.
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    /// * Static Item.
    if (widget.index > 10 || !widget.runAnimation) {
      return widget.child;
    }

    /// * Animated Item.
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, _) {
              return Opacity(
                opacity: _fadeAnimation.value,

                /// * Static Item.
                child: widget.child,
              );
            },
          ),
        );
      },
    );
  }
}
