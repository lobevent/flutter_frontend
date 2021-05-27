import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_search/profile_search_cubit.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ProfileSearchScreenScaffold extends StatelessWidget {
  const ProfileSearchScreenScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileSearchPage(),
    );
    throw UnimplementedError();
  }
}

class ProfileSearchPage extends StatefulWidget {
  @override
  _ProfileSearchState createState() => _ProfileSearchState();
}

class _ProfileSearchState extends State<ProfileSearchPage> {
  List<Profile> profiles = [];
  String? profileSearch;

  //searchhistory with 5 last searched terms
  static const historyLength = 5;
  static List<String> _searchHistory = [];
  List<String>? filteredSearchHistory;
  String selectedTerm = "";

  List<String> filterSearchTerms({
    required String filter,
  }) {
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

    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileSearchCubit(),
      child: BlocConsumer<ProfileSearchCubit, ProfileSearchState>(
        listener: (context, state) => {
          //loading
          state.maybeMap((value) => {},
              loaded: (state) =>
                  {this.profiles = state.profiles, setState(() {})},
              orElse: () => {})
        },
        builder: (context, state) {
          return Scaffold(
              body: FloatingSearchBar(
            controller: controller,
            body: FloatingSearchBarScrollNotifier(
              child: SearchResultsListView(
                searchTerm: selectedTerm,
              ),
            ),
            transition: CircularFloatingSearchBarTransition(),
            physics: BouncingScrollPhysics(),
            title: Text('Search this'),
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
            onSubmitted: (query) {
              setState(() {
                addSearchTerm(query);
                selectedTerm = query;
              });
              context.read<ProfileSearchCubit>().searchByProfileName(query);
            },
            builder: (context, transition) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  elevation: 4,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final profile = this.profiles[index];
                        if (profile.failureOption.isSome()) {
                          return Ink(
                              color: Colors.red,
                              child: ListTile(
                                title: Text(profile.failureOption
                                    .fold(() => "", (a) => a.toString())),
                              ));
                        }
                        if (this.profiles.isEmpty) {
                          return Ink(
                              color: Colors.red,
                              child: ListTile(title: Text("No User found")));
                        } else {
                          return ProfileListTiles(
                              key: ObjectKey(profile),
                              profile: this.profiles[index]);
                        }
                      },
                      itemCount: this.profiles.length),
                ),
              );
            },
          ));
        },
      ),
    );
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  const SearchResultsListView({
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context) {
    if (searchTerm == null) {
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

    final fsb = FloatingSearchBar.of(context);

    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: List.generate(
        5,
        (index) => ListTile(
          title: Text('$searchTerm search result'),
          subtitle: Text(index.toString()),
        ),
      ),
    );
  }
}
