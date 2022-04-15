import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';

import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_screen_cubit.freezed.dart';
part 'event_screen_state.dart';

class EventScreenCubit extends Cubit<EventScreenState> {


  EventScreenCubit(UniqueId id) : super(EventScreenState.loading()) {
    emit(EventScreenState.loading());
    getEvent(id);
  }


  EventRepository repository = GetIt.I<EventRepository>();

  /// this one is created for the todoOverlay extension
  TodoRepository todoRepository = GetIt.I<TodoRepository>();

  /// is created for the invited Persons Cubit extension
  InvitationRepository invitationRepository = GetIt.I<InvitationRepository>();


  Future<void> getEvent(UniqueId id) async {
    repository.getSingle(id).then((eventOrFailure) => eventOrFailure.fold(
        (failure) => emit(EventScreenState.error(failure: failure)),
        (event) => emit(EventScreenState.loaded(event: event))));
  }



  Future<void> createOrgaEvent(
      Event event, String orgaName, String orgaDesc) async {
    Either<NetWorkFailure, Todo> todoOrFailure;
    //create the new Toddo/Orgalist and assign parameters
    Todo newTodo = Todo(
      id: UniqueId(),
      name: TodoName(orgaName),
      description: TodoDescription(orgaDesc),
      items: [],
    );
    //pass the toddo instanly so we dont have to reload the whole shit event
    todoRepository.createOrga(event, newTodo).then((todoOrFailure) =>
        todoOrFailure.fold(
            (failure) => emit(EventScreenState.error(failure: failure)),
            (todo) => emit(EventScreenState.loaded(event: event.copyWith(todo: todo)))));
  }


  Future<void> changeStatus(EventStatus status) async{

    state.maybeMap(orElse: (){}, loaded: (loadedState) async{
      emit(loadedState.copyWith(loadingStatus: true));
      await repository.changeStatus(loadedState.event, status).then((value){

        value.fold((failute) => emit(EventScreenState.error(failure: failute)), (event) {
          //------------------ the attending stuff is just for refreshing the participants count ------------------
          // here we initialize the attending part from before
         int attending = loadedState.event.attendingCount??0;
         // checking if the status has changed to attending. If so, increment attending
         if(status == EventStatus.attending && loadedState.event.status != status){
            attending++;
         }
         // check if the status was change to anything but attending (but was attending before), if so decrement attending
         if (status != EventStatus.attending && /* previous status -> */loadedState.event.status == EventStatus.attending){
           attending--;
         }

         //------------ here lives all the other stuff for updating the view----------------

          var event = loadedState.event.copyWith(status: status, attendingCount: attending);

          emit(EventScreenState.loading());

          emit(EventScreenState.loaded(event: event));



        });

      });
    });
  }


  ///
  /// this alters the local invitation list and adds an invitation
  ///
  void addedInvitation(Invitation invitation){
    state.maybeMap(orElse: (){}, loaded: (loaded){
      emit(EventScreenState.loading());
      loaded.event.invitations.add(invitation);
      emit(loaded);
    });
  }


  ///
  /// this alters the local invitation list and removes an invitation
  ///
  void revokedInvitation(Invitation invitation){
    state.maybeMap(orElse: (){}, loaded: (loaded){
      loaded.event.invitations.removeWhere((inv) => inv.id.value == invitation.id.value);
      emit(EventScreenState.loading());
      emit(loaded);
    });
  }


}
