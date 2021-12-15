import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/item.dart';

class ItemElementWidget extends StatelessWidget {
  final Item item;
  final String name;
  final String description;
  final List<Profile> profiles;
  final Function(Item item)? deleteItemFunc;
  final Function(Item item)? editItemFunc;
  final Function(Item item)? assignProf;

  const ItemElementWidget(
      {required this.item,
      required this.name,
      required this.description,
      required this.profiles,
      this.deleteItemFunc,
      this.editItemFunc,
      this.assignProf});

  @override
  Widget build(BuildContext context) {
    return buildListtile(editItemFunc != null);
  }

  //seperate to fix the editItem
  Widget buildListtile(bool editItem) {
    return ListTile(
      leading: const FlutterLogo(), //Todo Userlogos displayed here
      title: Text(name),
      subtitle: Text(description + "\n" + profileNames(item.profiles!)),
      trailing: actionButtons(deleteItemFunc != null),
      onTap: () {
        editItemFunc!(item);
      },
      onLongPress: () {
        //assign profile to todo item
        assignProf!(item);
      },
    );
  }

  String profileNames(List<Profile> profiles) {
    String profileNameList = "";
    for (var i = 0; i < profiles.length; i++) {
      String profileNameI =
          profiles[i].name.value.fold((l) => l.toString(), (r) => r.toString());
      profileNameList = "$profileNameI";
    }
    return profileNameList;
  }

  Widget actionButtons(bool deleteItem) {
    return IconButton(
        onPressed: () {
          deleteItemFunc!(item);
        },
        icon: Icon(Icons.delete));
  }
}
