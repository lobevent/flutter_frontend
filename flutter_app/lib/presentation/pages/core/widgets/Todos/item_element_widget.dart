import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:get_it/get_it.dart';

import '../../../../../data/storage_shared.dart';

class ItemElementWidget extends StatefulWidget {
  final Item item;
  final String name;
  final String description;
  final List<Profile> profiles;
  final Function(Item item)? deleteItemFunc;
  final Function(Item item)? editItemFunc;
  final Function(Item item)? assignProf;
  final Function(Item item)? deassignProf;

  const ItemElementWidget(
      {required this.item,
      required this.name,
      required this.description,
      required this.profiles,
      this.deleteItemFunc,
      this.editItemFunc,
      this.assignProf,
      this.deassignProf});

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
        //TODO: deassignen verbieten wenn paar h vorher?
        //deassign profile to todo item
        String? ownId=GetIt.I<StorageShared>().getOwnProfileId();
        if(widget.item.profiles!.map((e) => e.id.value).contains(GetIt.I<StorageShared>().getOwnProfileId())){
          widget.deassignProf!(widget.item);
        }else{
          widget.assignProf!(widget.item);
        }
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
          //deactivate button if deleting is alredy ongoing
          if(!isDeleting) widget.deleteItemFunc!(widget.item);
          this.isDeleting = true;
          setState(() {});
        },
        icon: Icon(Icons.delete));
  }
}
