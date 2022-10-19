import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/application/core/geo_functions.dart';
import 'package:flutter_frontend/application/core/geo_functions_cubit.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../../../domain/event/event.dart';

part 'eop_single_tab_distances_state.dart';

class EopSingleTabDistancesCubit extends Cubit<EopSingleTabDistancesState> {
  EopSingleTabDistancesCubit()
      : super(EopSingleTabDistancesState(
            events: [], status: Status.loadingEvents)) {
    loadEvents();
  }
  double searchDistanceKm = 5;
  Position? position;

  EventRepository repository = GetIt.I<EventRepository>();

  Future<void> loadEvents() async {
    emit(EopSingleTabDistancesState.loadingEmpty());
    if (this.position == null) {
      await _getLocalPosition();
      emit(state.copyWith(status: Status.loadingEvents));
    }
    (await repository.getNearEvents(
            this.position!.latitude,
            this.position!.longitude,
            searchDistanceKm.ceil(),
            DateTime.now(),
            30,
            descending: false))
        .fold((l) => emit(state.copyWith(failure: l, status: Status.failure)),
            (r) => emit(state.copyWith(status: Status.success, events: r)));
  }

  // ------------------------------------------------------------------------------------------
  // ----------------------------- getters and setters ----------------------------------------
  // ------------------------------------------------------------------------------------------

  double getSearchDistatnce() {
    return searchDistanceKm;
  }

  void setSearchDistanceAndUpdate(double searchDistance) {
    searchDistanceKm = searchDistance;
    loadEvents();
  }

  void setSearchDistance(double searchDistance) {
    searchDistanceKm = searchDistance;
  }

  // ------------------------------------------------------------------------------------------
  // ----------------------------- private methods --------------------------------------------
  // ------------------------------------------------------------------------------------------

  ///
  /// get device position
  ///
  Future<Position?> _getLocalPosition() async {
    emit(state.copyWith(status: Status.gettingGPSPosition));
    position = await GeoFunctions().checkIfNeedToFetchPosition(5);
    return position;
  }
}
