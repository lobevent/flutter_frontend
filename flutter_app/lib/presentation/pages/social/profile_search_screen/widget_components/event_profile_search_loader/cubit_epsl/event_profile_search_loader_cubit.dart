import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_profile_search_loader_state.dart';

part 'event_profile_search_loader_cubit.g.dart';

class EventProfileSearchLoaderCubit<T> extends Cubit<EventProfileSearchLoaderState<T>> {

  ProfileRepository repository = GetIt.I<ProfileRepository>();
  EventRepository eventRepository = GetIt.I<EventRepository>();

  /// is given on initialization
  /// contains the string with which the search method is called
  final String searchString;

  EventProfileSearchLoaderCubit(this.searchString) : super(EventProfileSearchLoaderState(status: EpslStatus.loading)){
    assert(T == Event || T == Profile);
    searchByString(searchString);
  }



  Future<void> searchByString(String searchString) async {
    emit(state.copyWith(status: EpslStatus.loading));
    decideRepoFunction(searchString: searchString).then((value) => value.fold(
            (l) => emit(state.copyWith(failure: l, status: EpslStatus.error)),
            (r) => emit(state.copyWith(status: EpslStatus.loaded, enities: r))
    )
    );
  }

  Future<Either<NetWorkFailure, List<T>>> decideRepoFunction({required String searchString, int amount = 10})async{
    if(T == Profile){
      return repository.getSearchProfiles(searchString: searchString, amount: 10) as Future<Either<NetWorkFailure, List<T>>>;
    } else if(T == Event){
      return eventRepository.searchEvent(DateTime.now(), 10, searchString) as Future<Either<NetWorkFailure, List<T>>>;
    }
    else {
      throw LogicError();
    }
  }
}
