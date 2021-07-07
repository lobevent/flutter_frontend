
import 'package:flutter/material.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:get_it/get_it.dart';

class ItemCreateWidget extends StatefulWidget {

  const ItemCreateWidget({Key? key}) : super(key: key);

  @override
  _ItemCreateWidgetState createState() => _ItemCreateWidgetState();
}

class _ItemCreateWidgetState extends State<ItemCreateWidget> {
  String itemName = '';
  String itemDescription = '';
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    // itemNameController.addListener();
    // itemDescriptionController.addListener();
  }


  Future<void> postItem({required String itemName, required String itemDescription}) async{
    this.itemName = itemName;
    this.itemDescription = itemDescription;
    try {
      await GetIt.I.get<EventScreenCubit>().postItem(itemName: itemName, itemDescription: itemDescription );
    } catch (e) {
      const Text('Error');
    }
  }

  Future<bool?> _showPostItemDialog({required String itemName, required String itemDescription}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create Item'),
        content: const Text('Do want to create the Item?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              postItem(itemName: itemName, itemDescription: itemDescription );
              dispose();
              Navigator.pop(context);
              Navigator.pop(context);},
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              postItem(itemName: itemName, itemDescription: itemDescription );
              dispose();
              Navigator.pop(context);},
            child: const Text('Save and Create next Item'),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    itemNameController.dispose();
    itemDescriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
            onPressed: ()=>_showPostItemDialog(itemName: itemNameController.text ,itemDescription: itemDescriptionController.text),
            child: const Text('Create Item')),
        ],
      ),
    );
  }
}
