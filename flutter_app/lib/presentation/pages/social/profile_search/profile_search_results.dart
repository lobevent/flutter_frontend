import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_search/profile_search_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchResultsListView extends StatefulWidget {
  @override
  SearchResultsListViewState createState() => SearchResultsListViewState();
}

class SearchResultsListViewState extends State<SearchResultsListView>
    with TickerProviderStateMixin {
  String? searchTerm;
  List<Profile> profiles = [];
  List<Event> events = [];
  int selectedIndex = 0;

  //tabs to show
  final List<Tab> tabs = [
    Tab(
      text: "Profile",
    ),
    Tab(
      text: "Event",
    )
  ];

  late TabController tabController;

  //init the controller and listen on the index
  @override
  void initState() {
    tabController = getTabController();
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
      });
    });
    print("index $selectedIndex");
    super.initState();
  }

  int getSelectedIndex() {
    return selectedIndex;
  }

  TabController getTabController() {
    return TabController(length: tabs.length, vsync: this);
  }

  void handleTabs() {}

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  //generate list for events and profiles
  //List<Widget> generateTiles(List<>)

  //generate list for profiles
  List<Widget> generateProfileTiles(List<Profile> profiles) {
    return profiles
        .map((e) =>
            ClipRect(child: ProfileListTiles(key: ObjectKey(e.id), profile: e)))
        .toList();
  }

  //generate list for events
  List<Widget> generateEventTiles(List<Event> events) {
    return events
        .map((e) => ClipRect(
                child: EventListTiles(
              key: ObjectKey(e.id),
              event: e,
              allowEdit: false,
            )))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    //return normal search overlay
    /*if(searchTerm==null){
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }
     */
    final fsb = FloatingSearchBar.of(context);
    return BlocListener<ProfileSearchCubit, ProfileSearchState>(
      listener: (context, state) => {
        state.maybeMap(
            loaded: (state) =>
                {this.profiles = state.profiles, setState(() {})},
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
            body: TabBarView(controller: tabController, children: [
              ListView(children: generateProfileTiles(profiles)),
              ListView(children: generateEventTiles(events))
            ]
                /*ListView.builder(
                  // build under the floatingsearchbar
                  itemBuilder: (context, index) {
                    final profile = this.profiles[index];
                    if (profile.failureOption.isSome()) {
                      //red tile if profile failure
                      return ClipRect(
                        child: Ink(
                          color: Colors.red,
                          child: ListTile(
                            title: Text(profile.failureOption
                                .fold(() => "", (a) => a.toString())),
                          ),
                        ),
                      );
                    }
                    if (this.profiles.isEmpty) {
                      return ClipRect(
                        child: Ink(
                          color: Colors.red,
                          child: ListTile(
                            title: Text("No profiles Found"),
                          ),
                        ),
                      );
                    } else {
                      ///return profilelisttiles as searched
                      return ClipRect(
                        child: ProfileListTiles(
                            key: ObjectKey(profile),
                            profile: this.profiles[index]),
                      );
                    }
                  },
                  itemCount: this.profiles.length),
            ),

                 */
                ),
          ),
        ),
      ),
    );
  }
}
