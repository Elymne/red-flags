import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

enum PersonFormInfo { tooShortFirstname, tooShortLastname, tooYoung, imcomplete }

class CheckNewPersonForm extends Usecase<Either<DatasourceFailure, List<PersonFormInfo>>, CheckNewPersonFormParams> {
  CheckNewPersonForm();

  @override
  Future<Either<DatasourceFailure, List<PersonFormInfo>>> perform(CheckNewPersonFormParams params) async {
    final List<PersonFormInfo> infos = [];
    if (params.firstname != null && params.firstname!.length < 2) {
      infos.add(PersonFormInfo.tooShortFirstname);
    }

    if (params.lastname != null && params.lastname!.length < 2) {
      infos.add(PersonFormInfo.tooShortLastname);
    }

    if (params.birthDate != null) {
      final age = DateTime.now().difference(params.birthDate!).inDays / 365.25;
      if (age < 18.0) {
        infos.add(PersonFormInfo.tooYoung);
      }
    }

    if (params.firstname == null &&
        params.lastname == null &&
        params.birthDate == null &&
        params.zone == null &&
        params.company == null &&
        params.activity == null) {
      infos.add(PersonFormInfo.imcomplete);
    }

    return Success(infos);
  }
}

class CheckNewPersonFormParams extends Params {
  final String? firstname;
  final String? lastname;
  final DateTime? birthDate;
  final Zone? zone;
  final Company? company;
  final Activity? activity;

  CheckNewPersonFormParams({this.firstname, this.lastname, this.birthDate, this.zone, this.company, this.activity});
}
