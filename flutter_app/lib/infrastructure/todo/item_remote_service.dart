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


class TodoRemoteSetvice extends RemoteService<TodoDto> {

  static const String postPath = "/event";
  static const String deletePath = "/event/";
  static const String updatePath = "/event/edit/";
  static const String assignPath = "/event/";

  final SymfonyCommunicator client;


  TodoRemoteSetvice({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();


/*  Future<ItemDto> addItem(ItemDto item) async{

  }*/
}