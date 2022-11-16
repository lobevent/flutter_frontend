import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'my_locations_state.dart';
part 'my_locations_cubit.g.dart';


class MyLocationsCubit extends Cubit<MyLocationsState> {
  
  MyLocationRepository myLocationRepository = GetIt.I<MyLocationRepository>();
  MyLocationsCubit() : super(MyLocationsState.initial()){loadMyLocations();}
  
  Future<void> loadMyLocations() async{
    emit(MyLocationsState.loading());
    myLocationRepository.getLocations().then((value) => value.fold((failure) => emit(state.copyWith(status: MyLocationStatus.error, failure: failure)),
            (myLocations) => emit(MyLocationsState.loaded(myLocations: myLocations))));
  }

  Future<bool> deleteMyLocation(MyLocation location) async{
    return myLocationRepository.deleteMyLocation(location).then((value) => value.fold((failure) {emit(state.copyWith(status: MyLocationStatus.error, failure: failure)); return false;},
            (myLocations) {
              List<MyLocation> myLocs = state.myLocations;
              myLocs.removeWhere((element) => element.id?.value.toString() == location.id?.value.toString());
              emit(state.copyWith(myLocations: myLocs));
              return true;
            }));
  }
  
}
