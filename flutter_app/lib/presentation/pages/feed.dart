import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/event_screen_page.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_friends/profile_friends_page.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search/profile_search_page.dart';
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
            ElevatedButton(
                onPressed: () {
                  //router = context.router;

                  context.router.push(
                    EventFormPageRoute(),
                    // ExtendedNavigator.of(context).popUntil(
                    //     (route) => route.settings.name == Routes.eventFormPage,
                  );
                },
                child: Text("EventForm")),
            ElevatedButton(
                onPressed: () {
                  context.router.push(EventsMultilistScreenRoute());
                },
                child: Text("OwnEvents")),
            ElevatedButton(
                onPressed: () {
                  context.router.push(EventScreenPageRoute(
                      eventId: UniqueId.fromUniqueString(
                          "30c4fc98-0e49-4903-a895-edb27a0ae70c")));
                },
                child: Text("EventScreen")),
            ElevatedButton(
                onPressed: () {
                  context.router.push(ProfilePageRoute(
                      profileId: UniqueId.fromUniqueString("")));
                },
                child: Text("OwnProfile")),
            ElevatedButton(
                onPressed: () {
                  context.router.push(LoginScreenRoute());
                },
                child: Text("Login")),
            ElevatedButton(
                onPressed: () {
                  context.router.push(ProfileSearchPageRoute());
                },
                child: Text("ProfileSearch")),
            ElevatedButton(
                onPressed: () {
                  context.router.push(ProfileFriendsScreenRoute());
                },
                child: Text("Friends")),
          ],
        ));
  }
}
