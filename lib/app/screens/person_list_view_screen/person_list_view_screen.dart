import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/widgets/listviews/card_person.dart';
import 'package:red_flags/app/widgets/listviews/slide_person_list_view.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/models/person.model.dart';

class PersonListViewScreenScreen extends ConsumerStatefulWidget {
  final String firstname;
  final String lastname;
  final String zonename;
  final String jobname;

  const PersonListViewScreenScreen({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.zonename,
    required this.jobname,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<PersonListViewScreenScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// * Header container with page name.
          TitleContainer(
            title: AppLocalizations.of(context)!.personListViewScreenTitle,
            subtitle: "${AppLocalizations.of(context)!.personListViewScreenSubTitle} (${10})",
          ),
          Expanded(
            child: SlideListView(
              itemCount: 40, // Replace with the actual number of items
              itemBuilder: (context, index) {
                return CardPerson(
                  person: Person(
                    id: "ID FUCK",
                    firstname: "Sacha",
                    lastname: "Djurdjevic",
                    birthday: DateTime.now(),
                    zonename: "Nantes",
                    jobname: "Une merde",
                    createdDate: DateTime.now(),
                    updatedDate: DateTime.now(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
