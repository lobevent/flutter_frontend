part of 'main_profile_search_cubit.dart';

enum PSStatus {initial, readyLoadingSuggestions, enteredSearch, searchSubmitted, enteredSearchOnResults}
@CopyWith()
class MainProfileSearchState{
  final String? searchString;
  final PSStatus status;
  final List<String> filteredSearchHistory;

  const MainProfileSearchState({this.searchString, required this.status, this.filteredSearchHistory = const []});
}

