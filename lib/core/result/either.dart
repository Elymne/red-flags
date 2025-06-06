import 'package:red_flags/core/result/failure_type.dart';

abstract class Either<F extends FailureType, S> {
  T fold<T>(T Function(F failure) failureFunc, T Function(S success) successFunc);

  bool isFailure();
  bool isSuccess();
}
