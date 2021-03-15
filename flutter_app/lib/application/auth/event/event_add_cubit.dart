import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_add_state.dart.dart';
part 'event_add_cubit.freezed.dart';

class EventAddCubit extends Cubit<EventAddState> {
  EventAddCubit({this.repository}) : super(InitialState()) {
    _getTrendingMovies();
  }

  final MovieRepository repository;

  void _getTrendingMovies() async {
    try {
      emit(LoadingState());
      final movies = await repository.getMovies();
      emit(LoadedState(movies));
    } catch (e) {
      emit(ErrorState());
    }
  }
}