import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/infrastructure/todo/item_remote_service.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/todo_overlay_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/todo_cubit/todo_cubit.dart';
import 'package:flutter_frontend/domain/todo/item.dart';


class ItemCreateWidget extends StatefulWidget {
  final OverlayEntry overlayEntry;
  final Event event;
  final Todo todo;
  final Item? item;
  //function for editing item or posting new item
  final Function(Item item)? onEdit;
  final BuildContext cubitContext;

  const ItemCreateWidget(
      {Key? key,
      required this.overlayEntry,
      required this.event,
      required this.todo,
      this.item,
      this.onEdit,
        required this.cubitContext})
      : super(key: key);

  @override
  _ItemCreateWidgetState createState() =>
      _ItemCreateWidgetState(event, todo, item, onEdit, overlayEntry, cubitContext);
}

class _ItemCreateWidgetState extends State<ItemCreateWidget> {
  OverlayEntry overlayEntry;
  String itemName = '';
  String itemDescription = '';
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final Event event;
  final Todo todo;
  final Item? item;
  final Function(Item item)? onEdit;
  final BuildContext cubitContext;

  _ItemCreateWidgetState(
      this.event, this.todo, this.item, this.onEdit, this.overlayEntry, this.cubitContext);

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

    return BlocBuilder<EventScreenCubit, EventScreenState>(
        builder: (con, st) => LoadingOverlay(child: OverlayScaffold(context), isLoading: st.maybeMap(loading: (state) => true, orElse:() => false)),
        // this is for accessing the blocProvider from the context!!!
        bloc: BlocProvider.of(cubitContext));

  }


  Widget OverlayScaffold(BuildContext context){
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
          actionButton(onEdit != null, context, overlayEntry),
        ],
      ),
    );
  }

  Widget actionButton(
      bool edit, BuildContext context, OverlayEntry overlayEntry) {
    return MaterialButton(
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        if (edit) {
          /*
          if (overlayEntry != null) {
            //remove overlay so we have to dont fuck around with routes
            overlayEntry.remove();
          }

           */

          ///
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
          //context.router.pop();
        } else {
          if (overlayEntry != null) {
            cubitContext.read<EventScreenCubit>().postItem(
                itemName: itemNameController.text,
                itemDescription: itemDescriptionController.text,
                todo: todo).then((value) => overlayEntry.remove());
            //remove overlay so we have to dont fuck around with routes

          }

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


}
