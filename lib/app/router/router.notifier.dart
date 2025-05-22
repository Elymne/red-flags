import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Why am I using a Notifier Provider to manage routing :
/// My app have animation transition when user is pushing or poping screen.
/// I need to listen to call every animation that listen routes transition to start or reverse animation.
final routerNotifierprovider = StateNotifierProvider<RouterNotifier, RouterState>((ref) {
  return RouterNotifier(ref);
});

class RouterNotifier extends StateNotifier<RouterState> {
  final Ref ref;

  RouterNotifier(this.ref) : super(RouterState(status: RoutingAnimationStatus.init));

  void push(NavigatorState navigator, Widget widget) {
    state = RouterState(status: RoutingAnimationStatus.reverse, animationDuration: state.animationDuration);
    Future.delayed(state.animationDuration, () async {
      await navigator.push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      state = RouterState(status: RoutingAnimationStatus.forward, animationDuration: state.animationDuration);
    });
  }

  void pushAndRemoveUntil(NavigatorState navigator, Widget widget) {
    state = RouterState(status: RoutingAnimationStatus.reverse, animationDuration: state.animationDuration);
    Future.delayed(state.animationDuration, () async {
      await navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
      state = RouterState(status: RoutingAnimationStatus.forward, animationDuration: state.animationDuration);
    });
  }

  void pop(NavigatorState navigator) {
    state = RouterState(status: RoutingAnimationStatus.reverse, animationDuration: state.animationDuration);
    Future.delayed(state.animationDuration, () async {
      if (!navigator.canPop()) return;
      navigator.pop();
    });
  }
}

class RouterState {
  final RoutingAnimationStatus status;
  final Duration animationDuration;

  RouterState({required this.status, this.animationDuration = const Duration(milliseconds: 1000)});
}

enum RoutingAnimationStatus { init, reverse, forward }
