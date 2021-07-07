
import 'package:flutter/material.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:get_it/get_it.dart';

class ItemCreateWidget extends StatefulWidget {

  const ItemCreateWidget({Key? key}) : super(key: key);

  @override
  _ItemCreateWidgetState createState() => _ItemCreateWidgetState();
}

class _ItemCreateWidgetState extends State<ItemCreateWidget> {
  late String itemName;
  late String itemDescription;
  final myController = TextEditingController();

  void postItem({required String itemName, required String itemDescription}) async{
    this.itemName = itemName;
    this.itemDescription = itemDescription;
    try {
      await GetIt.I.get<EventScreenCubit>().postItem(itemName: itemName, itemDescription: itemDescription );
    } catch (e) {
      Text('Error');
    }
  }

  _showPostItemDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Create Item'),
        content: Text('Do want to create the Item?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              postItem(itemName: itemName, itemDescription: itemDescription );
              Navigator.pop(context);
              Navigator.pop(context);},
            child: Text('Yes'),
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save and Create next Item'),
            onPressed: () {
              postItem(itemName: itemName, itemDescription: itemDescription );

              Navigator.pop(context);},
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Creation"),
      ),
      body: Column(
        children: [
          Text('Create Item'),

          const SizedBox(height: 20),

          const Text('Itemname:'),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
                hintText: 'Enter the Itemname'
            ),
            onChanged: (itemName) {
              itemName: String itemName;
            },
          ),
          const SizedBox(height: 40),

          const Text('Itemdescription:'),
          const SizedBox(height: 20),

          TextField(
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Enter the Itemdescription'
            ),
            onChanged: (itemDescription) {
              itemDescription: String itemDescription;
            },
          ),

          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: ()=>_showPostItemDialog(),
            child: const Text('Create Item')),
        ],
      ),
    );
  }
}
