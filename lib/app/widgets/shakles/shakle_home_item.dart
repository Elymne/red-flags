import 'dart:math';
import 'package:flutter/material.dart';

class ShakleHomeItem extends StatefulWidget {
  final String title;
  final IconData iconData;
  final void Function() onTap;
  final bool isActive;

  const ShakleHomeItem({super.key, required this.title, required this.iconData, required this.onTap, this.isActive = true});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleHomeItem> with TickerProviderStateMixin {
  /// * Duration randomizer.
  final int randomizer = Random().nextInt(1);

  /// * Shake Animation (for background color).
  late final AnimationController _backgroundAnimCtrl;
  late final Animation<double> _backgroundAnim;
  late final Duration _backgroundAnimTic = Duration(milliseconds: 1_600 + (1_000 * randomizer).round());

  /// * Shake Animation (for front input).
  late final AnimationController _foregroundAnimCtrl;
  late final Animation<double> _foregroundAnim;
  late final Duration _foregroundAnimTic = Duration(milliseconds: 1_000 + (1_000 * randomizer).round());

  @override
  void initState() {
    super.initState();
    _backgroundAnimCtrl = AnimationController(vsync: this, duration: _backgroundAnimTic);
    _backgroundAnim = Tween<double>(begin: -1.0, end: 1.0).animate(_backgroundAnimCtrl);
    _foregroundAnimCtrl = AnimationController(vsync: this, duration: _foregroundAnimTic);
    _foregroundAnim = Tween<double>(begin: -0.5, end: 0.5).animate(_foregroundAnimCtrl);
    _backgroundAnimCtrl.repeat(reverse: true);
    _foregroundAnimCtrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundAnimCtrl.dispose();
    _foregroundAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _backgroundAnimCtrl,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_backgroundAnim.value, _backgroundAnim.value / 2),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Icon(widget.iconData, color: Theme.of(context).colorScheme.primary, size: 40),
                      SizedBox(width: 20),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _foregroundAnimCtrl,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_foregroundAnim.value, _foregroundAnim.value / 2),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Icon(widget.iconData, color: Theme.of(context).colorScheme.onSurface, size: 40),
                      SizedBox(width: 20),
                      Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
