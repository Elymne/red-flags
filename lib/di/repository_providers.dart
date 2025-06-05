import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/infra/datasources/remote_activity_datasource.dart';
import 'package:red_flags/infra/datasources/remote_company_datasource.dart';
import 'package:red_flags/infra/datasources/remote_person_datasource.dart';
import 'package:red_flags/infra/datasources/remote_zone_datasource.dart';
import 'package:red_flags/infra/repositories/activity_repository_impl.dart';
import 'package:red_flags/infra/repositories/company_repository_impl.dart';
import 'package:red_flags/infra/repositories/person_repository_impl.dart';
import 'package:red_flags/infra/repositories/zone_repository_impl.dart';

final activityRepositoryProvider = Provider((ref) {
  return ActivityRepositoryImpl(remoteActivityDatasource: ref.read(remoteActivityDatasourceProvider));
});

final companyRepositoryProvider = Provider((ref) {
  return CompanyRepositoryImpl(remoteCompanyDatasource: ref.read(remoteCompanyDatasourceProvider));
});

final zoneRepositoryProvider = Provider((ref) {
  return ZoneRepositoryImpl(remoteZoneDatasource: ref.read(remoteZoneDatasourceProvider));
});

final personRepositoryProvider = Provider((ref) {
  return PersonRepositoryImpl(remotePersonDatasource: ref.read(remotePersonDatasourceProvider));
});
