import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:http/http.dart';

class TodoRemoteService {
  static const String _todoIdPath = ""; //TODO dont know path

  static const String postPath = "/todo";
  static const String deletePath = "/todo";
  static const String updatePath = "/todo";

  SymfonyCommunicator client;

  TodoRemoteService() {
    client = SymfonyCommunicator(jwt: null); // TODO check on this one
  }

  Future<TodoDto> _decodeTodo(Response json) async {
    return TodoDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<TodoDto> getSingleTodo(int id) async {
    final String uri = "$_todoIdPath$id";
    Response response = await client.get(uri);
    TodoDto todoDto =
    TodoDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return todoDto;
  }

  Future<TodoDto> create(TodoDto todoDto) async {
    return _decodeTodo(
        await client.post(postPath, jsonEncode(todoDto.toJson())));
  }

  Future<TodoDto> delete(TodoDto todoDto) async {
    return _decodeTodo(
        await client.delete("$deletePath${todoDto.id}"));

  }

  Future<TodoDto> update(TodoDto todoDto) async {
    return _decodeTodo(
        await client.put(
            "$updatePath${todoDto.id}", jsonEncode(todoDto.toJson())));
  }
}
