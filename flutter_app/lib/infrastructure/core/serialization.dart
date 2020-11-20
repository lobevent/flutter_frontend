import 'dart:convert';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_frontend/infrastructure/core/serialization_factory_map.dart';

List<T> _modelListFromJsonString<T>(String json) {
  final List<dynamic> tmpJsonList = jsonDecode(json) as List<dynamic>;
  final List<Map<String, dynamic>> jsonListMap = tmpJsonList.cast<Map<String, dynamic>>();

  final List<T> modelList = [];
  for(final Map<String, dynamic> jsonMap in jsonListMap) {
    modelList.add(
      factoryMap[T](jsonMap) as T
    );
  }
  return modelList;
}

T _modelFromJsonString<T>(String json) {
  // TODO implement 
  throw UnimplementedError();
  return json as T;
}



class DeserializeWrapper<T> {
  final String json;
  DeserializeWrapper(this.json);

  List<T> deserializeModelList() {
    return _modelListFromJsonString<T>(json);
  }

  T deserializeModel() {
    return _modelFromJsonString<T>(json);
  }

  static dynamic _deserializeModelList(DeserializeWrapper wrapper) => wrapper.deserializeModelList();

  static dynamic _deserializeModel(DeserializeWrapper wrapper) => wrapper.deserializeModel();
}

// await the dynamic result and then cast in the requested type and return it
Future<List<T>> deserialize<T>(String json) async {
  dynamic result = await compute(DeserializeWrapper._deserializeModelList, DeserializeWrapper<T>(json)); 
  return result as List<T>;
} 