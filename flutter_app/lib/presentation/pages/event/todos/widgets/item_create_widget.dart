import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/todo_cubit/todo_cubit.dart';

class ItemCreateWidget extends StatefulWidget {
  final Event event;
  final Todo todo;
  //orgalist created or not
  const ItemCreateWidget({Key? key, required this.event, required this.todo})
      : super(key: key);

  @override
  _ItemCreateWidgetState createState() => _ItemCreateWidgetState(event, todo);
}

class _ItemCreateWidgetState extends State<ItemCreateWidget> {
  String itemName = '';
  String itemDescription = '';
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final Event event;
  final Todo todo;

  _ItemCreateWidgetState(this.event, this.todo);

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
              const Text('Create Item'),
              const SizedBox(height: 20),
              const Text('Itemname:'),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Enter the Itemname'),
                controller: itemNameController,
              ),
              const SizedBox(height: 40),
              const Text('Itemdescription:'),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Enter the Itemdescription'),
                controller: itemDescriptionController,
              ),
              actionButton(context),
            ],
          ),
        );
      }),
    );
  }

  Widget actionButton(BuildContext context) {
    return MaterialButton(
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () => context.read<TodoCubit>().postItem(
          itemName: itemNameController.text,
          itemDescription: itemDescriptionController.text,
          todo: todo),
      //dispose();
      child: const Text('Create Item'),
    );
  }
}
