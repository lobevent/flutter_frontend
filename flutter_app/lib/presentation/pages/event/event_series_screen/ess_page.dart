import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/cubit/event_series_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/eventseries_list/widgets/esl_page_eventTabs.dart';

class EventSeriesScreenPage extends StatelessWidget {
  final UniqueId seriesId;
  const EventSeriesScreenPage({Key? key, required this.seriesId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventSeriesScreenCubit(seriesId: seriesId),
      child: BlocBuilder<EventSeriesScreenCubit, EventSeriesScreenState>(builder: (context, state) {
        return BasicContentContainer(
            isLoading: state is ESS_Loading,
            child_ren: right(Column(
              mainAxisSize: MainAxisSize.min,
              children: state.maybeMap(
                  orElse: () {
                    return [];
                  },
                  ready: (state) => [
                    Text("Event Series: " + state.series.name.getOrCrash(), style: AppTextStyles.stdLittleHeading),
                    EventTabs( upcoming: state.series.upcomingEvents?? [], recendEvents: state.series.recentEvents?? [])]),
            )));
      }),
    );
  }

  //
  //
  //
  // Widget EventTabs(List<Event> upcoming, List<Event> recendEvents, BuildContext context) {
  //   return DefaultTabController(
  //       length: 2,
  //       child: Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
  //         TabBar(
  //           indicatorColor: AppColors.stdIndicatedTabColor,
  //           tabs: [
  //             StdSpacedIconTextTab(text: "Upcoming", iconHere: Icons.upcoming),
  //             StdSpacedIconTextTab(text: "Recent", iconHere: Icons.recent_actors_outlined),
  //           ],
  //         ),
  //
  //         Expanded(child: Container(
  //           //height: MediaQuery.of(context).size.height -171, //TODO: This might not work on all devices!
  //             child: TabBarView(
  //             physics: NeverScrollableScrollPhysics(),
  //             children: [
  //           EventListBuilder(upcoming),
  //           EventListBuilder(recendEvents)
  //         ])))
  //       ])));
  // }
  //
  // Widget EventListBuilder(List<Event> events){
  //   return ListView.builder(
  //       itemCount: events.length,
  //       itemBuilder: (context, i){
  //         return EventListTiles(key: ObjectKey(events[i]), event: events[i]);
  //       });
  // }
}
