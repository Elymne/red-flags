import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure_type.dart';

class Failure<F extends FailureType, S> extends Either<F, S> {
  final F value;

  Failure(this.value);

  @override
  T fold<T>(T Function(F failure) failureFunc, T Function(S success) successFunc) {
    return failureFunc(value);
  }

  @override
  bool isFailure() => true;

  @override
  bool isSuccess() => false;
}
