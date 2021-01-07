

import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/todo/item_dtos.dart';
import 'package:http/http.dart';

class ItemRemoteService {
  static const String _itemIdPath = ""; //TODO dont know path

  //List Route
  static const String _attendingItemsTodoPath = "/item/%itemId%/%todoId/%amount%/";

  static const String postPath = "/item";
  static const String deletePath = "/item";
  static const String updatePath = "/item";

  SymfonyCommunicator client;

  ItemRemoteService() {
    client = SymfonyCommunicator(jwt: null); // TODO check on this one
  }

  Future<ItemDto> _decodeTodo(Response json) async {
    return ItemDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<ItemDto> getSingleItem(int id) async {
    final String uri = "$_itemIdPath$id";
    Response response = await client.get(uri);
    ItemDto itemDto =
    ItemDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return itemDto;
  }

  Future<ItemDto> create(ItemDto itemDto) async {
    return _decodeTodo(
        await client.post(postPath, jsonEncode(itemDto.toJson())));
  }

  Future<ItemDto> delete(ItemDto itemDto) async {
    return _decodeTodo(
        await client.delete("$deletePath${itemDto.id}"));

  }

  Future<ItemDto> update(ItemDto itemDto) async {
    return _decodeTodo(
        await client.put(
            "$updatePath${itemDto.id}", jsonEncode(itemDto.toJson())));
  }

  Future<List<ItemDto>> getAttendingItemsTodo(int amount, String itemId, String todoId) async {
    return _getItemList(
        _attendingItemsTodoPath.interpolate(
            {"itemId" : itemId, "todoId" : todoId, "amount" : amount.toString()}));
  }


  Future<List<ItemDto>> _getItemList(String path) async {
    final Response response = await client.get(path);
    final List<ItemDto> item = (jsonDecode(response.body) as List<
        Map<String,
            dynamic>>) // TODO one liners are nice for the flex xD but you already use a variable then I think it is easier to just put it into the next line
        .map((e) => ItemDto.fromJson(e))
        .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>

    final List<Map<String, dynamic>> itemsJsonList = jsonDecode(
        response
            .body) as List<
        Map<String,
            dynamic>>; // TODO same stuff with one variable and bit cleaner still we will have to rewrite it because of the json transformation
    return itemsJsonList
        .map((itemJsonMap) => ItemDto.fromJson(itemJsonMap))
        .toList();
  }
}
