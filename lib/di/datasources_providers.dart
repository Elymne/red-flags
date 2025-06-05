import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/infra/datasources/remote_activity_datasource.dart';
import 'package:red_flags/infra/datasources/remote_company_datasource.dart';
import 'package:red_flags/infra/datasources/remote_person_datasource.dart';
import 'package:red_flags/infra/datasources/remote_zone_datasource.dart';

final dioProvider = Provider((ref) {
  return Dio();
});

final remoteActivityDatasourceProvider = Provider((ref) {
  return RemoteActivityDatasource(dio: ref.read(dioProvider));
});

final remoteCompanyDatasourceProvider = Provider((ref) {
  return RemoteCompanyDatasource(dio: ref.read(dioProvider));
});

final remoteZoneDatasourceProvider = Provider((ref) {
  return RemoteZoneDatasource(dio: ref.read(dioProvider));
});

final remotePersonDatasourceProvider = Provider((ref) {
  return RemotePersonDatasource(dio: ref.read(dioProvider));
});
