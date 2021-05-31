import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/item_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';

import 'item_dtos.dart';


class ItemRemoteService extends RemoteService<ItemDto> {

  static const String postPath = "/orgalist/addItem/";
  static const String assignProfPath = "orgalist/item/add/";
  static const String deletePath = "/event/";
  static const String updatePath = "/event/edit/";
  static const String assignPath = "/event/";

  final SymfonyCommunicator client;


  ItemRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();



  Future<ItemDto> addItem(ItemDto item, String todoId) async {
    return _decodeItem(
        await client.post("$postPath$todoId", jsonEncode(item.toJson())));
  }

  Future<ItemDto> assignProfile(String itemId, String? profileId) async {
    return _decodeItem(
        await client.post("$postPath$itemId" + (profileId ?? ''), ''));
  }


  Future<ItemDto> deleteItem(String itemId) async {
    return _decodeItem(await client.delete(
        "$deletePath${itemId}"));
  }


  Future<ItemDto> updateItem(String itemId) async {
    return _decodeItem(await client.put(
        "$updatePath${itemDto.id}",
        jsonEncode(itemDto.toJson())));
  }

  ItemDto _decodeItem(Response json) {
    return ItemDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }


}