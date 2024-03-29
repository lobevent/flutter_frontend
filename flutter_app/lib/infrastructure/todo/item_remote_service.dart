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
  static const String assignOwnProfilePath = "/orgalist/item/add/%itemId%";
  static const String assignProfilePath =
      "/orgalist/item/add/%itemId%/%profileId%";
  static const String deassignOwnProfilePath = "/orgalist/item/deadd/%itemId%";
  static const String deassignProfilePath =
      "/orgalist/item/deadd/%itemId%/%profileId%";

  final SymfonyCommunicator client;

  ItemRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ?? SymfonyCommunicator();

  Future<ItemDto> addItem(ItemDto item, String todoId) async {
    return _decodeItem(
        await client.post("$postItemPath$todoId", jsonEncode(item.toJson())));
  }

  Future<ItemDto> assignProfile(String itemId, String? profileId) async {
    if (profileId != null) {
      return _decodeItem(await client.post(
          assignProfilePath
              .interpolate({"itemId": itemId, "profileId": profileId}),
          null));
    } else {
      return _decodeItem(await client.post(
          assignOwnProfilePath.interpolate({"itemId": itemId}), null));
    }
  }

  Future<ItemDto> deassignProfile(String itemId, String? profileId) async {
    if (profileId != null) {
      return _decodeItem(await client.post(
          deassignProfilePath
              .interpolate({"itemId": itemId, "profileId": profileId}),
          null));
    } else {
      return _decodeItem(await client.post(
          deassignOwnProfilePath.interpolate({"itemId": itemId}), null));
    }
  }

  Future<ItemDto> deleteItem(String itemId) async {
    return _decodeItem(
        await client.delete(deletePath.interpolate({"itemId": itemId})));
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
