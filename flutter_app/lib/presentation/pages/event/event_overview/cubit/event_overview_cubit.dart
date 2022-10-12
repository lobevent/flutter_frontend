import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_overview_state.dart';

class EventOverviewCubit extends Cubit<EventOverviewState> {
  EventRepository repository = GetIt.I<EventRepository>();
  InvitationRepository invRepo = GetIt.I<InvitationRepository>();

  EventOverviewCubit() : super(EventOverviewState.loading());

  Future<void> loadEvents() async{

  }


}
