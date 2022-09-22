part of 'profile_score_cubit.dart';

@freezed
class ProfileScoreState with _$ProfileScoreState {
  factory ProfileScoreState.loading() = ScoreLoadInProgress;
  factory ProfileScoreState.loaded(
      {required String score
}) = _ScoreLoaded;
  factory ProfileScoreState.error({required String error}) = _ScoreError;
}
