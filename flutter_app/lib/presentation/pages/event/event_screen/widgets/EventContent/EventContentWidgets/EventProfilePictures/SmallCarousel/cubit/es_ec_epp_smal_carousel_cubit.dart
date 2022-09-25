import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'es_ec_epp_smal_carousel_state.dart';

part 'es_ec_epp_smal_carousel_cubit.freezed.dart';


class EsEcEppSmalCarouselCubit extends Cubit<EsEcEppSmalCarouselState> {
  EsEcEppSmalCarouselCubit() : super(EsEcEppSmalCarouselState.loadingPictures());
}
