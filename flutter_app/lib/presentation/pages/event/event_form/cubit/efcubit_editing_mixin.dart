import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:image_picker/image_picker.dart';

mixin EventFormCubitEditing on Cubit<EventFormState> {
  void changePicture(XFile picture) {
    emit(state.copyWith(picture: picture));
  }

  void setEventSeries(EventSeries? series) {
    emit(state.copyWith(event: state.event.copyWith(series: series)));
  }

  void changeTitle(String title) {
    emit(state.copyWith(event: state.event.copyWith(name: EventName(title))));
  }

  void changeBody(String body) {
    emit(state.copyWith(
        event: state.event.copyWith(description: EventDescription(body))));
  }

  void changeMaxPersons(int maxPersons) {
    emit(state.copyWith(event: state.event.copyWith(maxPersons: maxPersons)));
  }

  void changeDate(DateTime date) {
    emit(state.copyWith(event: state.event.copyWith(date: date.toUtc())));
  }

  void changeLatitude(double? latitude) {
    emit(state.copyWith(event: state.event.copyWith(latitude: latitude)));
  }

  void changeLongitude(double? longitude) {
    emit(state.copyWith(event: state.event.copyWith(longitude: longitude)));
  }

  void changeAddress(String? address) {
    emit(state.copyWith(event: state.event.copyWith(address: address)));
  }

  void changePublic(bool public) {
    emit(state.copyWith(event: state.event.copyWith(public: public)));
  }

  void changeVisibleWithoutLogin(bool vwl) {
    emit(state.copyWith(event: state.event.copyWith(visibleWithoutLogin: vwl)));
  }

  void addFriend(Profile profile) {
    if (!state.event.invitations.map((e) => e.profile).contains(profile)) {
      emit(state.copyWith(event: state.event.copyWith(invitations: state.event.invitations.toList()..add(Invitation(
          profile: profile,
          event: state.event,
          id: UniqueId(),
          addHost: false)))));
    }
  }

  void changeMyLocation(MyLocation location){
    emit(state.copyWith(event: state.event.copyWith(myLocation: location)));
  }

  /// invites an friend and makes him host
  void addFriendAsHost(Profile profile) {
    if (!state.event.invitations.map((e) => e.profile).contains(profile)) {
      Invitation foundInvitation = state.event.invitations
          .where((element) => element.profile == profile)
          .first;
      if (foundInvitation != null) {
        foundInvitation.addHost = true;
      } else {
        state.event.invitations.add(Invitation(
            profile: profile,
            event: state.event,
            id: UniqueId(),
            addHost: true));
      }
      emit(state);
    }
  }

  void removeFriendAsHost(Profile profile) {
    if (!state.event.invitations.map((e) => e.profile).contains(profile)) {
      Invitation foundInvitation = state.event.invitations
          .where((element) => element.profile == profile)
          .first;
      if (foundInvitation != null) {
        foundInvitation.addHost = false;
      }
      emit(state);
    }
  }

  void removeFriend(Profile profile) {
    if (state.event.invitations
        .map((e) => e.profile.id.toString())
        .contains(profile.id.toString())) {
      List<Invitation> invs = state.event.invitations.toList()..removeWhere(
              (invitation) => invitation.profile.id.value == profile.id.value);
      emit(state.copyWith(event: state.event.copyWith(invitations: invs)));
    }
  }

}