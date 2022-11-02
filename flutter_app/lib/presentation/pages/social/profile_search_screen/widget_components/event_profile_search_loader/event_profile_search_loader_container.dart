import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widget_components/event_profile_search_loader/cubit_epsl/event_profile_search_loader_cubit.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widget_components/event_profile_search_loader/widgets/event_list.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widget_components/event_profile_search_loader/widgets/event_profile_listview_builder.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widget_components/event_profile_search_loader/widgets/profile_list.dart';

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
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: MultiBlocProvider(providers: [
          BlocProvider(create: (BuildContext context) => EventProfileSearchLoaderCubit<Event>(searchString)),
          BlocProvider(create: (BuildContext context) => EventProfileSearchLoaderCubit<Profile>(searchString)),
      ], child: DefaultTabController(
        length: tabs.length,
        child: Column(
          children:
          [
            TabBar(tabs: this.tabs),
            const Expanded(
              child: TabBarView(
                children: [
                  EventProfileListViewBuilder<Profile>(),
                  EventProfileListViewBuilder<Event>(),
              ],),
            )
          ]

        ),
      )),
    );
  }
}
