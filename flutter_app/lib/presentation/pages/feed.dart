import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'file:///D:/Programming/Flutter/flutter_frontend/flutter_app/lib/presentation/pages/Event/OwnEvents/own_events_screen.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed:() {

            //router = context.router;

            context.router.push(EventFormPageRoute(editedEventId: ""),
            // ExtendedNavigator.of(context).popUntil(
            //     (route) => route.settings.name == Routes.eventFormPage,
          );}, child: Text("Button1")),
          ElevatedButton(onPressed:() {
            context.router.push(OwnEventsScreenRoute());
            }, child: Text("Button2"))
        ],
      )
    );
  }

}
