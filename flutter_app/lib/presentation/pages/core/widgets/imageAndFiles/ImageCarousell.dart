import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  const ImageCarousel(
      {Key? key,
      this.imagePaths = const [],
      this.isLoadetFromWeb = false,
      this.maxHeight = 120})
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
                child: GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (_) => FittedBox(
                            //TODO fix bs design
                            fit: BoxFit.contain,
                            child: ImageDialog(
                              image: image,
                            )));
                  },
                ),
                // so the images dont overlap
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    image: DecorationImage(fit: BoxFit.cover, image: image)),
              );
            }),
      ),
      // The indicators!
      CarouselIndicators(
          length: widget.imagePaths.length, activePage: activePage)
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
    return Dialog(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.cover)),
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
