import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';

/// This is a FadeIn/Fadeout + Slidin/Slideout widget related to app routing.
/// It use [Opacity] and [Transform] class to mimic fade animation.
/// This widget listen [routerNotifierprovider] event and changes.
/// Each time an update occur in [routerNotifierprovider], it notify all widgets that they should forward or reverse animation.
/// Look inside [routerNotifierprovider] for more details.
class SlideWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Duration duration;

  const SlideWidget({super.key, required this.child, required this.duration});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SlideWidget> with TickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: widget.duration);

    _slideAnim = Tween<Offset>(
      begin: Offset(-100, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(routerNotifierprovider, (_, next) {
      if (next.status == RoutingAnimationStatus.reverse) {
        _animCtrl.reverse();
        return;
      }
      if (next.status == RoutingAnimationStatus.forward) {
        _animCtrl.forward();
        return;
      }
    });

    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) {
        return Opacity(opacity: _fadeAnim.value, child: Transform.translate(offset: _slideAnim.value, child: widget.child));
      },
    );
  }
}
