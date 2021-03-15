import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/application/auth/event/event_add_state.dart';



part 'event_add_state.dart.dart';
part 'event_add_cubit.freezed.dart';

class EventAddCubit extends Cubit<EventAddState> {
  EventAddCubit({this.repository}) : super(EventAddState.loading()) {
    _getTrendingMovies();
  }

  final MovieRepository repository;

  Future<void> _getTrendingMovies() async {
    try {
      emit(EventAddState.loading());
      final movies = await repository.getMovies();
      emit(EventAddState.loaded());
    } catch (e) {
      emit(EventAddState.error());
    }
  }
}