import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

// ignore: avoid_classes_with_only_static_members
/// contains functions for the profile images in one class
/// (like loading the same asset image)
class ProfileImage {
  /// check if an image string is given, and if not give back an image from assets
  static ImageProvider getAssetOrNetwork(String? imagePath,
      [AssetImage? assetImage]) {
    if (imagePath != null) {
      // TODO: This is a common problem, but networlimage has no fallback... so it throws an error if the file doesnt exits!
      return NetworkImage(dotenv.env['ipSim']!.toString() + imagePath);
    } else {
      return assetImage ??
          const AssetImage(
            "assets/images/partypeople.jpg",
          );
    }
  }

  static Widget getAssetOrNetworkFading(String? imagePath) {
    return FadeInImage.assetNetwork(
      placeholder: "assets/images/partypeople.jpg",
      image: dotenv.env['ipSim']!.toString() + (imagePath ?? ""),
      imageErrorBuilder: (e, b, c) {
        return Image(
            image: AssetImage(
          "assets/images/partypeople.jpg",
        ));
      },
    );
  }

  // TODO: make it viable for a list of images
  static ImageProvider getAssetsOrNetwork(List<String?> imagePaths,
      [AssetImage? assetImage]) {
    if (imagePaths != null && imagePaths.length != 0) {
      return NetworkImage(dotenv.env['ipSim']!.toString() + imagePaths.first!);
      //return NetworkImage(dotenv.env['ipSim']!.toString()+imagePaths.last!);
    } else {
      return assetImage ??
          const AssetImage(
            "assets/images/partypeople.jpg",
          );
    }
  }

  static ImageProvider returnProfileAsset() {
    return const AssetImage(
      "assets/images/partypeople.jpg",
    );
  }

  static ImageProvider getAssetOrNetworkFromProfile(Profile profile) {
    return getAssetOrNetwork(profile.images?[0]);
  }
}

class GeneralImage {
  /// check if an image string is given, and if not give back an image from assets
  static ImageProvider getAssetOrNetwork(String? imagePath,
      [AssetImage? assetImage]) {
    if (imagePath != null) {
      // TODO: This is a common problem, but networlimage has no fallback... so it throws an error if the file doesnt exits!
      return NetworkImage(dotenv.env['ipSim']!.toString() + imagePath);
    } else {
      return assetImage ??
          const AssetImage(
            "assets/images/partypeople.jpg",
          );
    }
  }

  static Future<Size> calculateImageDimension(
      String? imagePath, AssetImage assetImage) {
    Completer<Size> completer = Completer();
    var image;
    if (imagePath != null) {
      image = NetworkImage(dotenv.env['ipSim']!.toString() + imagePath!);
    } else {
      image = assetImage;
    }
    image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }
}
