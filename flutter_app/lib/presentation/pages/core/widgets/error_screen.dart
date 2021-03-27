import 'package:flutter/cupertino.dart';

class ErrorScreen extends StatelessWidget{
  final String fail;
  const ErrorScreen({Key? key, required this.fail}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(fail),
        );
  }


}