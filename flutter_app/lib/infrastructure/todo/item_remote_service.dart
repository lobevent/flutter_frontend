import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/todo/item_dtos.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';

import 'item_dtos.dart';

class ItemRemoteService extends RemoteService<ItemDto> {
  static const String postPath = "/orgalist/item";
  static const String postItemPath = "/orgalist/item/post/";
  static const String assignProfPath = "orgalist/item/add/";
  static const String deletePath = "/orgalist/item/%itemId%";
  static const String updatePath = "/orgalist/item/%itemId%";

  final SymfonyCommunicator client;

  ItemRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ?? SymfonyCommunicator();

  Future<ItemDto> addItem(ItemDto item, String todoId) async {
    return _decodeItem(
        await client.post("$postItemPath$todoId", jsonEncode(item.toJson())));
  }

  Future<ItemDto> assignProfile(String itemId, String? profileId) async {
    return _decodeItem(
        await client.post("$postPath$itemId" + (profileId ?? ''), ''));
  }

  Future<bool> deleteItem(String itemId) async {
    final Response response =
        await client.delete(deletePath.interpolate({"itemId": itemId}));
    return response.body.isNotEmpty;
  }

  Future<ItemDto> updateItem(ItemDto itemDto) async {
    return _decodeItem(await client.put(
        updatePath.interpolate({"itemId": itemDto.id.toString()}),
        jsonEncode(itemDto.toJson())));
  }

  ItemDto _decodeItem(Response json) {
    return ItemDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }
}
