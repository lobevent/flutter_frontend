import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? cancel;
  final String? accept;
  final Future acceptFunction;

  const CustomAlertDialog(
      {Key? key,
      required this.title,
      required this.description,
      required this.cancel,
      required this.accept,
      required this.acceptFunction})
      : super(key: key);

  ///returns custom alertdialog, pass the textstrings and the function that has to be submitted
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancel ?? "Cancel"),
            ),
            TextButton(
              onPressed: () => acceptFunction,
              child: Text(accept ?? "Ok"),
            ),
          ],
        ),
      ),
      child: Text('$title'),
    );
  }
}
