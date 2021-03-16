import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/application/auth/event/event_add_state.dart';



part 'own_events_state.dart';
part 'own_events_cubit.freezed.dart';

class OwnEventsCubit extends Cubit<OwnEventsState> {
  OwnEventsCubit({this.repository}) : super(OwnEventsState.initial()) {
    _getOwnEvents();
  }

  final OwnEventsRepository repository;

  Future<void> _getOwnEvents() async {
    try {
      emit(OwnEventsState.loading());
      final movies = await repository.getOwnEvents();
      //emit(OwnEventsState.loaded());
    } catch (e) {
      //emit(OwnEventsState.error());
    }
  }
}