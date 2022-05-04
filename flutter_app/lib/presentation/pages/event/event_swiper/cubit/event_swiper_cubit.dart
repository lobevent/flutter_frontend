import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:get_it/get_it.dart';

part 'event_swiper_cubit.freezed.dart';
part 'event_swiper_state.dart';

class EventSwiperCubit extends Cubit<EventSwiperState> {
  EventSwiperCubit() : super(EventSwiperState.loading()) {
    getEventsOfInterest();
  }

  EventRepository repository = GetIt.I<EventRepository>();

  Future<void> getEventsOfInterest() async {
    final Either<NetWorkFailure, List<Event>> eventsList;

    eventsList = await repository.getEventsOfInterest(DateTime.now(), 10);

    eventsList.fold((l) => emit(EventSwiperState.error(error: l.toString())),
        (r) => emit(EventSwiperState.loaded(eventsList: r)));
  }
}
