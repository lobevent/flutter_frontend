part of 'epp_page_cubit.dart';

@freezed
class EppPageState with _$EppPageState{
  const factory EppPageState.loading() = EppPLoading;
  const factory EppPageState.loaded(List<EventProfilePicture> epps) = EppPLoaded;
  const factory EppPageState.error(NetWorkFailure failure) = EppPError;


}

