import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';

// I don't use compute (another isolate for toJson) because I think
// creating another isolate is more overhead than just converting an
// object to json which mostly only generates a few lines of json output.
// If we see any problems with UI we should start using compute even for toJson!

/// Just adding this function that we have one single point for jsonEncoding.
/// When we later add features to the encoding it will automatically will be
/// applied to encoding of lists and single models
String _customJsonEncode(Map<String, dynamic> jsonMap) {
  return jsonEncode(jsonMap);
}

String serializeModel(BaseDto model) {
  final Map<String, dynamic> jsonMap = model.toJson();
  final String jsonString = _customJsonEncode(jsonMap);
  return jsonString;
}

/// Converts each model to its string representation using [serializeModel]
/// and than returns the model list joined with a ',' in [ ]
/// e.g. [{user:'test'},{user:'test1'}]
String serializedModelList(List<BaseDto> models) {
  final List<String> jsonMapList =
      models.map((model) => serializeModel(model)).toList();
  return "[${jsonMapList.join(',')}]";
}
