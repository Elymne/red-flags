import 'package:red_flags/core/usecase/params.dart';

abstract class Usecase<R, P extends Params?> {
  Future<R> perform(P params);
}
