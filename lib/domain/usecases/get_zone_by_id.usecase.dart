import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/domain/repositories/zone_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

class GetZoneByID extends Usecase<Either<DatasourceFailure, Zone>, GetZoneByIDParams> {
  final ZoneRepository zoneRepository;

  GetZoneByID({required this.zoneRepository});

  @override
  Future<Either<DatasourceFailure, Zone>> perform(GetZoneByIDParams params) async {
    return await zoneRepository.findOneByID(params.id);
  }
}

class GetZoneByIDParams extends Params {
  final String id;
  GetZoneByIDParams({required this.id});
}
