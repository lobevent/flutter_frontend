import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_remote_service.dart';

import 'my_location_dtos.dart';

class MyLocationRepository extends Repository<MyLocation>{

  final MyLocationRemoteService remoteService;
  MyLocationRepository({required this.remoteService});


  Future<Future<Either<NetWorkFailure, MyLocation>>> saveLocation(MyLocation location) async{
    return localErrorHandler(() async {
      return right((await remoteService.create(MyLocationDto.fromDomain(location))).toDomain());
    });
  }

  Future<Either<NetWorkFailure, MyLocation>> deleteMyLocation(MyLocation location) async{
    return localErrorHandler(() async {
      return right((await remoteService.delete(location.id?.value??(throw Exception('cannot delete without id')))).toDomain());
    });
  }

  Future<Either<NetWorkFailure, List<MyLocation>>> getLocations() async{
    return getList(() => remoteService.getList());
  }
}