import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure_type.dart';

class Success<F extends FailureType, S> extends Either<F, S> {
  final S value;

  Success(this.value);

  @override
  T fold<T>(T Function(F failure) failureFunc, T Function(S success) successFunc) {
    return successFunc(value);
  }

  @override
  bool isFailure() => true;

  @override
  bool isSuccess() => false;
}
