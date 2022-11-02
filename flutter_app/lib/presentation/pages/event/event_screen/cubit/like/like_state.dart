part of 'like_cubit.dart';

@freezed
class LikeState with _$LikeState {
  factory LikeState.initial() = _Initial;

  factory LikeState.loading() = _LoadInProgress;

  factory LikeState.loaded(
      {required List<Profile> likeProfiles,
      required bool likeStatus}) = _Loaded;

  factory LikeState.error({required NetWorkFailure failure}) = _LoadFailure;
}
