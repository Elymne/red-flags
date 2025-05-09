import 'package:flutter/material.dart';
import 'package:red_flags/models/person.model.dart';

class CardPerson extends StatefulWidget {
  final Person person;

  const CardPerson({super.key, required this.person});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CardPerson> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text((1).toString())),
      title: Text('Person ${1}'),
      subtitle: Text('Subtitle for Person ${1}'),
      onTap: () {
        /// TODO Access to details.
      },
    );
  }
}
