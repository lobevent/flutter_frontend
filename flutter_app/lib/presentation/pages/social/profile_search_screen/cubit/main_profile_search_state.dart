part of 'main_profile_search_cubit.dart';

enum PSStatus {initial, readyLoadingSuggestions, searchSubmitted}
@CopyWith()
class MainProfileSearchState{
  final String? searchString;
  final PSStatus status;
  final List<String> filteredSearchHistory;
  final bool searchbarOpen;

  const MainProfileSearchState({this.searchString, required this.status, this.filteredSearchHistory = const [], this.searchbarOpen = false});
}

