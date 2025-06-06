import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/di/repository_providers.dart';
import 'package:red_flags/domain/usecases/add_new_person.usecase.dart';
import 'package:red_flags/domain/usecases/check_new_person_form.usecase.dart';
import 'package:red_flags/domain/usecases/get_activity_by_id.usecase.dart';
import 'package:red_flags/domain/usecases/get_company_by_id.usecase.dart';
import 'package:red_flags/domain/usecases/get_person_by_id.usecase.dart';
import 'package:red_flags/domain/usecases/get_zone_by_id.usecase.dart';
import 'package:red_flags/domain/usecases/search_activities.usecase.dart';
import 'package:red_flags/domain/usecases/search_companies.usecase.dart';
import 'package:red_flags/domain/usecases/search_persons.usecase.dart';
import 'package:red_flags/domain/usecases/search_zones.usecase.dart';

final addNewPersonProvider = Provider((ref) {
  return AddNewPerson(personRepository: ref.read(personRepositoryProvider));
});

final getActivityByIDProvider = Provider((ref) {
  return GetActivityByID(activityRepository: ref.read(activityRepositoryProvider));
});

final getCompanyByIDProvider = Provider((ref) {
  return GetCompanyByID(companyRepository: ref.read(companyRepositoryProvider));
});

final getPersonByIDProvider = Provider((ref) {
  return GetPersonByID(personRepository: ref.read(personRepositoryProvider));
});

final getZoneByIDProvider = Provider((ref) {
  return GetZoneByID(zoneRepository: ref.read(zoneRepositoryProvider));
});

final searchActivitiesProvider = Provider((ref) {
  return SearchActivities(activityRepository: ref.read(activityRepositoryProvider));
});

final searchCompaniesProvider = Provider((ref) {
  return SearchCompanies(companyRepository: ref.read(companyRepositoryProvider));
});

final searchPersonsProvider = Provider((ref) {
  return SearchPersons(personRepository: ref.read(personRepositoryProvider));
});

final searchZonesProvider = Provider((ref) {
  return SearchZones(zoneRepository: ref.read(zoneRepositoryProvider));
});

final checkPersonFormProvider = Provider((ref) {
  return CheckNewPersonForm();
});
