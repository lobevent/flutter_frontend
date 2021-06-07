import 'package:flutter/cupertino.dart';

class HeaderVisual extends StatelessWidget{

  final String? networkImagePath;

  const HeaderVisual({this.networkImagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("partypeople.jpg"),
        ),
      ),
    );
  }

}