import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_distances/cubit__eop_single_tab_distances/eop_single_tab_distances_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_distances/eop_single_tab_distances_list_distancebar.dart';


class SingleTabDistancesEventOverview extends StatefulWidget {

  const SingleTabDistancesEventOverview({Key? key}) : super(key: key);

  @override
  State<SingleTabDistancesEventOverview> createState() => SingleTabDistancesEventOverviewState();
}

class SingleTabDistancesEventOverviewState extends State<SingleTabDistancesEventOverview> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EopSingleTabDistancesCubit, EopSingleTabDistancesState>(
        builder: (context, state){
          switch (state.status){
            case Status.loading:
              return LoadingEventsAnimation();
              break;
            case Status.success:
              return EventListBuilderLocal(state.events);
              break;
            case Status.failure:
              return NetworkErrorWidget(failure: state.failure!);
              break;
          }
        },
      );
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
}
