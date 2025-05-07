import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/widgets/animations/slide_person_list_view.dart';
import 'package:red_flags/app/widgets/title_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            subtitle: AppLocalizations.of(context)!.personListViewScreenSubTitle,
          ),
          Expanded(
            child: SlideListView(
              itemCount: 20, // Replace with the actual number of items
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text((index + 1).toString())),
                  title: Text('Person ${index + 1}'),
                  subtitle: Text('Subtitle for Person ${index + 1}'),
                  onTap: () {
                    // Handle tap event
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
