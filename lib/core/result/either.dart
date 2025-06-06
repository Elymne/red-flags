abstract class Either<F, S> {
  T fold<T>(T Function(F failure) failureFunc, T Function(S success) successFunc);

  bool isFailure();
  bool isSuccess();
}
