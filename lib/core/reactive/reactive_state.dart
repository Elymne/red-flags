import 'package:flutter/widgets.dart';
import 'package:red_flags/core/result/failure.dart';

abstract class ReactiveState<T> {
  final T data;
  final FailureType? failureType;
  final ReactiveStateStatus status;

  ReactiveState({required this.status, required this.data, this.failureType});

  Widget load(
    Widget Function() onPause,
    Widget Function() onLoading,
    Widget Function(T data) onSuccess,
    Widget Function(FailureType failureType) onFailure,
  ) {
    if (status == ReactiveStateStatus.loading) return onLoading();
    if (status == ReactiveStateStatus.success) return onSuccess(data);
    if (status == ReactiveStateStatus.failure) return onFailure(failureType ?? FailureType.unknown);
    return onPause();
  }
}

enum ReactiveStateStatus { inactive, loading, success, failure }
