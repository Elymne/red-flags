import 'package:flutter/material.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';

class SlideListView extends StatefulWidget {
  final int itemCount;
  final EdgeInsetsGeometry itemPadding;
  final Widget Function(BuildContext context, int index) itemBuilder;

  const SlideListView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 2.0),
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SlideListView> with SingleTickerProviderStateMixin {
  bool runItemAnimation = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runItemAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: widget.itemPadding,
          child: AnimatedChild(index: index, runAnimation: runItemAnimation, child: widget.itemBuilder(context, index)),
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
  late final Duration _slideDuration;

  @override
  void initState() {
    super.initState();
    final mutiplierDuration = widget.index > 10 ? 10 : widget.index;
    _slideDuration = Duration(milliseconds: 600 + (100) * mutiplierDuration);
  }

  @override
  Widget build(BuildContext context) {
    return SlideWidget(duration: _slideDuration, child: widget.child);
  }
}
