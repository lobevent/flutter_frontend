import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/event/event.dart';
import '../../../../../domain/profile/profile.dart';
import '../../../../../infrastructure/core/local/common_hive/common_hive.dart';
import '../../../../../l10n/app_strings.dart';
import '../../../core/widgets/bottom_navigation.dart';
import '../../../event/core/event_list_tiles/event_list_tiles.dart';
import '../../../event/core/profile_list_tiles.dart';
import '../cubit/profile_search_cubit.dart';

class ProfileSearchResultsTabs extends StatefulWidget {
  @override
  ProfileSearchResultsTabsState createState() =>
      ProfileSearchResultsTabsState();
}

class ProfileSearchResultsTabsState extends State<ProfileSearchResultsTabs>
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSearchCubit, ProfileSearchState>(
        builder: (context, state) {
      return state.maybeMap(
          loadedBoth: (loadedBoth) {
            return DefaultTabController(
                length: tabs.length,
                child: Column(
                  children: [
                    TabBar(
                      controller: tabController,
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.red,
                      tabs: tabs,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: generateProfileTiles(
                                  getProfileListWithoutOwn(
                                      loadedBoth.profiles))),
                          ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: generateEventTiles(loadedBoth.events)),
                        ],
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ),
                  ],
                ));
          },
          orElse: () => Text(
                "somefail",
              ));
    });
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

  //return profile list without my own profile
  List<Profile> getProfileListWithoutOwn(List<Profile> profiles) {
    String? ownId = CommonHive.getOwnProfileId();
    if (ownId != null && profiles.isNotEmpty) {
      List<Profile> profilesMirror = profiles.toList();
      int index = profilesMirror
          .indexWhere((element) => element.id.value.toString() == ownId);
      profilesMirror.removeAt(index);
      return profilesMirror;
    }
    return profiles;
  }
}
