import 'dart:async';
import 'package:flutter/material.dart';

class ShakleText extends StatefulWidget {
  /// About text.
  final TextStyle? style;
  final String text;

  /// About animations.
  final Duration speedAnimation;
  final bool hasIdleAnim;
  final Color animColor;

  const ShakleText(
    this.text, {
    super.key,
    required this.style,
    required this.speedAnimation,
    required this.animColor,
    this.hasIdleAnim = false,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleText> with TickerProviderStateMixin {
  // The visual text.
  late String _displayText = "";

  /// Delay time between each letter poping.
  late final Timer _timer;

  /// Power of movement animation. Lower value will make animation shake less for example.
  double _forceAnimation = 1.0;

  /// Shake Animation for while text is pop in.
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 200);
  final Duration _idleDurationTic1 = Duration(milliseconds: 1600);

  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 100);
  final Duration _idleDurationTic2 = Duration(milliseconds: 1000);

  /// Simple background display state.
  bool showBackground = true;

  @override
  void initState() {
    super.initState();

    // Set the text shaky animation for background text.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -3, end: 3).animate(_shakyController1);
    // Start the shaky animation right away.
    _shakyController1.repeat(reverse: true);

    // Set the text shaky animation for frontend text.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -1, end: 1).animate(_shakyController2);
    // Start the shaky animation right away.
    _shakyController2.repeat(reverse: true);

    /// Each tic, we add a character to the text until it's full.
    _timer = Timer.periodic(widget.speedAnimation, (timer) {
      /// When text is complete, we now have a choice.
      if (_displayText.length == widget.text.length) {
        /// Cancel the callback timer.
        _timer.cancel();

        /// If idle animation is set to true, we smooth current anim and start it.
        if (widget.hasIdleAnim) {
          _forceAnimation = 0.3;
          _shakyController1.duration = _idleDurationTic1;
          _shakyController2.duration = _idleDurationTic2;
          // Run the anim again to take account of changes.
          _shakyController1.repeat(reverse: true);
          _shakyController2.repeat(reverse: true);
          return;
        }

        /// Else, it's full stop mode. Hide the colored background. Reverse animation to correct position.
        _shakyController1.reverse();
        _shakyController2.reverse();
        showBackground = false;
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
        if (showBackground)
          AnimatedBuilder(
            animation: _shakyAnimation1,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakyAnimation1.value * _forceAnimation, 0),
                child: Text(_displayText, style: widget.style?.copyWith(color: widget.animColor)),
              );
            },
          ),
        AnimatedBuilder(
          animation: _shakyAnimation2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation2.value * _forceAnimation, 0),
              child: Text(_displayText, style: widget.style),
            );
          },
        ),
      ],
    );
  }
}
