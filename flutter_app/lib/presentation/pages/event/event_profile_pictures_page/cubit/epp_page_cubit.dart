import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event_profile_picture.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/epp_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../domain/event/event.dart';

part 'epp_page_state.dart';
part 'epp_page_cubit.freezed.dart';


class EppPageCubit extends Cubit<EppPageState> {
  final Event event;
  EventProfilePictureRepository repository = GetIt.I<EventProfilePictureRepository>();

  EppPageCubit(this.event) : super(EppPageState.loading()){loadEpps();}

  Future<void> loadEpps() async{
    repository.getEPPsFromEvent(event).then((value) => value.fold(
            (l) => emit(EppPageState.error(l)),
            (r) => emit(EppPageState.loaded(r))
    )
    );
  }




}
