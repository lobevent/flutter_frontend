import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/domain/my_location/my_location_value_objects.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'my_locations_form_state.dart';
// part 'my_locations_form_cubit.freezed.dart';

class MyLocationsFormCubit extends Cubit<MyLocationsFormState> {

  MyLocationRepository myLocationRepository = GetIt.I<MyLocationRepository>();
  MyLocationsFormCubit() : super(MyLocationsFormInitial()){generateNewLocation();}


  generateNewLocation(){
    emit(MyLocationFormAdding(MyLocation(latitude: 0.0, longitude: 0.0, address: MyLocationAddress(""), name: MyLocationName(""))));
  }


  Future<void> changeName(String name) async{
    if(state is MyLocationFormAdding){
      MyLocation location = (state as MyLocationFormAdding).location.copyWith(name: MyLocationName(name));
      emit(MyLocationFormAdding(location));
    }

  }
  
  Future<void> changeLatitude(double latitude) async{
    if(state is MyLocationFormAdding){
      MyLocation location = (state as MyLocationFormAdding).location.copyWith(latitude: latitude);
      emit(MyLocationFormAdding(location));
    }
  }
  
  Future<void> changeLongitude(double longitude ) async{
    if(state is MyLocationFormAdding){
      MyLocation location = (state as MyLocationFormAdding).location.copyWith(longitude: longitude);
      emit(MyLocationFormAdding(location));
    }
    
  }
  
  Future<void> changeAddress(String adress) async{
    if(state is MyLocationFormAdding){
      MyLocation location = (state as MyLocationFormAdding).location.copyWith(address: MyLocationAddress(adress));
      emit(MyLocationFormAdding(location));
    }
    
  }
  
  Future<void> submit() async{
    if(state is MyLocationFormAdding){
      myLocationRepository.saveLocation((state as MyLocationFormAdding).location).then((value){
        value.fold(
                (failure) => emit(MyLocationFormError(failure)),
                (location) => emit(MyLocationFormSuccsessfullySubmitted())
        );
      });
    }
    
  }


  

}
