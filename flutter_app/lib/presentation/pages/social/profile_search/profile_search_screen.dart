import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search/cubit/profile_search_cubit.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search/profile_search_results_tabs.dart';

import '../../../../infrastructure/core/local/common_hive/common_hive.dart';

class ProfileSearchScreen extends StatelessWidget {
  const ProfileSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BottomNavigation(selected: NavigationOptions.profileSearch),
      body: BlocProvider(
        create: (context) => ProfileSearchCubit(),
        child: ProfileSearchContainer(),
      ),
    );
  }
}

class ProfileSearchContainer extends StatefulWidget {
  ProfileSearchContainer({Key? key}) : super(key: key);

  @override
  _ProfileSearchContainerState createState() => _ProfileSearchContainerState();
}

class _ProfileSearchContainerState extends State<ProfileSearchContainer> {
  //search is tapped to make state change on other expanded screen, like in instagram
  TextEditingController searchController = TextEditingController();
  bool searchIsTapped = false;

  //history
  static const historyLength = 5;
  //get history from commonhive
  static final List<String> _searchHistory =
      CommonHive.getSearchHistory() ?? [];
  List<String> filteredSearchHistory = _searchHistory;
  String? selectedTerm;

  @override
  void initState() {
    super.initState();
  }

  //add search term to history
  void addSearchTerm(String term) {
    if (term.isEmpty) {
      return;
    }
    if (_searchHistory.contains(term)) {
      _searchHistory.insert(0, term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    filteredSearchHistory = filterSearchTerms(null);
  }

  ///filter search history and build similar history entries from before
  List<String> filterSearchTerms(String? query) {
    if (query != null && query.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(query))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSearchCubit, ProfileSearchState>(
      builder: (context, state) {
        return state.maybeMap(initial: (init) {
          //initial return our search textfield and maybe some other stuff
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 30, bottom: 8),
                child: decideSearchTextField(),
              ),
              decideExpanded()
            ],
          );
        }, loading: (loading) {
          return LoadingIndicator(isLoading: true);
        }, loadedBoth: (loadedBoth) {
          //load our results
          return ProfileSearchResultsTabs();
        }, error: (err) {
          return ErrorWidget(err);
        }, orElse: () {
          return const Text("orelse error");
        });
      },
    );
  }

  ///decides if user has tapped searchtextfield
  Widget decideSearchTextField() {
    if (!searchIsTapped) {
      return TextField(
        onTap: () {
          setState(() {
            searchIsTapped = true;
          });
        },
        controller: searchController,
        decoration: const InputDecoration(
          labelText: "Search",
          hintText: "Search",
          prefixIcon: Icon(Icons.search_outlined),
        ),
      );
    } else {
      //if user tapped searchtextfield, then build search history and listen for input
      return TextField(
        onTap: () {},
        onChanged: (value) {
          //filter search terms based on input
          filteredSearchHistory = filterSearchTerms(value);
          setState(() {});
        },
        //if submitted add search term to history and commonhive and fetch from backend
        onSubmitted: (value) {
          addSearchTerm(searchController.text);
          CommonHive.saveSearchHistory(_searchHistory);
          setState(() {});
          context.read<ProfileSearchCubit>().searchByBothName(value);
        },
        controller: searchController,
        decoration: InputDecoration(
          labelText: "Search",
          hintText: "Search",
          suffixIcon: Icon(Icons.search_outlined),
          prefixIcon: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => setState(() {
              //we can go back via this button to previous search screen
              searchController.clear();
              searchIsTapped = false;
            }),
          ),
        ),
      );
    }
  }

  ///decides if we need to show searchhistory or inital content
  Widget decideExpanded() {
    //here we can build what we want for inital state
    if (!searchIsTapped) {
      return Expanded(
          child: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${index}'),
                );
              }));
    } else {
      return Expanded(
          child: ListView.builder(
              itemCount: filteredSearchHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${filteredSearchHistory[index]}'),
                  onTap: () {
                    searchController.text = filteredSearchHistory[index];
                    context
                        .read<ProfileSearchCubit>()
                        .searchByBothName(filteredSearchHistory[index]);
                  },
                );
              }));
    }
  }
}
