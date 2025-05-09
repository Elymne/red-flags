import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';

class ShaklePopText extends ConsumerStatefulWidget {
  /// About text.
  final TextStyle? style;
  final String text;
  final Color animColor;

  /// Text animation.
  final Duration speedAnimation;
  final double force;

  /// Idle animation.
  final bool hasIdleAnim;
  final double idleForce;

  const ShaklePopText(
    this.text, {
    super.key,
    required this.style,
    required this.animColor,

    this.speedAnimation = const Duration(milliseconds: 100),
    this.force = 1,

    this.hasIdleAnim = false,
    this.idleForce = 0.4,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<ShaklePopText> with TickerProviderStateMixin {
  // The visual text.
  late String _displayText = "";

  /// Delay time between each letter poping.
  late Timer _timer;

  /// Power of movement animation. Lower value will make animation shake less for example.
  late double _forceAnimation = widget.force;

  /// Shake Animation for while text is pop in.
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 200);
  final Duration _idleDurationTic1 = Duration(milliseconds: 2000);

  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 100);
  final Duration _idleDurationTic2 = Duration(milliseconds: 1000);

  /// Simple background display state.
  bool showBackground = true;

  @override
  void initState() {
    super.initState();

    /// * Set the text shaky animation for background text.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -3, end: 3).animate(_shakyController1);

    /// * Start the shaky animation right away.
    _shakyController1.repeat(reverse: true);

    /// * Set the text shaky animation for frontend text.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -1, end: 1).animate(_shakyController2);

    /// * Start the shaky animation right away.
    _shakyController2.repeat(reverse: true);

    /// * Run the starting animation.
    runAnimation();
  }

  /// Run the forward animation.
  /// When animation is completed (by that, I mean that the text is fully complete)
  /// we can decide if we smooth the animation or not depending of hasIdleAnim value.
  void runAnimation() {
    _timer = Timer.periodic(widget.speedAnimation, (timer) {
      /// * When text is complete, we now have a choice.
      if (_displayText.length == widget.text.length) {
        /// * Cancel the callback timer.
        _timer.cancel();

        /// * If idle animation is set to true, we smooth current anim and start it.
        if (widget.hasIdleAnim) {
          _forceAnimation = widget.idleForce;
          _shakyController1.duration = _idleDurationTic1;
          _shakyController2.duration = _idleDurationTic2;

          /// * Run the anim again to take account of changes.
          _shakyController1.repeat(reverse: true);
          _shakyController2.repeat(reverse: true);
          return;
        }

        /// * Else, it's full stop mode. Hide the colored background. Reverse animation to correct position.
        _shakyController1.reverse();
        _shakyController2.reverse();
        showBackground = false;
        return;
      }

      /// * Add a letter and update the widget visual state.
      setState(() {
        _displayText += widget.text[_displayText.length];
      });
    });
  }

  /// Reverse the animation
  /// Used on screen changes.
  void reverseAnimation() {
    /// * Update shaky animation with the force one.
    _forceAnimation = widget.idleForce;
    _shakyController1.duration = _idleDurationTic1;
    _shakyController2.duration = _idleDurationTic2;

    /// * Run the anim again to take account of changes.
    _shakyController1.repeat(reverse: true);
    _shakyController2.repeat(reverse: true);

    _timer = Timer.periodic(widget.speedAnimation, (timer) {
      /// * When text is fully depleted, stop timer + manage animation.
      if (_displayText.isEmpty) {
        /// * Cancel the callback timer.
        _timer.cancel();
        return;
      }

      /// * Remove each letter.
      setState(() {
        _displayText = _displayText.substring(0, _displayText.length - 1);
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
    /// * This is called on page change using routerNotifierprovider.
    ref.listen(routerNotifierprovider, (previous, next) {
      if (next.status == RouterStatus.changing) {
        reverseAnimation();
        return;
      }
    });

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
