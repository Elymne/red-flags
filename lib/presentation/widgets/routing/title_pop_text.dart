import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/presentation/router/router.notifier.dart';

/// This is a Shakle pop text widget related to app routing.
/// This widget listen [routerNotifierprovider] event and changes.
/// Each time an update occur in [routerNotifierprovider], it notify all widgets that they should forward or reverse animation.
/// Look inside [routerNotifierprovider] for more details.
class TitlePopText extends ConsumerStatefulWidget {
  final TextStyle? style;
  final String text;
  final Duration animTic;
  final double animForce;
  final bool hasIdleAnim;
  final double idleAnimForce;
  final Color? color;

  const TitlePopText(
    this.text, {
    super.key,
    required this.style,
    this.animTic = const Duration(milliseconds: 100),
    this.animForce = 1,
    this.hasIdleAnim = false,
    this.idleAnimForce = 0.4,
    this.color,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<TitlePopText> with TickerProviderStateMixin {
  late String _currentText = "";

  late final AnimationController _backgroundAnimCtrl;
  late final Animation<double> _backgroundAnim;
  final Duration _backgroundShakeTic = Duration(milliseconds: 200);
  final Duration _backgroundIdleTicc = Duration(milliseconds: 1_600);

  late final AnimationController _foregroundAnimCtrl;
  late final Animation<double> _foregroundAnim;
  final Duration _foregroundShakeTic = Duration(milliseconds: 100);
  final Duration _foregroundIdleTic = Duration(milliseconds: 1_000);

  late double _animForce = widget.animForce;
  bool showBackground = true;
  Timer? _timerTicker;

  @override
  void initState() {
    super.initState();
    _backgroundAnimCtrl = AnimationController(vsync: this, duration: Duration.zero);
    _backgroundAnim = Tween<double>(begin: -3, end: 3).animate(_backgroundAnimCtrl);
    _foregroundAnimCtrl = AnimationController(vsync: this, duration: Duration.zero);
    _foregroundAnim = Tween<double>(begin: -1, end: 1).animate(_foregroundAnimCtrl);

    runAnimation();
  }

  /// Run the forward animation.
  /// When animation is completed (by that, I mean that the text is fully complete)
  /// we can decide if we smooth the animation or not depending of hasIdleAnim value.
  void runAnimation() {
    /// * Start all animation.
    clearTimer();
    setState(() => showBackground = true);
    _backgroundAnimCtrl.duration = _backgroundShakeTic;
    _foregroundAnimCtrl.duration = _foregroundShakeTic;
    _backgroundAnimCtrl.repeat(reverse: true);
    _foregroundAnimCtrl.repeat(reverse: true);

    _timerTicker = Timer.periodic(widget.animTic, (_) {
      if (_currentText.length == widget.text.length) {
        clearTimer();
        if (widget.hasIdleAnim) {
          /// * Update animation (idle mode).
          _animForce = widget.idleAnimForce;
          _backgroundAnimCtrl.duration = _backgroundIdleTicc;
          _foregroundAnimCtrl.duration = _foregroundIdleTic;
          _backgroundAnimCtrl.repeat(reverse: true);
          _foregroundAnimCtrl.repeat(reverse: true);
          return;
        }

        /// * Stop Animation and hide text background.
        _backgroundAnimCtrl.reverse();
        _foregroundAnimCtrl.reverse();
        setState(() => showBackground = false);
        return;
      }

      /// * Add one letter and notify UI for text changes.
      setState(() => _currentText += widget.text[_currentText.length]);
    });
  }

  /// Reverse the animation.
  /// Used on screen changes.
  void reverseAnimation() {
    /// * Reverse animation.
    clearTimer();
    setState(() => showBackground = true);
    _animForce = widget.idleAnimForce;
    _backgroundAnimCtrl.duration = _backgroundShakeTic;
    _foregroundAnimCtrl.duration = _foregroundShakeTic;
    _backgroundAnimCtrl.repeat(reverse: true);
    _foregroundAnimCtrl.repeat(reverse: true);

    _timerTicker = Timer.periodic(widget.animTic, (timer) {
      /// * When text is fully depleted, stop timer + manage animation.
      if (_currentText.isEmpty) {
        clearTimer();
        return;
      }

      /// * Pop last letter. (text animation)
      setState(() => _currentText = _currentText.substring(0, _currentText.length - 1));
    });
  }

  /// Clear and nullify timer.
  void clearTimer() {
    if (_timerTicker != null && _timerTicker!.isActive) {
      _timerTicker!.cancel();
      _timerTicker = null;
    }
  }

  @override
  void dispose() {
    _backgroundAnimCtrl.dispose();
    _foregroundAnimCtrl.dispose();
    if (_timerTicker != null && _timerTicker!.isActive) {
      _timerTicker!.cancel();
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
            animation: _backgroundAnim,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_backgroundAnim.value * _animForce, 0),
                child: Text(_currentText, style: widget.style?.copyWith(color: widget.color)),
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: _foregroundAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_foregroundAnim.value * _animForce, 0),
              child: Text(_currentText, style: widget.style),
            );
          },
        ),
      ],
    );
  }
}
