part of 'main_profile_search_cubit.dart';

enum PSStatus {initial, readyLoadingSuggestions, searchSubmitted}
@CopyWith()
class MainProfileSearchState{

  /// the searchstring that should be currently in the textfield
  final String? searchString;

  /// takes an value of the enum, and controlls behavior of the screen
  final PSStatus status;

  /// the filtered history contains the search results of the past,
  /// that match [searchString]
  final List<String> filteredSearchHistory;

  /// this flag should be set if the search bar is focused
  final bool searchbarOpen;

  const MainProfileSearchState({this.searchString, required this.status, this.filteredSearchHistory = const [], this.searchbarOpen = false});
}

