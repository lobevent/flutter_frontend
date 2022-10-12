import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';

///Event Tabs contains an TabController an within two tabs: Upcoming Events and recent events!
class EventTabs extends StatelessWidget {

  final bool isLoading;
  final List<Event> upcoming;
  final List<Event> recendEvents;
  final Function(Event event, bool recent)? onDeletion;
  const EventTabs({Key? key, required this.upcoming, required this.recendEvents, this.isLoading = false, this.onDeletion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const TabBar(
            indicatorColor: AppColors.stdIndicatedTabColor,
            tabs: [
              StdSpacedIconTextTab(text: AppStrings.upcoming, iconHere: Icons.upcoming),
              StdSpacedIconTextTab(text: AppStrings.recent, iconHere: Icons.recent_actors_outlined),
            ],
          ),

          Expanded(child: Container(
              child: TabBarView(
                  children: isLoading ?
                  [
                    LoadingEventsAnimation(),
                    LoadingEventsAnimation(),
                  ]
                      :
                  [
                    EventListBuilder(upcoming, false),
                    EventListBuilder(recendEvents, true)
                  ])))
        ]));
  }


  /// generates Lisview of an eventList
  Widget EventListBuilder(List<Event> events, bool recent){
    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, i){
          return EventListTiles(key: ObjectKey(events[i]), event: events[i],
              onDeletion: onDeletion != null ? (Event event) => onDeletion!(event, recent) : null);
        });
  }
}
