
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/application/todo/todo_cubit.dart';

import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:get_it/get_it.dart';

class ItemCreateWidget extends StatefulWidget {
  final Event event;
  const ItemCreateWidget({Key? key, required this.event}) : super(key: key);

  @override
  _ItemCreateWidgetState createState() => _ItemCreateWidgetState(event);
}

class _ItemCreateWidgetState extends State<ItemCreateWidget> {
  String itemName = '';
  String itemDescription = '';
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final Event event;

  _ItemCreateWidgetState(this.event);

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
        child: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Item Creation"),
            ),
            body: Column(
              children: [
                const Text('Create Item'),

                const SizedBox(height: 20),

                const Text('Itemname:'),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                      hintText: 'Enter the Itemname'
                  ),
                  controller: itemNameController,
                ),
                const SizedBox(height: 40),

                const Text('Itemdescription:'),
                const SizedBox(height: 20),

                TextField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter the Itemdescription'
                  ),
                  controller: itemDescriptionController,
                ),

                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () =>
                      context.read<TodoCubit>().postItem(itemName: itemNameController.text, itemDescription: itemDescriptionController.text),
                  //dispose();
                  child: const Text('Create Item')),
              ],
            ),
          );
      }
    ),
    );
  }
}
