import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_basic/cubit__eop_single_tab_basic/eop_single_tab_basic_cubit.dart';
import 'package:meta/meta.dart';

part 'event_overview_event.dart';
part 'event_overview_state.dart';

class EventOverviewBloc extends Bloc<EventOverviewEvent, EventOverviewState> {
  EventOverviewBloc() : super(EventOverviewState(status: MainStatus.upcoming)) {
    on<EventOverviewShowUpcomming>((event, emit) {
      emit(EventOverviewState(status: MainStatus.upcoming));
    });
    on<EventOverviewShowRecent>((event, emit) {
      emit(EventOverviewState(status: MainStatus.recent));
    });
  }
}
