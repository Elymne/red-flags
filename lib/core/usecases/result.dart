// abstract class Usecase<R extends Result, P extends Params?> {
//   Future<R> perform(P params);
// }

// abstract class Params {}

abstract class Result<D> {}

class Success<D> extends Result<D> {
  final D data;
  Success({required this.data});
}

class Failure<D> extends Result<D> {
  final int code;
  Failure({required this.code});
}
