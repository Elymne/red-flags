import 'package:flutter/material.dart';

class SlideListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const SlideListView({super.key, required this.itemBuilder, required this.itemCount});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SlideListView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.itemCount,

      itemBuilder: (context, index) {
        return AnimatedChild(index: index, child: widget.itemBuilder(context, index));
      },
    );
  }
}

class AnimatedChild extends StatefulWidget {
  final int index;
  final Widget child;

  const AnimatedChild({super.key, required this.child, required this.index});

  @override
  State<StatefulWidget> createState() => _ChildState();
}

class _ChildState extends State<AnimatedChild> with SingleTickerProviderStateMixin {
  /// * Slide animation.
  late final AnimationController _animController;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  final Duration _slideDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();

    /// * Set the slide animation.
    _animController = AnimationController(vsync: this, duration: _slideDuration);
    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(_animController);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animController);

    /// * Start the animation.
    _animController.forward();

    /// * Delay will depend of the index order of each item inside listview.
    final msTimer = 100 * widget.index;
    Future.delayed(Duration(milliseconds: msTimer), () {});
  }

  @override
  Widget build(BuildContext context) {
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

                /// * The final child.
                child: widget.child,
              );
            },
          ),
        );
      },
    );
  }
}
