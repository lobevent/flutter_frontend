import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widget_components/event_profile_search_loader/cubit_epsl/event_profile_search_loader_cubit.dart';

import '../../../../../../../domain/event/event.dart';

class SearchEventList extends StatelessWidget {
  const SearchEventList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventProfileSearchLoaderCubit<Event>, EventProfileSearchLoaderState<Event>>(
        builder: (context, state){
          if(state.status == EpslStatus.loading){
            return LoadingEventsAnimation();
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: state.enities.length,
              itemBuilder: (context, index){
                return EventListTiles(event: state.enities[index], eventStatus: state.enities[index].status, key: ObjectKey(state.enities[index]),);
              });
        }
    );
  }
}
