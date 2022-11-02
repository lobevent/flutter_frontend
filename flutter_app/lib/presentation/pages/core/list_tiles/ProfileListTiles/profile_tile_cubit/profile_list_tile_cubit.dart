import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'profile_list_tile_state.dart';
part  'profile_list_tile_cubit.g.dart';

class ProfileListTileCubit extends Cubit<ProfileListTileState> {
  ProfileRepository repository = GetIt.I<ProfileRepository>();
  ProfileListTileCubit(Profile profile) : super(ProfileListTileState(status: PLTStatus.idle, profile: profile));

  /// deletes friendship with the profile with the [id]
  /// in the backend, and updates the local profile on success
  /// emits [PLTStatus.deleting] as status in the [state] while deleting
  Future<void> deleteFriendship(Profile profile) async{
    emit(state.copyWith(status: PLTStatus.deleting));

    repository.deleteFriend(profile.id).then((value) => value.fold(
            (l) => emitErrorState(l),
            (r) {
              if(r){
                emit(state.copyWith(
                    status: PLTStatus.idle,
                    profile: state.profile.copyWith(isFriend: false, friendShipStatus: FriendShipStatus.noFriendStatus)));
              }
              else{
                emit(state.copyWith(status: PLTStatus.idle));
              }}));
  }

  /// sends friendship in the backend to the profile with the [id],
  /// and updates the local profile on success
  /// emits [PLTStatus.updating] as status in the [state] while deleting
  Future<void> sendFriendship(UniqueId id) async {
    emit(state.copyWith(status: PLTStatus.updating));
    repository.sendFriendRequest(id).then((value) => value.fold(
            (l) => emitErrorState(l),
            (r) => emit(state.copyWith(
                status: PLTStatus.idle,
                profile: state.profile.copyWith(isFriend: false, friendShipStatus: FriendShipStatus.iSend)))));
  }

  /// accepts friendship with the profile with the [id]
  /// in the backend, and updates the local profile on success
  /// emits [PLTStatus.updating] as status in the [state] while deleting
  Future<void> acceptFriendShip(UniqueId id) async {
    emit(state.copyWith(status: PLTStatus.updating));
    repository.acceptFriend(id).then((value) => value.fold(
            (l) => emitErrorState(l),
            (r) => emit(state.copyWith(
            status: PLTStatus.idle,
            profile: state.profile.copyWith(isFriend: true, friendShipStatus: FriendShipStatus.accepted)))));
  }

  /// deletes friendshiprequest with the profile with the [id]
  /// in the backend, and updates the local profile on success
  /// emits [PLTStatus.deleting] as status in the [state] while deleting
  Future<void> removeFriendRequest(UniqueId id) async {
    emit(state.copyWith(status: PLTStatus.deleting));
    repository.deleteFriend(id).then((value) => value.fold(
            (l) => emitErrorState(l),
            (r) => emit(state.copyWith(
            status: PLTStatus.idle,
            profile: state.profile.copyWith(isFriend: false, friendShipStatus: FriendShipStatus.noFriendStatus)))));
  }

  Future<bool> isFriend(UniqueId id) async {
    return true;
  }


  void emitErrorState(NetWorkFailure failure){
    emit(state.copyWith(failure: failure, status: PLTStatus.error));
  }
}
