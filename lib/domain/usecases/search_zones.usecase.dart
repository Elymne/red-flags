import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/domain/repositories/zone_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

class SearchZones extends Usecase<Either<DatasourceFailure, List<Zone>>, SearchZonesParams> {
  final ZoneRepository zoneRepository;

  SearchZones({required this.zoneRepository});

  @override
  Future<Either<DatasourceFailure, List<Zone>>> perform(SearchZonesParams params) async {
    return await zoneRepository.find(params.name);
  }
}

class SearchZonesParams extends Params {
  String name;
  SearchZonesParams({required this.name});
}
