part of 'like_cubit.dart';

@freezed
class LikeState with _$LikeState {
  const factory LikeState({required List<Profile> likeProfiles}) = _LikeState;

  factory LikeState.initial() = _Initial;

  factory LikeState.loading() = _LoadInProgress;

  factory LikeState.loaded(
      {required List<Profile> likeProfiles,
      required bool likeStatus}) = _Loaded;

  factory LikeState.error() = _LoadFailure;
}
