import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widget_components/event_profile_search_loader/cubit_epsl/event_profile_search_loader_cubit.dart';

class EventProfileSearchLoaderContainer extends StatelessWidget {
  final String searchString;

  final List<Tab> tabs = const [
    const Tab(
      text: "Profile",
    ),
    const Tab(
      text: "Event",
    )
  ];

  const EventProfileSearchLoaderContainer({Key? key, required this.searchString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
        BlocProvider(create: (BuildContext context) => EventProfileSearchLoaderCubit<Event>(searchString)),
        BlocProvider(create: (BuildContext context) => EventProfileSearchLoaderCubit<Profile>(searchString)),
    ], child: DefaultTabController(
      length: tabs.length,
      child: Column(
        children:
        [
          TabBar(tabs: this.tabs),
        ]

      ),
    ));
  }
}
