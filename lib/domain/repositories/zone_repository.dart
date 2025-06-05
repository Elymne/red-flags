import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure_type.enum.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';

abstract class ZoneRepository {
  Future<Either<FailureType, List<Zone>>> find({String name});
  Future<Either<FailureType, Zone>> findOneByID({String id});
}
