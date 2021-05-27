import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';


class TodoRemoteSetvice extends RemoteService<TodoDto>{
  static const String orgalistByEventId = "/orgalist/event/";


  // TODO combine it to event path?
  static const String postPath = "/event";
  static const String deletePath = "/event/";
  static const String updatePath = "/event/edit/";

  final SymfonyCommunicator client;

  TodoRemoteSetvice({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator(); // TODO this doesn't work on runtime -> will throw an error!




  Future<TodoDto> getSingle(String eventId) async {
    final String uri = "$orgalistByEventId$eventId";
    final Response response = await client.get(uri);
    final TodoDto todoDto = await _decodeTodo(
        response); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    return todoDto;
  }

  Future<TodoDto> createTodo(String eventId, TodoDto todo) async {
    return _decodeTodo(
        await client.post("$orgalistByEventId$eventId", jsonEncode(todo.toJson())));
  }

  Future<TodoDto> deleteTodo(TodoDto todoDto) async {
    // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive
    return _decodeTodo(await client.delete(
        "$deletePath${todoDto.id}"));
  }



  Future<TodoDto> updateTodo(TodoDto todoDto) async {
    return _decodeTodo(await client.put(
        "$updatePath${todoDto.id}",
        jsonEncode(todoDto.toJson())));
  }

  TodoDto _decodeTodo(Response json) {
    return TodoDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }


}
