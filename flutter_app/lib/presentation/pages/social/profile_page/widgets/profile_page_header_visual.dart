import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/content_widgets.dart';

class ProfilePageHeaderVisual extends StatelessWidget{
  final String? imagePath;
  const ProfilePageHeaderVisual({Key? key, String? this.imagePath}):super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
        children:
        [
          const Spacer(),
          CircleAvatar(radius: 90,
          backgroundImage: _getAssetOrNetwork(imagePath),),
          const Spacer(),
        ]
    );
  }


  ImageProvider _getAssetOrNetwork(String? imagePath){
    if(imagePath != null){
      return NetworkImage(imagePath);
    }else{
      return AssetImage("assets/images/partypeople.jpg",);
    }
  }


}