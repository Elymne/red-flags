import 'package:flutter/material.dart';

class ShakleLoading extends StatefulWidget {
  final Color animColor;

  const ShakleLoading({super.key, required this.animColor});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleLoading> with TickerProviderStateMixin {
  /// Shake Animation (for background color).
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 100);

  /// Shake Animation (for front input).
  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    /// Set background anim.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -1.2, end: 1.2).animate(_shakyController1);
    _shakyController1.repeat(reverse: true);

    /// Set front anim.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -1, end: 1).animate(_shakyController2);
    _shakyController2.repeat(reverse: true);
  }

  @override
  void dispose() {
    /// Unsubscribe all controllers.
    _shakyController1.dispose();
    _shakyController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// background Animation.
        AnimatedBuilder(
          animation: _shakyController1,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation1.value, _shakyAnimation1.value * 0.5),
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  color: widget.animColor,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.animColor),
                ),
              ),
            );
          },
        ),

        /// Front Animation.
        AnimatedBuilder(
          animation: _shakyController2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation2.value, _shakyAnimation2.value * 0.5),
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  color: widget.animColor,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.outline),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
