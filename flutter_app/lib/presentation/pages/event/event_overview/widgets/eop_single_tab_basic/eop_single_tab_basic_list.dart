import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_basic/cubit__eop_single_tab_basic/eop_single_tab_basic_cubit.dart';


class SingleTabBasicEventOverview extends StatefulWidget {

  const SingleTabBasicEventOverview({Key? key, required this.attending}) : super(key: key);

  final bool attending;
  @override
  State<SingleTabBasicEventOverview> createState() => _SingleTabBasicEventOverviewState();
}

class _SingleTabBasicEventOverviewState extends State<SingleTabBasicEventOverview> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) =>  EopSingleTabBasicCubit(eventOption: widget.attending ? EventOptions.attending : EventOptions.invitations),
      child: BlocBuilder<EopSingleTabBasicCubit, EopSingleTabBasicState>(
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
      ),
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
