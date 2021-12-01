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

  const ItemElementWidget(
      {required this.item,
      required this.name,
      required this.description,
      required this.profiles,
      this.deleteItemFunc,
      this.editItemFunc});

  @override
  Widget build(BuildContext context) {
    return buildListtile(editItemFunc != null);
  }

  //seperate to fix the editItem
  Widget buildListtile(bool editItem) {
    return ListTile(
        leading: const FlutterLogo(), //Todo Userlogos displayed here
        title: Text(name),
        subtitle: Text(description),
        trailing: actionButtons(deleteItemFunc != null),
        onTap: () {
          editItemFunc!(item);
        });
  }

  Widget actionButtons(bool deleteItem) {
    return IconButton(
        onPressed: () {
          deleteItemFunc!(item);
        },
        icon: Icon(Icons.delete));
  }
}
