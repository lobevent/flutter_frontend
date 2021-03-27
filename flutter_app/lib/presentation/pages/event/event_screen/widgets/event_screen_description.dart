import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';

class EventScreenDescription extends StatelessWidget{
  final EventDescription description;

  EventScreenDescription({Key? key, required this.description}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(description.getOrCrash()));
  }

}