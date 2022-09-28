import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/CarouselIndicators.dart';
import 'package:image_picker/image_picker.dart';

// TODO: show images fullscreen on tap with all images and carousel!
///
///
/// An simpple image carousel with indicators.
/// Supports webimages as well as local images
///
class ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final bool isLoadetFromWeb;
  final double maxHeight;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool zoomable;

  const ImageCarousel(
      {Key? key,
      this.imagePaths = const [],
      this.isLoadetFromWeb = false,
      this.maxHeight = 120,
      this.activeColor,
      this.inactiveColor,
      this.zoomable = false})
      : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  // the PageController is needet tocontroll the display and the current page
  late PageController _pageController;

  //the currently active Page is controlled here
  int activePage = 0;

  //int maxImages = 5;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: 20.0,
          maxHeight: widget.imagePaths.length == 0 ? 10 : widget.maxHeight,
        ),
        child: PageView.builder(
            // mainly for the indicators, so they are updated
            onPageChanged: (page) {
              setState(() {
                activePage = page;
              });
            },
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            pageSnapping: true,
            itemBuilder: (context, pagePosition) {
              // the image to be shown
              ImageProvider image = widget.isLoadetFromWeb
                  ? NetworkImage(dotenv.env['ipSim']!.toString() +
                      widget.imagePaths[pagePosition])
                  : Image.file(File(widget.imagePaths[pagePosition])).image;

              // we use container, because we use the images as boxdecoration
              return Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    image: DecorationImage(fit: BoxFit.cover, image: image)),
                child: GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (_) {
                          return FittedBox(
                              fit: BoxFit.contain,
                              child: InteractiveViewer(
                                  panEnabled: false,
                                  // Set it to false to prevent panning.
                                  boundaryMargin: EdgeInsets.all(80),
                                  minScale: 0.5,
                                  maxScale: 4,
                                  child: ImageDialog(
                                    image: image,
                                  )));
                        });
                  },
                ),
              );
            }),
      ),
      // The indicators!
      CarouselIndicators(
        length: widget.imagePaths.length,
        activePage: activePage,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
      )
    ]
        // Pageview so we have a nice little carousel

        );
  }
}

class ImageDialog extends StatelessWidget {
  final ImageProvider image;
  final Function()? buttonFunction;

  ImageDialog({Key? key, required this.image, this.buttonFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = image.resolve(const ImageConfiguration());
    return Dialog(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.contain)),
          ),
          if (buttonFunction != null)
            TextWithIconButton(
                onPressed: buttonFunction!, text: "Delete picture.")
          else
            Text(""),
        ],
      ),
    );
  }

  ///returns zoomable dialog for pictures
  static showInterActiveImageOverlay(
      BuildContext context, String? networkImagePath) async {
    AssetImage asset = const AssetImage("assets/images/partypeople.jpg");
    Size size;
    size = await GeneralImage.calculateImageDimension(networkImagePath, asset)
        .then((size) => size);
    await showDialog(
        context: context,
        builder: (_) {
          return Container(
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: size.aspectRatio,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: InteractiveViewer(
                    panEnabled: false,
                    // Set it to false to prevent panning.
                    minScale: 0.5,
                    maxScale: 4,
                    child: ImageDialog(
                      image: GeneralImage.getAssetOrNetwork(
                        networkImagePath,
                        asset,
                      ),
                    ),
                  ),
                ),
              ));
        });
  }

  static showInterActiveImagePickerOverlay(
      BuildContext context, List<String>? imagePaths) async {
    await showDialog(
        context: context,
        builder: (_) {
          //check if we display the caroussel
          if (imagePaths!.length > 1) {
            return OverflowBox(
                child: Column(
              //global align in center
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //return imagecaroussel and u can click on the seperate images again
                ImageCarousel(
                    //white colors because showDialog makes everything grey
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                    maxHeight: 100,
                    isLoadetFromWeb: true,
                    imagePaths: imagePaths),
              ],
            ));
          } else {
            //just show the 1 profilepic on click
            return FittedBox(
              fit: BoxFit.contain,
              child: ImageDialog(
                image: ProfileImage.getAssetsOrNetwork(imagePaths),
              ),
            );
          }
        });
  }
}

// TODO: This is work on the Carousell as popup
// class ImageDialog extends StatefulWidget {
//   final List<ImageProvider> images;
//
//
//
//   const ImageDialog({Key? key, required this.images}) : super(key: key);
//
//   @override
//   State<ImageDialog> createState() => _ImageDialogState();
// }
//
// class _ImageDialogState extends State<ImageDialog> {
//   // the PageController is needet tocontroll the display and the current page
//   late PageController _pageController;
//   //the currently active Page is controlled here
//   int activePage = 0;
//
//   @override
//   void initState(){
//     _pageController = PageController(viewportFraction: 0.95);
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return Dialog(
//         child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children:
//             [
//               Expanded(
//                   child:
//                   PageView.builder(
//
//
//                       controller: _pageController,
//                       pageSnapping: true,
//                       itemCount: widget.images.length,
//                       itemBuilder: (context,pagePosition) {
//                         return Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height,
//                           decoration: BoxDecoration(
//                               color: Colors.transparent,
//                               image: DecorationImage(
//                                   image: widget.images[pagePosition],
//                                   fit: BoxFit.fitWidth
//                               )
//                           ),
//                         );
//
//                       })),
//             ])
//     );
//   }
// }
//
