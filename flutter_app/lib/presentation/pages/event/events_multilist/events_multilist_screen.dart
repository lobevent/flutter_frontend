import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/widgets/events_multilist_body.dart';

import 'cubit/events_mulitlist_cubit.dart';

class EventsMultilistScreen extends StatelessWidget {
  final EventScreenOptions? option;
  final Profile? profile;
  EventsMultilistScreen(
      {Key? key, this.profile, this.option = EventScreenOptions.owned})
      : super(key: key);

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsMultilistCubit(
          option: option ?? EventScreenOptions.owned, profile: profile),
      child: BlocConsumer<EventsMultilistCubit, EventsMultilistState>(
          listener: (context, state) => {},
          builder: (context, state) {
            bool isLoading = state.maybeMap((_) => false, loadedInvited: (s) => false,
                loading: (_) => true, orElse: () => false);
            return LoadingOverlay(
                isLoading: isLoading,
                child: OwnEventScreenHolder(
                  profile: profile,
                ));
          }),
    );
  }
}

/// Has the Scaffold in it, and builds the children of the class
class OwnEventScreenHolder extends StatelessWidget {
  final Profile? profile;
  OwnEventScreenHolder({Key? key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  var navigation = NavigationOptions.ownEvents;
    String appBarText = "";
    switch (context.read<EventsMultilistCubit>().option) {
      case EventScreenOptions.owned:
        appBarText = "Own events";
        break;
      case EventScreenOptions.fromUser:
        appBarText = "Events from ${profile?.name.getOrCrash() ?? ""}";
        break;
      case EventScreenOptions.ownAttending:
        appBarText = "Own Attending Events";
        break;
      case EventScreenOptions.unreacted:
        appBarText = "Unreacted Events";
        break;
      case EventScreenOptions.invited:
        appBarText = "Invited Events";
        navigation = NavigationOptions.invited;
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarText),
        ),
        bottomNavigationBar: BottomNavigation(selected: navigation),
        body: EventsMultilistBody());
  }
}
