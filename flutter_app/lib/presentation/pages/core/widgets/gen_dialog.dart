import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';

class GenDialog {
  ///generates a generic dialog with some strings and asks for an answer to the showdialog to confirm or
  ///abort the action, also u can set barrierdismisible false or true
  static Future<bool> genericDialog(
      BuildContext context, String dialogTitle, String dialogText,
      [String dialogConfirm = "Bestátigen",
      String dialogAbort = "Abbrechen",
      bool barrierDissmissible = true]) async {
    bool answer = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: barrierDissmissible, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(dialogText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              //Cpnfirmation
              child: Text(dialogConfirm),
              onPressed: () {
                Navigator.of(context).pop();
                answer = true;
              },
            ),
            TextButton(
              //Abortion
              child: Text(dialogAbort),
              onPressed: () {
                Navigator.of(context).pop();
                answer = false;
              },
            ),
          ],
        );
      },
    );
    return answer;
  }
}
