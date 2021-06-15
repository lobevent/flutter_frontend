import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/todo/todo_cubit.dart';
import 'package:flutter_frontend/domain/todo/item.dart';

import 'item_element_widget.dart';

class TodoContent extends StatelessWidget {
  const TodoContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state){
        return state.maybeMap(
            loaded: (state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TodoName(state.todo.name.getOrCrash()),

                  /// Used as space
                  const SizedBox(height: 20),

                  TodoItemList(state.todo.items),
                ],
              );
            },
            /// If some other state is active, display empty
            orElse: () => TodoName(''));
      },
    );
  }


  Widget TodoItemList (List<Item> items){
    return ListView(
      children: <Widget> [
        ...getTodoItems(items)
      ],
    );
  }

  List<Widget> getTodoItems(List<Item> items){
    final List<Widget> itemElements = [];

    items.forEach((element) {
      final Widget elements = ItemElementWidget(
        name: element.name.toString(),
        profiles: element.profiles,
        description: element.description.toString(),
      );
      itemElements.add(elements);
    });
    return itemElements;
  }

  Widget TodoName (String title){
    return PaddingWidget(
        children: [
          Text(
              title,
              style: const TextStyle(
                  height: 2,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
              )
          )
        ]
    );
  }
  Widget PaddingWidget({required List<Widget> children}){
    return Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(children: children),
    );
  }

}
