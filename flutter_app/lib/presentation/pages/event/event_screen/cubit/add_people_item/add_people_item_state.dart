part of 'add_people_item_cubit.dart';

@freezed
class AddPeopleItemState with _$AddPeopleItemState {
  const factory AddPeopleItemState.loadingPeople() = LoadingPeople;
  const factory AddPeopleItemState.loadedPeople(
      {required List<Profile> people}) = LoadedPeople;
  const factory AddPeopleItemState.error({required NetWorkFailure failure}) =
      LoadFailure;
}
