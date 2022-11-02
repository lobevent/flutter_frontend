import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:meta/meta.dart';

part 'main_profile_search_state.dart';
part "main_profile_search_cubit.g.dart";

class MainProfileSearchCubit extends Cubit<MainProfileSearchState> {
  List<String> _searchHistory = [];


  MainProfileSearchCubit() : super(MainProfileSearchState(status: PSStatus.initial)){
    _searchHistory = CommonHive.getSearchHistory() ?? [];
    emit(state.copyWith(filteredSearchHistory: _searchHistory));
  }

  static const historyLength = 5;
  //get history from commonhive



  submitSearchTerm(String searchTerm){
    _addSearchTerm(searchTerm);
    CommonHive.saveSearchHistory(_searchHistory);
  }

  changeSearchTerm(String? searchTerm){
    emit(state.copyWith(filteredSearchHistory: _filterSearchTerms(searchTerm)));
  }

  //add search term to history
  void _addSearchTerm(String term) {
    if (term.isEmpty) {
      return;
    }
    if (_searchHistory.contains(term)) {
      _searchHistory.remove(term);
      _searchHistory.insert(0, term);
      return;
    }
    _searchHistory.insert(0, term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(historyLength, _searchHistory.length);
    }
    //filteredSearchHistory = _filterSearchTerms(null);
  }

  ///filter search history and build similar history entries from before
  List<String> _filterSearchTerms(String? query) {
    if (query != null && query.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(query))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

}
