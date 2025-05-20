import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/detailed_person_screen/detailed_person_screen.dart';
import 'package:red_flags/models/person.model.dart';

class CardPerson extends ConsumerStatefulWidget {
  final Person person;

  const CardPerson({super.key, required this.person});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CardPerson> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    /// TODO Check that portrait exists, else use placeholder.
    final img =
        widget.person.portrait ?? "https://cdn.futura-sciences.com/sources/images/actu/esperance-vie-chiens-chiot-golden-retriever.jpg";

    return ListTile(
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      splashColor: Theme.of(context).colorScheme.primary.withAlpha(100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.onSecondary, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)),
      ),
      title: Text("${widget.person.lastName} ${widget.person.firstName}"),
      subtitle: Text("${widget.person.zone.name} - ${widget.person.activity}"),
      onTap: () {
        /// * Goto list view person widget.
        ref.read(routerNotifierprovider.notifier).changeScreen(() {
          /// * Navigate.
          final navigator = Navigator.of(context);
          navigator.push(MaterialPageRoute(builder: (context) => DetailedPersonScreen(id: widget.person.id)));
        });
      },
    );
  }
}
