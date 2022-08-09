import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_dtos.dart';
import 'package:http/http.dart';

import '../core/symfony_communicator.dart';

class MyLocationRemotePaths{
  static const saveMyLocation = "/myLocation/create";
  static const removeMyLocation = "/myLocation/delete";
  static const getMyLocationsList = "/myLocation/list";

}




class MyLocationRemoteService extends RemoteService<MyLocationDto>{
  SymfonyCommunicator client;

  MyLocationRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++          HELPERS        +++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  MyLocationDto _decodeMyLocation(Response json){
    return MyLocationDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  //------------------------------------------------------------------------------------------------------------------------
  //++++++++++++++++++++++++++++++++++++++++++++          CRUD        +++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


  Future<MyLocationDto> create(MyLocationDto myLocation) async{
    return _decodeMyLocation(await client.post(MyLocationRemotePaths.saveMyLocation, jsonEncode(myLocation.toJson())));
  }

  Future<List<MyLocationDto>> getList({String? userId}) async{
    if(userId == null){
      return convertList(await client.get(MyLocationRemotePaths.getMyLocationsList));
    }
    throw UnimplementedError();
  }

  Future<MyLocationDto> delete(String locationId) async{
    return _decodeMyLocation(await client.delete(MyLocationRemotePaths.removeMyLocation + "/$locationId"));
  }



}