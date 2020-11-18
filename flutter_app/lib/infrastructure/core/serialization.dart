import 'dart:convert';

import 'package:flutter/foundation.dart' show compute;

final Map<Type, Function> factoryMap = {
  // CommentDto : CommentDto.fromJson,
};




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

class DeserializeWrapper<T> {
  final String json;
  DeserializeWrapper(this.json);

  List<T> invoke() {
    return _modelListFromJsonString<T>(json);
  }

  static dynamic _invoke(DeserializeWrapper a) => a.invoke();
}

Future<List<T>> deserialize<T>(String json) => compute(DeserializeWrapper._invoke, DeserializeWrapper<T>(json)) as Future<List<T>>;
