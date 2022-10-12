import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event_profile_picture.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/epp_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../../../../../../domain/event/event.dart';

part 'es_ec_epp_smal_carousel_state.dart';

part 'es_ec_epp_smal_carousel_cubit.freezed.dart';


class EsEcEppSmalCarouselCubit extends Cubit<EsEcEppSmalCarouselState> {
  final Event event;
  final EventProfilePictureRepository repository = GetIt.I<EventProfilePictureRepository>();

  EsEcEppSmalCarouselCubit(this.event) : super(EsEcEppSmalCarouselState.loadingPictures()){
    getEPPFromEvent();
  }


  Future<void> getEPPFromEvent() async {
    Either<NetWorkFailure, List<EventProfilePicture>> eppsEither = await repository.getEPPsFromEvent(event);
    eppsEither.fold(
            (failure) => emit(EsEcEppSmalCarouselState.error(failure: failure)),
            (epps) => emit(EsEcEppSmalCarouselState.picsLoaded(picPaths: epps))
    );


  }
}
