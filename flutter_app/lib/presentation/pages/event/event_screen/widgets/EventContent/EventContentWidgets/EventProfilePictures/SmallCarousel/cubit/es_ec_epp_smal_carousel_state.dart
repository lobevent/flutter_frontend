part of 'es_ec_epp_smal_carousel_cubit.dart';

@freezed
class EsEcEppSmalCarouselState with _$EsEcEppSmalCarouselState {
  const factory EsEcEppSmalCarouselState.loadingPictures() = LoadingPictures;
  const factory EsEcEppSmalCarouselState.picsLoaded({required List<String> picPaths}) = LoadingSuccessfull;
  const factory EsEcEppSmalCarouselState.error({required NetWorkFailure failure}) = LoadingError;

}


