import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'coords_picker_state.dart';
part 'coords_picker_cubit.g.dart';


class CoordsPickerCubit extends Cubit<CoordsPickerState> {
  MyLocationRepository repository = GetIt.I<MyLocationRepository>();
  CoordsPickerCubit() : super(CoordsPickerState.initial()) {
    getLocations();
  }


  Future<void> getLocations() async{
    repository.getLocations().then((value) => value.fold(
            (l) => emit(state.copyWith(failure: l, status: CoordsStatus.error)),
            (r) => emit(CoordsPickerState(status: CoordsStatus.ready, locations: r))));
  }

  Future<void> reloadLocations() async {
    emit(state.copyWith(status: CoordsStatus.reloading));
    getLocations();
  }


  void setLoadingState(){
    emit(state.copyWith(status: CoordsStatus.loading));
  }



}
