import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles.dart';

///Event Tabs contains an TabController an within two tabs: Upcoming Events and recent events!
class EventTabs extends StatelessWidget {
  final List<Event> upcoming;
  final List<Event> recendEvents;
  const EventTabs({Key? key, required this.upcoming, required this.recendEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const TabBar(
            indicatorColor: AppColors.stdIndicatedTabColor,
            tabs: [
              StdSpacedIconTextTab(text: "Upcoming", iconHere: Icons.upcoming),
              StdSpacedIconTextTab(text: "Recent", iconHere: Icons.recent_actors_outlined),
            ],
          ),

          Expanded(child: Container(
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    EventListBuilder(upcoming),
                    EventListBuilder(recendEvents)
                  ])))
        ])));
  }


  /// generates Lisview of an eventList
  Widget EventListBuilder(List<Event> events){
    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, i){
          return EventListTiles(key: ObjectKey(events[i]), event: events[i]);
        });
  }
}
