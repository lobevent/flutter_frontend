part of 'profile_list_tile_cubit.dart';

enum PLTStatus {updating, deleting, idle, error}
@CopyWith()
class ProfileListTileState {
  /// takes an value of the enum [PLTStatus], and controlls behavior of the screen
  final PLTStatus status;

  /// the profile which the tile shows
  final Profile profile;
  /// is not null iff an error occured
  final NetWorkFailure? failure;

  ProfileListTileState({required this.status, required this.profile, this.failure});

}

