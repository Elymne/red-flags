import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';

class ShaklePopText extends ConsumerStatefulWidget {
  /// About text.
  final TextStyle? style;
  final String text;

  /// Text animation.
  final Duration speedAnimation;
  final double force;

  /// Idle animation.
  final bool hasIdleAnim;
  final double idleForce;

  /// Special color.
  final Color? color;

  const ShaklePopText(
    this.text, {
    super.key,
    required this.style,

    this.speedAnimation = const Duration(milliseconds: 100),
    this.force = 1,

    this.hasIdleAnim = false,
    this.idleForce = 0.4,

    this.color,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<ShaklePopText> with TickerProviderStateMixin {
  // The visual text.
  late String _displayText = "";

  /// Delay time between each letter poping.
  Timer? _timer;

  /// Power of movement animation. Lower value will make animation shake less for example.
  late double _forceAnimation = widget.force;

  /// Shake Animation for while text is pop in.
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 200);
  final Duration _idleDurationTic1 = Duration(milliseconds: 1_600);

  /// Shake Animation for while text is pop in.
  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 100);
  final Duration _idleDurationTic2 = Duration(milliseconds: 1_000);

  /// Simple background display state.
  bool showBackground = true;

  @override
  void initState() {
    super.initState();

    /// * Set the text shaky animation for background text.
    _shakyController1 = AnimationController(vsync: this, duration: Duration.zero);
    _shakyAnimation1 = Tween<double>(begin: -3, end: 3).animate(_shakyController1);

    /// * Set the text shaky animation for frontend text.
    _shakyController2 = AnimationController(vsync: this, duration: Duration.zero);
    _shakyAnimation2 = Tween<double>(begin: -1, end: 1).animate(_shakyController2);

    /// * Run the starting animation.
    runAnimation();
  }

  /// Run the forward animation.
  /// When animation is completed (by that, I mean that the text is fully complete)
  /// we can decide if we smooth the animation or not depending of hasIdleAnim value.
  void runAnimation() {
    /// * Start all animation.
    clearTimer();
    setState(() => showBackground = true);
    _shakyController1.duration = _shakyDurationTic1;
    _shakyController2.duration = _shakyDurationTic2;
    _shakyController1.repeat(reverse: true);
    _shakyController2.repeat(reverse: true);

    _timer = Timer.periodic(widget.speedAnimation, (_) {
      if (_displayText.length == widget.text.length) {
        clearTimer();
        if (widget.hasIdleAnim) {
          /// * Update animation (idle mode).
          _forceAnimation = widget.idleForce;
          _shakyController1.duration = _idleDurationTic1;
          _shakyController2.duration = _idleDurationTic2;
          _shakyController1.repeat(reverse: true);
          _shakyController2.repeat(reverse: true);
          return;
        }

        /// * Stop Animation and hide text background.
        _shakyController1.reverse();
        _shakyController2.reverse();
        setState(() => showBackground = false);
        return;
      }

      /// * Add one letter and notify UI for text changes.
      setState(() => _displayText += widget.text[_displayText.length]);
    });
  }

  /// Reverse the animation.
  /// Used on screen changes.
  void reverseAnimation() {
    /// * Reverse animation.
    clearTimer();
    setState(() => showBackground = true);
    _forceAnimation = widget.idleForce;
    _shakyController1.duration = _shakyDurationTic1;
    _shakyController2.duration = _shakyDurationTic2;
    _shakyController1.repeat(reverse: true);
    _shakyController2.repeat(reverse: true);

    _timer = Timer.periodic(widget.speedAnimation, (timer) {
      /// * When text is fully depleted, stop timer + manage animation.
      if (_displayText.isEmpty) {
        clearTimer();
        return;
      }

      /// * Pop last letter. (text animation)
      setState(() => _displayText = _displayText.substring(0, _displayText.length - 1));
    });
  }

  /// Clear and nullify timer.
  void clearTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _shakyController1.dispose();
    _shakyController2.dispose();
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(routerNotifierprovider, (_, next) {
      if (next.status == RoutingAnimationStatus.reverse) {
        reverseAnimation();
        return;
      }
      if (next.status == RoutingAnimationStatus.forward) {
        runAnimation();
        return;
      }
    });

    return Stack(
      children: [
        Visibility(
          visible: showBackground,
          child: AnimatedBuilder(
            animation: _shakyAnimation1,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakyAnimation1.value * _forceAnimation, 0),
                child: Text(_displayText, style: widget.style?.copyWith(color: widget.color)),
              );
            },
          ),
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
