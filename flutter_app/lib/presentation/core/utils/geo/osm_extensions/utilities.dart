import 'package:dio/dio.dart';
import 'package:flutter_frontend/presentation/core/utils/geo/search_completion.dart';

Future<List<SearchInfoDetailed>> addressSuggestionDetailed(String searchText,
    {int limitInformation = 5}) async {
  Response response = await Dio().get(
    "https://photon.komoot.io/api/",
    queryParameters: {
      "q": searchText,
      "limit": limitInformation == 0 ? "" : "$limitInformation"
    },
  );
  final json = response.data;

  return (json["features"] as List)
      .map((d) => SearchInfoDetailed.fromPhotonAPI(d as Map))
      .toList();
}