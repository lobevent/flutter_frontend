import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:http/http.dart';

class TodoRemoteService extends RemoteService<TodoDto> {
  static const String orgalistByEventId = "/orgalist/event/";

  // TODO combine it to event path?
  static const String postPath = "/orgalist/event/";
  static const String deletePath = "/orgalist/";
  static const String updatePath = "/orgalist/";

  final SymfonyCommunicator client;

  TodoRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
            SymfonyCommunicator(); // TODO this doesn't work on runtime -> will throw an error!

  Future<TodoDto> getSingle(String eventId) async {
    final String uri = "$orgalistByEventId$eventId";
    final Response response = await client.get(uri);
    final TodoDto todoDto = await _decodeTodo(
        response); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    return todoDto;
  }

  Future<TodoDto> createOrg(String eventId, TodoDto todo) async {
    return _decodeTodo(
        await client.post("$postPath$eventId", jsonEncode(todo.toJson())));
  }

  Future<TodoDto> createTodo(String eventId, TodoDto todo) async {
    return _decodeTodo(
        await client.post("$postPath$eventId", jsonEncode(todo.toJson())));
  }

  Future<TodoDto> deleteTodo(String todoId) async {
    return _decodeTodo(await client.delete("$deletePath${todoId}"));
  }

  Future<TodoDto> updateTodo(TodoDto todoDto) async {
    return _decodeTodo(await client.put(
        "$updatePath${todoDto.id}", jsonEncode(todoDto.toJson())));
  }

  TodoDto _decodeTodo(Response json) {
    return TodoDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }
}
