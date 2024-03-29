import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/deserialization_factory_map.dart';
import 'package:http/http.dart';

import 'exceptions.dart';

class RemoteService<DTO extends BaseDto> {


  Future<List<DTO>> convertList(Response response) async {
    return _convertList<DTO>(response);
  }

  Future<List<T>> covertListForeign<T extends BaseDto>(Response response){
    return _convertList<T>(response);
  }

  Future<List<T>> _convertList<T extends BaseDto>(Response response) async { // dit versteht kein mensch was hier passiert
    List<T> dtoList;
    try {
      dtoList = ((jsonDecode(response.body) as List) 
              .map((e) => e as Map<String, dynamic>))
          .toList()
          .map((e) => factoryMap[T](e)
              as T) //factorymap is from the corefile deserialization_factory_map (single point of uglyness)
          .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    } on Exception {
      throw UnexpectedFormatException();
    }
    return dtoList;
  }
}
