import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecases/usecase.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/domain/repositories/zone_repository.dart';

class SearchZones extends Usecase<Either<FailureType, List<Zone>>, SearchZonesParams> {
  final ZoneRepository zoneRepository;

  SearchZones({required this.zoneRepository});

  @override
  Future<Either<FailureType, List<Zone>>> perform(SearchZonesParams params) async {
    return await zoneRepository.find(params.name);
  }
}

class SearchZonesParams extends Params {
  String name;
  SearchZonesParams({required this.name});
}
