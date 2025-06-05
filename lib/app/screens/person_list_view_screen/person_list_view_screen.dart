import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/widgets/listviews/card_person.dart';
import 'package:red_flags/app/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';
import 'package:red_flags/domain/models/person.model.dart';

class PersonListViewScreenScreen extends ConsumerStatefulWidget {
  final List<Person> persons;

  const PersonListViewScreenScreen({super.key, required this.persons});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<PersonListViewScreenScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// * Header container with page name.
          TitleContainer(
            title: AppLocalizations.of(context)!.personListViewScreenTitle,
            subtitle: "${AppLocalizations.of(context)!.personListViewScreenSubTitle} (${widget.persons.length})",
          ),

          /// * The listview.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SlideListView(
                itemCount: widget.persons.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CardPerson(person: widget.persons[index]),
                      if (index < widget.persons.length - 1) Divider(color: Theme.of(context).colorScheme.onSurface, thickness: 2),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
