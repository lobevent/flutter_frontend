import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/dismissible_overlay.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/todo_overlay_cubit.dart';


class ItemCreateWidget extends StatefulWidget {
  final OverlayEntry overlayEntry;
  final Todo todo;
  final Item? item;
  //function for editing item or posting new item
  final Function(Item item)? onEdit;
  final BuildContext cubitContext;

  const   ItemCreateWidget(
      {Key? key,
      required this.overlayEntry,
      required this.todo,
      this.item,
      this.onEdit,
        required this.cubitContext})
      : super(key: key);

  @override
  _ItemCreateWidgetState createState() =>
      _ItemCreateWidgetState( todo, item, onEdit, overlayEntry, cubitContext);
}

class _ItemCreateWidgetState extends State<ItemCreateWidget> {
  OverlayEntry overlayEntry;
  String itemName = '';
  String itemDescription = '';
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final Todo todo;
  final Item? item;
  final Function(Item item)? onEdit;
  final BuildContext cubitContext;

  _ItemCreateWidgetState(this.todo, this.item, this.onEdit, this.overlayEntry, this.cubitContext);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // sets the vaules its edit
    _setTextControllerValues();

    return BlocBuilder<EventScreenCubit, EventScreenState>(
        builder: (con, st) => LoadingOverlay(child: OverlayScaffold(context), isLoading: st.maybeMap(loading: (state) => true, orElse:() => false)),
        // this is for accessing the blocProvider from the context!!!
        bloc: BlocProvider.of(cubitContext));

  }


  Widget OverlayScaffold(BuildContext context){
    // make the overlay dismissible, so it can be swiped away
    return DismissibleOverlay(overlayEntry: overlayEntry,
          child: Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 20),
              Text(item != null ? 'Edit Item' : 'Create Item', style: Theme.of(context).textTheme.headline3,),
              const SizedBox(height: 20),
              FullWidthPaddingInput(controller:  itemNameController, labelText: 'Enter the Itemname'),
              const SizedBox(height: 20),
              FullWidthPaddingInput(controller:  itemDescriptionController, labelText: 'Enter the Itemdescription'),
              actionButton(onEdit != null, context, overlayEntry),
            ],
          ),
          )
      );
  }

  Widget actionButton(
      bool edit, BuildContext context, OverlayEntry overlayEntry) {
    return StdTextButton(
      onPressed: () {
        if (edit) {
          // call the onEdit function, and copy previus Item with the new text!
          onEdit!(item!.copyWith(name: ItemName(itemNameController.text), description: ItemDescription(itemDescriptionController.text)));
        } else {
          if (overlayEntry != null) {
            cubitContext.read<EventScreenCubit>().postItem(
                itemName: itemNameController.text,
                itemDescription: itemDescriptionController.text,
                todo: todo)
                // first save item, then remove overlay
                .then((value) => overlayEntry.remove());
            //remove overlay so we have to dont fuck around with routes
          }
        }
      },

      child: Text(item != null ? 'Edit Item' : 'Create Item', style: TextStyle(color: AppColors.stdTextColor)),
    );
  }



  void _setTextControllerValues(){
    if(onEdit != null){
      itemDescriptionController.text = item!.description.value
          .fold((l) => l.toString(), (desc) => desc.toString());
      itemNameController.text =
          item!.name.value.fold((l) => l.toString(), (name) => name.toString());
    }
  }


}
