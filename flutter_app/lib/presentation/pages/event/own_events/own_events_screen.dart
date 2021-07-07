import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/Event/own_events/widgets/own_events_body.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';


class OwnEventsScreen extends StatelessWidget {
  final EventScreenOptions option;
  final Profile? profile;
  const OwnEventsScreen({Key? key, this.option = EventScreenOptions.owned, this.profile}) : super(key: key);

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnEventsCubit(option: option),
      child: BlocConsumer<OwnEventsCubit, OwnEventsState>(
        listener: (context, state) => {},
          builder: (context, state) {
            bool isLoading = state.maybeMap((_) => false,
                loading: (_) => true, orElse: () => false);
            return LoadingOverlay(
                isLoading: isLoading,
                child: OwnEventScreenHolder(profile: profile,));
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
    String appBarText = "";
    switch(context.read<OwnEventsCubit>().option){
      case EventScreenOptions.owned:
        appBarText = "Own events";
        break;
      case EventScreenOptions.fromUser:
        appBarText = "Events from $profile";
        break;
      case EventScreenOptions.ownAttending:
        appBarText = "Own Attending Events";
        break;
      case EventScreenOptions.unreacted:
        appBarText = "Unreacted Events";
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarText),
        ),
        body: OwnEventsBody());
  }
}
