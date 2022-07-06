part of 'geo_functions_cubit.dart';

@freezed
class GeoFunctionsState with _$GeoFunctionsState {
  factory GeoFunctionsState.initial() = _Initial;
  factory GeoFunctionsState.loading() = _Loading;
  factory GeoFunctionsState.loaded(
      {required Position position, required bool nearby}) = _Loaded;
  factory GeoFunctionsState.error({required String error}) = _Error;
}
