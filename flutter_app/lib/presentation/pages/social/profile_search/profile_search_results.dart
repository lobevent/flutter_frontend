import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'cubit/profile_search_cubit.dart';

class SearchResultsListView extends StatefulWidget {
  @override
  SearchResultsListViewState createState() => SearchResultsListViewState();
}

class SearchResultsListViewState extends State<SearchResultsListView>
    with TickerProviderStateMixin {
  List<Profile> profiles = [];
  List<Event> events = [];
  int selectedIndex = 0;

  //tabs to show
  final List<Tab> tabs = [
    const Tab(
      text: "Profile",
    ),
    const Tab(
      text: "Event",
    )
  ];

  late TabController tabController;

  //init the controller and listen on the index
  @override
  void initState() {
    tabController = getTabController();
    //tabController.addListener();
    super.initState();
  }

  int getSelectedIndex() {
    return selectedIndex;
  }

  TabController getTabController() {
    return TabController(length: tabs.length, vsync: this);
  }

  void handleTabSection() {
    if (tabController.indexIsChanging) {}
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  //generate list for events and profiles
  //List<Widget> generateTiles(List<>)

  ///generate list for profiles
  List<Widget> generateProfileTiles(List<Profile> profiles) {
    if (profiles.isEmpty) {
      return [
        const Center(
          child: Text(AppStrings.noProfilesFound),
        ),
      ];
    } else {
      return profiles
          .map((e) => ClipRect(
                  child: ProfileListTiles(
                key: ObjectKey(e.id),
                profile: e,
                onFriendRequest: (Profile profile) {
                  context.read<ProfileSearchCubit>().sendFriendship(profile.id);
                },
              )))
          .toList();
    }
  }

  ///generate list for events but both are preloaded ^^
  List<Widget> generateEventTiles(List<Event> events) {
    if (events.isEmpty) {
      return [
        const Center(
          child: Text(AppStrings.noEventsFound),
        )
      ];
    } else {
      return events
          .map((e) => ClipRect(
                  child: EventListTiles(
                key: ObjectKey(e.id),
                event: e,
              )))
          .toList();
    }
  }

  ///build initial search screen in tabs
  Widget buildStartSearching(BuildContext context, String eventProfile) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search,
            size: 64,
          ),
          Text(
            'Start searching $eventProfile',
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
    );
  }

  ///build the searchresults, so profiletiles or eventtiles, and show them dependently on the selected tab
  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);
    bool isInit = true;
    return BlocListener<ProfileSearchCubit, ProfileSearchState>(
      listener: (context, state) => {
        state.maybeMap(
            //map depending on tab index?
            loadedEvents: (state) =>
                {this.events = state.events, isInit = false, setState(() {})},
            loadedProfiles: (state) => {
                  this.profiles = state.profiles,
                  isInit = false,
                  setState(() {})
                },
            loadedBoth: (state) => {
                  this.events = state.events,
                  this.profiles = state.profiles,
                  isInit = false,
                  setState(() {})
                },
            orElse: () => {})
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: fsb!.value.height + fsb.value.margins.vertical),
        child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: TabBar(
              controller: tabController,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.red,
              tabs: tabs,
            ),
            //decide if  it builds profiles or events, depending on the clicked tab
            body: BlocBuilder<ProfileSearchCubit, ProfileSearchState>(
                builder: (context, state) {
              bool init = state.maybeMap(
                  initial: (_) => true,
                  loading: (_) => false,
                  orElse: () => false);
              if (init) {
                //on initial build the big search initial screen
                return TabBarView(
                  controller: tabController,
                  children: [
                    ListView(children: [buildStartSearching(context, "users")]),
                    ListView(children: [buildStartSearching(context, "events")])
                  ],
                );
              } else {
                return state.maybeMap(loading: (loading) {
                  return LoadingIndicator(isLoading: true);
                }, loadedBoth: (loadedBoth) {
                  return TabBarView(
                    controller: tabController,
                    children: [
                      ListView(
                          children: generateProfileTiles(loadedBoth.profiles)),
                      ListView(children: generateEventTiles(loadedBoth.events)),
                    ],
                  );
                }, error: (err) {
                  print(err.toString());
                  return Text("");
                }, orElse: () {
                  return TabBarView(
                    controller: tabController,
                    children: [
                      ListView(
                          children: [buildStartSearching(context, "users")]),
                      ListView(
                          children: [buildStartSearching(context, "events")])
                    ],
                  );
                });
              }
            }),
          ),
        ),
      ),
    );
  }
}
