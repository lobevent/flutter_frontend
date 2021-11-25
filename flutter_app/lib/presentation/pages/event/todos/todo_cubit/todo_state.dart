part of 'todo_cubit.dart';

@freezed
class TodoState with _$TodoState {
  factory TodoState.initial() = _TodoInitial;
  factory TodoState.loaded({required Todo todo}) = _TodoLoaded;
  factory TodoState.error({required NetWorkFailure failure}) = _TodoError;
}
