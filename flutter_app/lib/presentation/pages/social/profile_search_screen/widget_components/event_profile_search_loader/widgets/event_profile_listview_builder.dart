import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/core/list_tiles/ProfileListTiles/profile_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/cubit/main_profile_search_cubit.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/cubit/main_profile_search_cubit.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widget_components/event_profile_search_loader/cubit_epsl/event_profile_search_loader_cubit.dart';

import '../../../../../../../domain/event/event.dart';

class EventProfileListViewBuilder<T> extends StatelessWidget {
  const EventProfileListViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return BlocListener<MainProfileSearchCubit, MainProfileSearchState>(
    //   listenWhen: (p, c) => p.searchbarOpen != c.searchbarOpen && c.searchString != p.searchString,
    //   listener: (c, state) {
    //     context.read<EventProfileSearchLoaderCubit<T>>().searchByString(state.searchString!);
    //   },
    //   child:
     return BlocBuilder<EventProfileSearchLoaderCubit<T>, EventProfileSearchLoaderState<T>>(
          builder: (context, state) {
            if (state.status == EpslStatus.loading) {
              return LoadingEventsAnimation();
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.enities.length,
                itemBuilder: (context, index) {
                  return decideWhichTiles(state, index);
                });
          }
     // ),
    );
  }

  Widget decideWhichTiles(EventProfileSearchLoaderState<T> state, int index) {
    if (T == Profile) {
      return ProfileListTiles(profile: state.enities[index] as Profile, hideActions: false, key: ObjectKey(state.enities[index]),);
    } else if (T == Event) {
      return EventListTiles(
        event: state.enities[index] as Event, eventStatus: (state.enities[index] as Event).status, key: ObjectKey(state.enities[index] as Event),);
    } else {
      throw LogicError();
    }
  }
}
