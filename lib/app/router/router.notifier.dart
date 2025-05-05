import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerNotifierprovider = StateNotifierProvider<RouterNotifier, RouterState>((ref) {
  return RouterNotifier(ref);
});

class RouterNotifier extends StateNotifier<RouterState> {
  final Ref ref;

  RouterNotifier(this.ref) : super(RouterState(status: RouterStatus.done));

  Future<void> changeScreen(void Function() onAnimationEnd) async {
    /// * Run animation and update current screen after animation is done.
    state = RouterState(status: RouterStatus.changing, animationDuration: state.animationDuration);
    Future.delayed(state.animationDuration, () {
      state = RouterState(status: RouterStatus.done, animationDuration: state.animationDuration);
      onAnimationEnd();
    });
  }
}

class RouterState {
  final RouterStatus status;
  final Duration animationDuration;

  RouterState({required this.status, this.animationDuration = const Duration(milliseconds: 1000)});
}

enum RouterStatus { changing, done }
