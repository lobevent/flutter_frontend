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
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../../../../data/common_hive.dart';
import '../../../../../../domain/post/post.dart';
import '../../../../../../infrastructure/post/post_repository.dart';

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

  /// this one is created for the 1 last posts that gets fetched
  PostRepository postRepository = GetIt.I<PostRepository>();

  Future<void> getEvent(UniqueId id) async {
    repository.getSingle(id).then((eventOrFailure) => eventOrFailure
            .fold((failure) => emit(EventScreenState.error(failure: failure)),
                (event) {
          postRepository
              .getPostsFromEvent(
                  lastPostTime: DateTime.now(), amount: 2, event: event)
              .then((postOrFailure) => postOrFailure.fold(
                  (failure) => emit(EventScreenState.error(failure: failure)),
                  (post) => emit(EventScreenState.loaded(
                      event: event,
                      last2Posts: post.isNotEmpty ? post : null))));
        }));
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
            (todo) => emit(
                EventScreenState.loaded(event: event.copyWith(todo: todo)))));
  }

  Future<void> changeStatus(EventStatus status) async {
    state.maybeMap(
        orElse: () {},
        loaded: (loadedState) async {
          emit(loadedState.copyWith(loadingStatus: true));
          await repository
              .changeStatus(loadedState.event, status)
              .then((value) {
            value.fold(
                (failute) => emit(EventScreenState.error(failure: failute)),
                (event) {
              //------------------ the attending stuff is just for refreshing the participants count ------------------
              // here we initialize the attending part from before
              int attending = loadedState.event.attendingCount ?? 0;
              // checking if the status has changed to attending. If so, increment attending
              if (status == EventStatus.attending &&
                  loadedState.event.status != status) {
                attending++;
              }
              // check if the status was change to anything but attending (but was attending before), if so decrement attending
              if (status !=
                  EventStatus.attending && /* previous status -> */ loadedState
                      .event.status ==
                  EventStatus.attending) {
                attending--;
              }

              //------------ here lives all the other stuff for updating the view----------------

              var event = loadedState.event
                  .copyWith(status: status, attendingCount: attending);
              var newState = loadedState.copyWith(event: event);

              emit(EventScreenState.loading());

              emit(newState);
            });
          });
        });
  }

  ///confirm user at event with confirmAttending
  Future<void> UserConfirmAtEvent(
      Event event, double? longitude, double? latitude) async {
    state.maybeMap(
        orElse: () {},
        loaded: (loadedState) async {
          await repository
              .confirmUserAtEvent(event.id, longitude!, latitude!)
              .then((value) {
            emit(EventScreenState.loading());

            saveConfirmAttendingScore(event);
            var eventUpdated = loadedState.event
                .copyWith(status: EventStatus.confirmAttending);
            var newState = loadedState.copyWith(event: eventUpdated);

            emit(newState);
          });
        });
  }

  ///
  /// this alters the local invitation list and adds an invitation
  ///
  void addedInvitation(Invitation invitation) {
    state.maybeMap(
        orElse: () {},
        loaded: (loaded) {
          emit(EventScreenState.loading());
          loaded.event.invitations.add(invitation);
          emit(loaded);
        });
  }

  ///
  /// this alters the local invitation list and removes an invitation
  ///
  void revokedInvitation(Invitation invitation) {
    state.maybeMap(
        orElse: () {},
        loaded: (loaded) {
          loaded.event.invitations
              .removeWhere((inv) => inv.id.value == invitation.id.value);
          emit(EventScreenState.loading());
          emit(loaded);
        });
  }

  ///
  /// this alters the local invitation list and add host
  ///
  void addHost(Invitation invitation) {
    toggleHost(invitation, true);
  }

  ///
  /// this alters the local invitation list and add host
  ///
  void removeHost(Invitation invitation) {
    toggleHost(invitation, false);
  }

  void toggleHost(Invitation invitation, bool hostStatus) {
    state.maybeMap(
        orElse: () {},
        loaded: (loaded) {
          Invitation invitationInList = loaded.event.invitations
              .firstWhere((inv) => inv.id.value == invitation.id.value);
          invitationInList.addHost = hostStatus;
          emit(EventScreenState.loading());
          emit(loaded);
        });
  }


  Future<bool> uploadImage(XFile image){
    return state.maybeMap(orElse: (){return Future(() => false);}, loaded: (loaded){
      return repository.uploadImageToEvent(loaded.event.id, image).then(
              (value) => value.fold((failure) => false, (r) => true)
      );
    });
  }
}
