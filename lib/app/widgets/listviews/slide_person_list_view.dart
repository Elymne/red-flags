import 'package:flutter/material.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';

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
          /// * Animated Child.
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

class _ChildState extends State<AnimatedChild> with TickerProviderStateMixin {
  /// * Slide duration animation.
  late final Duration _slideDuration;

  @override
  void initState() {
    super.initState();

    /// * Set a multiplier delay animation (to create a sort of wave animation).
    final mutiplierDuration = widget.index > 10 ? 10 : widget.index;
    _slideDuration = Duration(milliseconds: 600 + (100) * mutiplierDuration);
  }

  @override
  Widget build(BuildContext context) {
    return SlideWidget(duration: _slideDuration, child: widget.child);
  }
}
