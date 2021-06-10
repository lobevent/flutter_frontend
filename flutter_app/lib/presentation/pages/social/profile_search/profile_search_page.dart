import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_search/profile_search_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ProfileSearchPage extends StatefulWidget {
  @override
  _ProfileSearchState createState() => _ProfileSearchState();
}

class _ProfileSearchState extends State<ProfileSearchPage> {
  String? profileSearch;
  List<Profile> profiles = [];

  //searchhistory with 5 last searched terms
  static const historyLength = 5;
  static List<String> _searchHistory = [
    "gunther",
    "spast",
    "boss",
    "thb",
    "mongo"
  ];
  List<String>? filteredSearchHistory;
  String? selectedTerm;

  List<String> filterSearchTerms({required String? filter}) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileSearchCubit(),
      child: Scaffold(
          body: FloatingSearchBar(
              controller: controller,
              body: FloatingSearchBarScrollNotifier(
                child: SearchResultsListView(),
              ),
              transition: CircularFloatingSearchBarTransition(),
              physics: BouncingScrollPhysics(),
              title: Text(selectedTerm ?? "Search"),
              hint: 'Search and find out',
              actions: [
                FloatingSearchBarAction.searchToClear(),
              ],
              onQueryChanged: (query) {
                //search for old recommendations
                setState(() {
                  filteredSearchHistory = filterSearchTerms(filter: query);
                });
              },
              onSubmitted: (query) async {
                setState(() {
                  if (query != "") {
                    addSearchTerm(query);
                    selectedTerm = query;
                    //context.read<ProfileSearchCubit>().searchByProfileName(query);
                  }
                });
              },
              builder: (context, transition) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Colors.white,
                      elevation: 4,
                      child: Builder(
                        builder: (context) {
                          //if query and history is empty, return the Start Searching Site
                          if (filteredSearchHistory!.isEmpty &&
                              controller.query.isEmpty) {
                            return Container(
                              height: 56,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Start Searching',
                                maxLines: 1,
                              ),
                            );
                          } else if (filteredSearchHistory!.isEmpty) {
                            // if empty add query and show query as tile
                            return ListTile(
                              title: Text(controller.query),
                              leading: const Icon(Icons.search),
                              onTap: () {
                                setState(() {
                                  addSearchTerm(controller.query);
                                  selectedTerm = controller.query;
                                });
                                controller.close();
                              },
                            );
                          } else {
                            //return the previous search history results
                            return Column(
                              children: filteredSearchHistory!
                                  .map(
                                    (term) => ListTile(
                                  title: Text(
                                    term,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: const Icon(Icons.history),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        deleteSearchTerm(term);
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      putSearchTermFirst(term);
                                      selectedTerm = term;
                                    });
                                    controller.close();
                                  },
                                ),
                              )
                                  .toList(),
                            );
                          }
                        },
                        //itemCount: this.profiles.length),
                      ),
                    ));
                }
                )),);
    }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class SearchResultsListViewHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    }else return
  }

     */
    return Scaffold(body: SearchResultsListView());
  }
}

class SearchResultsListView extends StatefulWidget {
  @override
  SearchResultsListViewState createState() => SearchResultsListViewState();
}

class SearchResultsListViewState extends State<SearchResultsListView> {
  String? searchTerm;
  List<Profile> profiles = [];

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
    return BlocListener<ProfileSearchCubit, ProfileSearchState>(
      listener: (context, state) => {
        state.maybeMap(
            loaded: (state) =>
                {this.profiles = state.profiles, setState(() {})},
            orElse: () => {})
      },
      child:
          /*ListView(
          children: List.generate(
            profiles.length, (index) => ProfileListTiles(
            profile: Profile(id: UniqueId(), name: ProfileName("gunther")),
            key: ObjectKey(null),
          ),
          ),
        )

         */
          ListView.builder(
              itemBuilder: (context, index) {
                final profile = this.profiles[index];
                if (profile.failureOption.isSome()) {
                  return Ink(
                    color: Colors.red,
                    child: ListTile(
                      title: Text(profile.failureOption
                          .fold(() => "", (a) => a.toString())),
                    ),
                  );
                }
                if (this.profiles.isEmpty) {
                  return Ink(
                    color: Colors.red,
                    child: ListTile(
                      title: Text("No profiles Found"),
                    ),
                  );
                } else {
                  return ProfileListTiles(
                      key: ObjectKey(profile), profile: this.profiles[index]);
                }
              },
              itemCount: this.profiles.length),
    );
  }
}
