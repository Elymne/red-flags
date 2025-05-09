import 'package:flutter/material.dart';
import 'package:red_flags/models/person.model.dart';

class CardPerson extends StatefulWidget {
  final Person person;

  const CardPerson({super.key, required this.person});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CardPerson> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    /// TODO Here's our image placeholder.
    final img = "https://cdn.futura-sciences.com/sources/images/actu/esperance-vie-chiens-chiot-golden-retriever.jpg";

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          /// * Imagtes
          shape: BoxShape.rectangle,
          image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
        ),
      ),
      title: Text("${widget.person.lastname} ${widget.person.firstname}"),
      subtitle: Text("${widget.person.zonename} - ${widget.person.jobname}"),
      onTap: () {
        /// TODO Access to details.
      },
    );
  }
}
