import 'dart:convert';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_frontend/infrastructure/core/serialization_factory_map.dart';
import 'package:flutter_frontend/domain/core/errors.dart';

/// Added this to decode and cast json in one single point.
/// When a TypeError is thrown than in most cases the problem is
/// that the decoded json is neither of type [Map<String, dynamic>] or [List<dynamic>]
/// That indicates that you are using the wrong method.
/// Try using [deserializeModelList] or [deserializeModel] instead
T _castDecodedJson<T>(String json) {
  return jsonDecode(json) as T;
}

T _modelFromJsonMap<T>(Map<String, dynamic> jsonMap) {
  if (factoryMap.containsKey(T)) {
    return factoryMap[T](jsonMap) as T;
  } else {
    throw DtoTypeNotFoundInSerializationFactoryMap();
  }
}

T _modelFromJsonString<T>(String json) {
  final Map<String, dynamic> jsonMap = _castDecodedJson<Map<String, dynamic>>(json);
  return _modelFromJsonMap<T>(jsonMap);
}

List<T> _modelListFromJsonString<T>(String json) {
  final List<dynamic> tmpJsonList = _castDecodedJson<List<dynamic>>(json);
  final List<Map<String, dynamic>> jsonListMap = tmpJsonList.cast<Map<String, dynamic>>();

  final List<T> modelList = [];
  for(final Map<String, dynamic> jsonMap in jsonListMap) {
    modelList.add(_modelFromJsonMap<T>(jsonMap));
  }
  return modelList;
}

/// This wrapper class is needed to bring the type definition 
/// over into another isolate. Further information see this 
/// git error: https://github.com/flutter/flutter/issues/65213#issuecomment-687766040
class DeserializeWrapper<T> {
  final String json;
  DeserializeWrapper(this.json);

  T deserializeModel() {
    return _modelFromJsonString<T>(json);
  }

  List<T> deserializeModelList() {
    return _modelListFromJsonString<T>(json);
  }

  static dynamic _deserializeModel(DeserializeWrapper wrapper) => wrapper.deserializeModel();

  static dynamic _deserializeModelList(DeserializeWrapper wrapper) => wrapper.deserializeModelList();
}

Future<T> deserializeModel<T>(String json) async {
  // await the dynamic result and then cast in the requested type and return it
  final dynamic result = await compute(DeserializeWrapper._deserializeModel, DeserializeWrapper<T>(json)); 
  return result as T;
} 

Future<List<T>> deserializeModelList<T>(String json) async {
  // await the dynamic result and then cast in the requested type and return it
  final dynamic result = await compute(DeserializeWrapper._deserializeModelList, DeserializeWrapper<T>(json)); 
  return result as List<T>;
} 