import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/cubit/event_overview_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/cubit/event_overview_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_tab_bar_view_distancebar.dart';

class EventOverviewTabBarView extends StatelessWidget {
  const EventOverviewTabBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventOverviewCubit, EventOverviewState>(
      builder: (context, state) {

        return Expanded(child: Container(
            child: TabBarView(
                children: state.map(
                    loading: (_) => List.generate(3, (index) => LoadingEventsAnimation()),
                    loaded: (loadedState) => LoadedEvents(loadedState),
                    failure: (failState) => List.generate(3, (index) => NetworkErrorWidget(failure: failState.failure,)
                    )
                )
            )
        )
        );

      },
    );
  }


  List<Widget> LoadedEvents(EventsLoaded loadedState){
    return [
      EventListBuilder(loadedState.attending_events),
      EventListBuilder(loadedState.invited_events),
      EventListBuilderLocal(loadedState.local),
    ];
  }

  Widget EventListBuilderLocal(List<Event> events){
    return CustomScrollView(
      slivers: [
        EOPTabBarViewDistanceBar(),

          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
                  (context, index) {
                    EventListTiles(key: ObjectKey(events[index]), event: events[index]);
                  },
              // Builds 1000 ListTiles
              childCount: events.length
            ),
          ),
      ],
      //controller: context.read<EventsMultilistCubit>().controller,
    );
  }

  Widget EventListBuilder(List<Event> events) {
    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, i) {
          return EventListTiles(key: ObjectKey(events[i]), event: events[i]);
        });
  }
}
