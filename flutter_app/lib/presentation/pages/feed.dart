import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/pages/own_events_screen.dart';
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
            ExtendedNavigator.root.push(Routes.eventFormPage, arguments: EventFormPageArguments(editedEvent: null)
            // ExtendedNavigator.of(context).popUntil(
            //     (route) => route.settings.name == Routes.eventFormPage,
          );}, child: Text("Button1")),
          ElevatedButton(onPressed:() {
            ExtendedNavigator.root.push(Routes.ownEventsScreen, arguments: OwnEventsScreen()
              // ExtendedNavigator.of(context).popUntil(
              //     (route) => route.settings.name == Routes.eventFormPage,
            );}, child: Text("Button2"))
        ],
      )
    );
  }

}
