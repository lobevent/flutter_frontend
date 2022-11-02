import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:meta/meta.dart';

part 'main_profile_search_state.dart';
part "main_profile_search_cubit.g.dart";

class MainProfileSearchCubit extends Cubit<MainProfileSearchState> {
  List<String> _searchHistory = [];


  MainProfileSearchCubit() : super(MainProfileSearchState(status: PSStatus.initial, filteredSearchHistory: CommonHive.getSearchHistory() ?? [])){
    _searchHistory = CommonHive.getSearchHistory() ?? [];
  }

  static const historyLength = 5;
  //get history from commonhive



  /// submits the serch term and changes visualization. In the deeper cubits a search should be provided
  /// gets the [searchTerm] and sets it in the state
  submitSearchTerm(String searchTerm){
    emit(state.copyWith(searchString: searchTerm, status: PSStatus.searchSubmitted, searchbarOpen: false));
    _addSearchTerm(searchTerm);
    CommonHive.saveSearchHistory(_searchHistory);
  }

  /// if we are in the resultsview, the backbutton should go back to the discovery page
  /// but if we are on the discovery page, the backbutton should go to the main app
  Future<bool> backButtonPressed()async{
    if(state.status == PSStatus.searchSubmitted){
      emit(state.copyWith(status: PSStatus.initial, searchbarOpen: false));
      return true;
    } else {
      return false;
    }
  }

  /// called when the searchbar opens
  enterSearch(){
    if(state.searchbarOpen == false) {
      emit(state.copyWith(searchbarOpen: true));
    }
  }

  /// called when the searchbar closes
  leaveSearch(){
    if(state.searchbarOpen == true) {
      emit(state.copyWith(searchbarOpen: false));
    }
  }

  /// called when searchterm closes
  changeSearchTerm(String? searchTerm){
    emit(state.copyWith(filteredSearchHistory: _filterSearchTerms(searchTerm)));
  }

  ///add search term to history in [CommonHive]
  ///if the searchterm is already there, its deleted and added at the start
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
