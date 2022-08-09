import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'my_locations_state.dart';

class MyLocationsCubit extends Cubit<MyLocationsState> {
  
  MyLocationRepository myLocationRepository = GetIt.I<MyLocationRepository>();
  MyLocationsCubit() : super(MyLocationsInitial()){loadMyLocations();}
  
  Future<void> loadMyLocations() async{
    emit(MyLocationsLoading());
    myLocationRepository.getLocations().then((value) => value.fold((failure) => emit(MyLocationsError(failure)),
            (myLocations) => emit(MyLocationsLoaded(myLocations))));
  }

  Future<bool> deleteMyLocation(MyLocation location) async{
    return myLocationRepository.deleteMyLocation(location).then((value) => value.fold((failure) {emit(MyLocationsError(failure)); return false;},
            (myLocations) {
              List<MyLocation> myLocs = (state as MyLocationsLoaded).myLocations;
              myLocs.removeWhere((element) => element.id?.value.toString() == location.id?.value.toString());
              emit(MyLocationsLoaded(myLocs));
              return true;
            }));
  }
  
}
