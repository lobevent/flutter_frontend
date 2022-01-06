import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/item.dart';

class ItemElementWidget extends StatefulWidget {
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
  State<ItemElementWidget> createState() => _ItemElementWidgetState();
}

class _ItemElementWidgetState extends State<ItemElementWidget> {

  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return buildListtile(widget.editItemFunc != null);
  }

  //seperate to fix the editItem
  Widget buildListtile(bool editItem) {
    return ListTile(
      tileColor: isDeleting? Color(0x28FF0000) :null,
      leading: Icon(Icons.check_circle_outline_outlined), //Todo Userlogos displayed here
      title: Text(widget.name), //the name of the todoitem
      // the assigned profiles
      subtitle: Text(widget.description + "\n" + profileNames(widget.item.profiles!)),
      trailing: actionButtons(widget.deleteItemFunc != null),
      onTap: () {
        widget.editItemFunc!(widget.item);
      },
      onLongPress: () {
        //assign profile to todo item
        widget.assignProf!(widget.item);
      },
    );
  }

  // extract the assigned profile names
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
          this.isDeleting = true;
          //deactivate button if deleting is alredy ongoing
          if(!isDeleting) widget.deleteItemFunc!(widget.item);
          setState(() {});
        },
        icon: Icon(Icons.delete));
  }
}
