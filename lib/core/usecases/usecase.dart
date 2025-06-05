import 'package:red_flags/core/usecases/Params.dart';

abstract class Usecase<R, P extends Params?> {
  Future<R> perform(P? params);
}
