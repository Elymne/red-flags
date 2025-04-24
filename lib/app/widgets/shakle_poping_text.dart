import 'dart:async';
import 'package:flutter/material.dart';

class ShaklePopingText extends StatefulWidget {
  final Duration speedAnimation;
  final String text;
  final TextStyle? style;

  const ShaklePopingText(this.text, {super.key, required this.style, required this.speedAnimation});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShaklePopingText> with TickerProviderStateMixin {
  // The visual text.
  late String _displayText = "";

  /// Delay time between each letter poping.
  late final Timer _timer;

  /// Multiplier movement.
  double _multiplier = 1.0;

  /// Shake Animation for while text is pop in.
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 100);
  final Duration _idleDurationTic1 = Duration(milliseconds: 400);

  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 200);
  final Duration _idleDurationTic2 = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();

    // Set the text shaky animation for background text.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -1, end: 1).animate(_shakyController1);
    _shakyAnimation1.addStatusListener((status) {
      // Theses two conditions allow us to forward/reverse infinitly.
      if (status == AnimationStatus.completed) _shakyController1.reverse();
      if (status == AnimationStatus.dismissed) _shakyController1.forward();
      // When text is fully complete, we just stop listening to changes from animation to make it stop animate.
      if (_displayText.length == widget.text.length) {
        _shakyAnimation1.removeStatusListener((status) {});
      }
    });
    // Start the shaky animation right away.
    _shakyController1.forward();

    // Set the text shaky animation for frontend text.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -1.4, end: 1.4).animate(_shakyController2);
    _shakyAnimation2.addStatusListener((status) {
      // Theses two conditions allow us to forward/reverse infinitly.
      if (status == AnimationStatus.completed) _shakyController2.reverse();
      if (status == AnimationStatus.dismissed) _shakyController2.forward();
    });
    // Start the shaky animation right away.
    _shakyController2.forward();

    // Start the periodic timer to do the animation.
    _timer = Timer.periodic(widget.speedAnimation, (timer) {
      // Stop animation if text has reach his full lenght.
      if (_displayText.length == widget.text.length) {
        _timer.cancel();
        _multiplier = 0.3;
        _shakyController1.duration = _idleDurationTic1;
        _shakyController2.duration = _idleDurationTic2;
        return;
      }
      // Add a letter and update the widget visual state.
      setState(() {
        _displayText += widget.text[_displayText.length];
      });
    });
  }

  @override
  void dispose() {
    _shakyController1.dispose();
    _shakyController2.dispose();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _shakyAnimation1,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation1.value * _multiplier, 0),
              child: Text(_displayText, style: widget.style?.copyWith(color: Theme.of(context).colorScheme.primary)),
            );
          },
        ),
        AnimatedBuilder(
          animation: _shakyAnimation2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation2.value * _multiplier, 0),
              child: Text(_displayText, style: widget.style),
            );
          },
        ),
      ],
    );
  }
}
