part of 'post_screen_cubit.dart';

@freezed
class PostScreenState with _$PostScreenState {
  factory PostScreenState.initial() = _Initial;
  factory PostScreenState.loading() = Loading;
  factory PostScreenState.loaded({required List<Post> posts, Event? event, @Default([]) List<XFile?> images}) =
      _Loaded;
  factory PostScreenState.error({required String error}) = _ErrorComment;
}
