part of "post_widget_cubit.dart";

@freezed
class PostWidgetState with _$PostWidgetState{
  factory PostWidgetState.initial()= _Initial;
  factory PostWidgetState.loaded({required Post post, @Default([]) List<XFile?> images})= _Loaded;
  factory PostWidgetState.edited({required Post post}) = _Edited;
  factory PostWidgetState.deleted() = _Deleted;
  factory PostWidgetState.error({required String error})= _Error;
}