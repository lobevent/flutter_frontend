
import 'package:flutter/material.dart';

class ItemCreateWidget extends StatefulWidget {

  const ItemCreateWidget({Key? key}) : super(key: key);

  @override
  _ItemCreateWidgetState createState() => _ItemCreateWidgetState();
}

class _ItemCreateWidgetState extends State<ItemCreateWidget> {
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

          TextField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
                hintText: 'Enter your Item'
            ),
          ),
        ],
      ),
    );
  }
}
