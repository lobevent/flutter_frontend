import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/gps_loading_animation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/floating_button_right_left.dart';
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
            case Status.loadingEvents:
              return EventListBuilderLocal(state.events, true);
              break;
            case Status.success:
              return EventListBuilderLocal(state.events, false);
              break;
            case Status.failure:
              return NetworkErrorWidget(failure: state.failure!);
              break;
            case Status.gettingGPSPosition:
              return GPSLoadingAnimation();
              break;
          }
        },
      );
  }

  Widget EventListBuilderLocal(List<Event> events, bool loading){
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            EOPTabBarViewDistanceBar(),

            // loading animation, it needs an sliver to box adapter! It is here, so the distance bare does not dissapear
            if(loading)
              SliverToBoxAdapter(child: Container(height: MediaQuery.of(context).size.height*0.6,child: LoadingEventsAnimation())),

            //if(loading == false)
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                    (BuildContext context, int index) {
                      return EventListTiles(key: ObjectKey(events[index]), event: events[index]);
                    },
                    // Builds 1000 ListTiles
                    childCount: events.length
                ),
              ),
          ],
          //controller: context.read<EventsMultilistCubit>().controller,
        ),
        FloatingButtonRightBottom(
          onPressed: (){context.read<EopSingleTabDistancesCubit>().loadEvents();},
        )
        ]);
  }


}
