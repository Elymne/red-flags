import 'package:flutter/widgets.dart';

abstract class ReactiveState<T, F> {
  final T data;
  final F? failureType;
  final ReactiveStateStatus status;

  ReactiveState({required this.status, required this.data, this.failureType});

  Widget load(
    Widget Function() onPause,
    Widget Function() onLoading,
    Widget Function(T data) onSuccess,
    Widget Function(F? failureType) onFailure,
  ) {
    if (status == ReactiveStateStatus.loading) return onLoading();
    if (status == ReactiveStateStatus.success) return onSuccess(data);
    if (status == ReactiveStateStatus.failure) return onFailure(failureType);
    return onPause();
  }
}

enum ReactiveStateStatus { inactive, loading, success, failure }
