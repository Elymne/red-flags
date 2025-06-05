import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure_type.enum.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecases/usecase.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/domain/repositories/zone_repository.dart';

class GetZoneByID extends Usecase<Either<FailureType, Zone>, GetZoneByIDParams> {
  final ZoneRepository zoneRepository;

  GetZoneByID({required this.zoneRepository});

  @override
  Future<Either<FailureType, Zone>> perform(GetZoneByIDParams params) async {
    return await zoneRepository.findOneByID(id: params.id);
  }
}

class GetZoneByIDParams extends Params {
  final String id;
  GetZoneByIDParams({required this.id});
}
