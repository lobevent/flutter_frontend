import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/floating_button_right_left.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_basic/cubit__eop_single_tab_basic/eop_single_tab_basic_cubit.dart';


///
/// Shows list of events
/// an cubit with [EopSingleTabBasicState] must be provided
///
class SingleTabBasicEventOverview<CUBIT extends EopSingleTabBasicCubit> extends StatefulWidget {


  const SingleTabBasicEventOverview({Key? key, required this.attending}) : super(key: key);

  final bool attending;
  @override
  State<SingleTabBasicEventOverview> createState() => _SingleTabBasicEventOverviewState<CUBIT>();
}

class _SingleTabBasicEventOverviewState<C extends EopSingleTabBasicCubit> extends State<SingleTabBasicEventOverview> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, EopSingleTabBasicState>(
        builder: (context, state){
          switch (state.status){
            case Status.loading:
              return LoadingEventsAnimation();
              break;
            case Status.success:
              return EventListBuilder(state.events);
              break;
            case Status.failure:
              return NetworkErrorWidget(failure: state.failure!);
              break;
          }
        },
      );
  }


  ///
  /// builds event list
  ///
  Widget EventListBuilder(List<Event> events) {
    return Stack(
      children: [
        ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, i) {
              return EventListTiles(key: ObjectKey(events[i]), event: events[i]);
            }),
        FloatingButtonRightBottom(onPressed: () => context.read<C>().loadEvents())
      ],
    );
  }
}
