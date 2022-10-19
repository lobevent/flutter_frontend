import 'dart:math';

import 'package:dartz/dartz.dart' show right, left;
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/event_recent_upcoming_tabs.dart';
import 'package:flutter_frontend/presentation/pages/event/events_user/cubit/events_user_cubit.dart';

import '../../../../domain/event/event.dart';

///
/// Main page of the userEventOverview
///
class EventUserPage extends StatelessWidget {
  final Profile profile;

  const EventUserPage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => EventsUserCubit(profile),
      child: BlocBuilder<EventsUserCubit, EventsUserState>(
        builder: (context, state) {

          return BasicContentContainer(
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                context.read<EventsUserCubit>().loadEvents();
              },
              child: Icon(Icons.refresh_outlined),
              backgroundColor: AppColors.accentColor,
            ),
              child_ren: right(
              _mapLoadingOrContent(state, context)
          ));
        },
      ),
    );
  }



  ///
  /// maps the current state to an representing widget and adds an deletionfunktion if the profile of the event is the same as the viewing profile
  /// TODO: move the functionalitiy for deletion and editing into the [eventListTile]
  ///
  Widget _mapLoadingOrContent(EventsUserState state, BuildContext context){
    bool isOwnProfile = CommonHive.checkIfOwnId(profile.id.value);
    Function(Event event, bool recent)? onDeletion;
    if(isOwnProfile){
      onDeletion = context.read<EventsUserCubit>().deleteEvent;
    }
    return state.map(loading: (_) => EventTabs(upcoming: [], recendEvents: [], isLoading: true,),
        loaded: (loadedState) => EventTabs(
            onDeletion: onDeletion,
            upcoming: loadedState.future_events,
            recendEvents: loadedState.recent_events),
            failure: (failure) => NetworkErrorWidget(failure: failure.failure),
    );
  }
}








  