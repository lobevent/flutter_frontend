import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/domain/my_location/my_location_value_objects.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'my_locations_form_state.dart';
part 'my_locations_form_cubit.g.dart';

// part 'my_locations_form_cubit.freezed.dart';

class MyLocationsFormCubit extends Cubit<MyLocationsFormState> {

  MyLocationRepository myLocationRepository = GetIt.I<MyLocationRepository>();
  MyLocationsFormCubit() : super(MyLocationsFormState.initial());




  Future<void> changeName(String name) async{
      MyLocation location = state.location.copyWith(name: MyLocationName(name));
      emit(state.copyWith(location: location));

  }
  
  Future<void> changeLatitude(double latitude) async{
      MyLocation location = state.location.copyWith(latitude: latitude);
      emit(state.copyWith(location: location));
  }
  
  Future<void> changeLongitude(double longitude ) async{
      MyLocation location = state.location.copyWith(longitude: longitude);
      emit(state.copyWith(location: location));
  }
  
  Future<void> changeAddress(String adress) async{
      MyLocation location = state.location.copyWith(address: MyLocationAddress(adress));
      emit(state.copyWith(location: location));
  }
  
  Future<void> submit() async{
      emit(state.copyWith(status: MLFStatus.saving));
      myLocationRepository.saveLocation(state.location).then((value){
        value.fold(
                (failure) => emit(state.copyWith(failure: failure, status: MLFStatus.error)),
                (location) => emit(state.copyWith(status: MLFStatus.finished))
        );
      });
    
  }


  

}
