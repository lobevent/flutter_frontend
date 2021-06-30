import 'package:flutter/cupertino.dart';


/// contains functions for the profile images in one class
/// (like loading the same asset image)
class ProfileImage{
  /// check if an image string is given, and if not give back an image from assets
  static ImageProvider getAssetOrNetwork(String? imagePath){
    if(imagePath != null){
      return NetworkImage(imagePath);
    }else{
      return const AssetImage("assets/images/partypeople.jpg",);
    }
  }
}