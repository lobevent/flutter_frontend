import 'package:dartz/dartz.dart' show Either, left, right;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/main_app_bar.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/widgets/events_multilist_body.dart';

import '../../core/widgets/stylings/core_widgets_stylings_text_with_icon.dart';
import 'cubit/events_mulitlist_cubit.dart';


@deprecated
class EventsMultilistScreen extends StatelessWidget {
  final EventScreenOptions? option;
  final Profile? profile;
  EventsMultilistScreen(
      {Key? key, this.profile, this.option = EventScreenOptions.near})
      : super(key: key);

  // ------------------------------------ JUST BLOC AND STATE MANGEMENT STUFF ---------------------------------------------
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsMultilistCubit(
          option: option ?? EventScreenOptions.near, profile: profile),
      child: BlocConsumer<EventsMultilistCubit, EventsMultilistState>(
          listener: (context, state) => {},
          builder: (context, state) {


            bool isLoading = state.maybeMap((_) => false,
                loadedInvited: (s) => false,
                loading: (_) => true,
                orElse: () => false);

            // here starts the real deal
            return OwnEventScreenHolder(
              profile: profile,
              isLoading: isLoading,
            );
          }),
    );
  }
}

/// Has the Scaffold in it, and builds the children of the class
class OwnEventScreenHolder extends StatelessWidget {
  final Profile? profile;
  final bool isLoading;
  OwnEventScreenHolder({Key? key, this.profile, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigation = NavigationOptions.eventOverview;

    // var tabs = <Tab>[
    //   Tab(child: TextWithIcon(text: "Own", icon: Icons.person,)),
    //   Tab(child: TextWithIcon(text: "Invited", icon: Icons.mail,)),
    //   //Tab(child: TextWithIcon(text: "Refused", icon: Icons.person,)),
    // ];

    return BasicContentContainer(
        appBar: MainAppBar(),
        bottomNavigationBar: BottomNavigation(selected: navigation),
        child_ren: right(
            Container(
                child: EventsMultilistBody(profileView: profile!=null,)
            )
        ),
       /* isLoading: isLoading*/);
  }
}
