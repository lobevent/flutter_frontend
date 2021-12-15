import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/infrastructure/todo/item_remote_service.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/todo_cubit/todo_cubit.dart';
import 'package:flutter_frontend/domain/todo/item.dart';

class ItemCreateWidget extends StatefulWidget {
  final Event event;
  final Todo todo;
  final Item? item;
  //function for editing item or posting new item
  final Function(Item item)? onEdit;

  const ItemCreateWidget(
      {Key? key,
      required this.event,
      required this.todo,
      this.item,
      this.onEdit})
      : super(key: key);

  @override
  _ItemCreateWidgetState createState() =>
      _ItemCreateWidgetState(event, todo, item, onEdit);
}

class _ItemCreateWidgetState extends State<ItemCreateWidget> {
  String itemName = '';
  String itemDescription = '';
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final Event event;
  final Todo todo;
  final Item? item;
  final Function(Item item)? onEdit;

  _ItemCreateWidgetState(this.event, this.todo, this.item, this.onEdit);

  @override
  void initState() {
    super.initState();

    // Start listening to changes.

    // itemNameController.addListener(_printLatestValue);
    // itemDescriptionController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    //itemNameController.dispose();
    //itemDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(event: event),
      child: BlocBuilder<TodoCubit, TodoState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Item Creation"),
          ),
          body: Column(
            children: [
              Text(item != null ? 'Edit Item' : 'Create Item'),
              const SizedBox(height: 20),
              const Text('Itemname:'),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText:
                        item != null ? getItemName() : 'Enter the Itemname'),
                controller: itemNameController,
              ),
              const SizedBox(height: 40),
              const Text('Itemdescription:'),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: item != null
                        ? getItemDesc()
                        : 'Enter the Itemdescription'),
                controller: itemDescriptionController,
              ),
              actionButton(onEdit != null, context),
            ],
          ),
        );
      }),
    );
  }

  Widget actionButton(bool edit, BuildContext context) {
    return MaterialButton(
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        if (edit) {
          final Item editItem = Item(
              id: item!.id,
              name: ItemName(itemNameController.text),
              description: ItemDescription(itemDescriptionController.text),
              maxProfiles: item!.maxProfiles == null
                  ? ItemMaxProfiles(3)
                  : item!.maxProfiles!,
              //fake profile list
              profiles: item!.profiles);
          onEdit!(editItem);
          context.router.pop();
        } else {
          context.read<TodoCubit>().postItem(
              itemName: itemNameController.text,
              itemDescription: itemDescriptionController.text,
              todo: todo);
          context.router.pop();
        }
      },
      //dispose();
      child: Text(item != null ? 'Edit Item' : 'Create Item'),
    );
  }

  String getItemName() {
    return itemNameController.text =
        item!.name.value.fold((l) => l.toString(), (name) => name.toString());
  }

  String getItemDesc() {
    return itemDescriptionController.text = item!.description.value
        .fold((l) => l.toString(), (desc) => desc.toString());
  }

  //overlay try
  void showOverlay(BuildContext context) {
    //declaring and initializing the overlay state and objects
    OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        left: MediaQuery.of(context).size.height * 0.3,
        top: MediaQuery.of(context).size.width * 0.4,
        child: BlocProvider(
          create: (context) => TodoCubit(event: event),
          child: BlocBuilder<TodoCubit, TodoState>(builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Item Creation"),
              ),
              body: Column(
                children: [
                  Text(item != null ? 'Edit Item' : 'Create Item'),
                  const SizedBox(height: 20),
                  const Text('Itemname:'),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: item != null
                            ? getItemName()
                            : 'Enter the Itemname'),
                    controller: itemNameController,
                  ),
                  const SizedBox(height: 40),
                  const Text('Itemdescription:'),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: item != null
                            ? getItemDesc()
                            : 'Enter the Itemdescription'),
                    controller: itemDescriptionController,
                  ),
                  actionButton(onEdit != null, context),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
