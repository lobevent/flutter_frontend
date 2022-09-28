import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/CarouselIndicators.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../domain/event/event_profile_picture.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

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
  final bool isDialog;
  final int startPosition;
  final List<EventProfilePicture> epps;

  const ImageCarousel(
      {Key? key,
      this.imagePaths = const [],
      this.isLoadetFromWeb = false,
      this.maxHeight = 120,
      this.activeColor,
      this.inactiveColor,
      this.zoomable = false, this.isDialog = false, this.epps = const [], this.startPosition = 0})
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
    activePage = widget.startPosition;
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: activePage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildImages(),
      // The indicators!
      _buildCarouselIndicators()
    ]
        // Pageview so we have a nice little carousel

        );
  }

  ///
  /// builds CarouselIndicators
  /// indicate where we are in the view
  ///
  Widget _buildCarouselIndicators() {
    return CarouselIndicators(
      length: widget.imagePaths.length,
      activePage: activePage,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
    );
  }

  ///
  /// builds the Pageviewer
  /// This is the horizontal scrollable Part
  ///
  Widget _buildImages() {
    return ConstrainedBox(
      constraints: new BoxConstraints(
        minWidth: 20.0,
        maxHeight: widget.imagePaths.length == 0 ? 10 : widget.maxHeight,
      ),
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
          // mainly for the indicators, so they are updated
          onPageChanged: (page) {
            setState(() {
              activePage = page;
            });
          },
          controller: _pageController,
          // if we receive epps take their lenght
          itemCount: widget.epps.length == 0 ? widget.imagePaths.length : widget.epps.length,
          pageSnapping: true,
          itemBuilder: (context, pagePosition) {
          // ------------------------------------------------------------------------ START ITEMBUILDER ----------------------------------------
          ImageProvider image;
          // indicates wheter we show the profile button or not
          bool withProfile;


          if(widget.epps.length == 0) {
              // the image to be shown
              image = widget.isLoadetFromWeb
                  ? NetworkImage(dotenv.env['ipSim']!.toString() + widget.imagePaths[pagePosition])
                  : Image.file(File(widget.imagePaths[pagePosition])).image;
              withProfile = false;
          }else{
            withProfile = true;
            image = NetworkImage(dotenv.env['ipSim']!.toString() + widget.epps[pagePosition].path);
          }

            // If its an dialog, enable scrolling with [interactiveViewer]
            return widget.isDialog ? Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  InteractiveViewer(
                      child: _buildSingleImage(image, context),
                    ),
                  /*if(withProfile)*/ SizedBox(height: 20,),
                  _showUserButton(Profile(id: UniqueId(), name: ProfileName("asdad"))/*widget.epps[pagePosition].profile*/),
                  /*if(withProfile)*/ SizedBox(height: 20,),
                ],
            ):
            _buildSingleImage(image, context);
          // ------------------------------------------------------------------------ END ITEMBUILDER ----------------------------------------
          }),
    );
  }

  ///
  /// Builds image with gesture detector for capturing tapping events
  /// On tap another dialog is displayed for confortable zooming
  /// [image] is an ImageProvider and contains the actual image
  /// [context] is used for dimensions
  ///
  Widget _buildSingleImage(ImageProvider<Object> image, BuildContext context)  {
    return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (_) {
              return FittedBox(
                  fit: BoxFit.fitWidth,
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
      },// we use container, because we use the images as boxdecoration
    child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: widget.isDialog?AppColors.darkGrey.withOpacity(0.5):null,
                  image: DecorationImage(fit: widget.isDialog? BoxFit.scaleDown : BoxFit.cover, image: image)),
              child: ConstrainedBox(
                child: Text(""),
                constraints: new BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width/1.2,
                  minHeight: widget.maxHeight - 100,
                  maxHeight: widget.imagePaths.length == 0 ? 10 : widget.maxHeight,
                ),),
               //child:
            ));
  }

  ///
  /// builds the UserButton, on tap should be routing to the user page
  ///
  Widget _showUserButton(Profile profile) {
    // constrined Box is used here, so the button is smaller then the widgets
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/1.5),
        child: TextWithIconButton(withSpacer: true, onPressed: (){
          context.router.push(ProfilePageRoute(profileId: profile.id));
        }, text: profile.name.getOrEmptyString(), icon: Icons.person,));
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

  static showInterActiveImageCarouselOverlay(
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
                    isDialog: true,
                    //white colors because showDialog makes everything grey
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                    maxHeight: MediaQuery.of(context).size.height/1.6,
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



  static EppsShowInterActiveImageCarouselOverlay(
      BuildContext context, List<EventProfilePicture> epps, [int activePage = 0]) async {
    await showDialog(
        context: context,
        builder: (_) {
            return OverflowBox(
                child: Column(
              //global align in center
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //return imagecaroussel and u can click on the seperate images again
                ImageCarousel(
                    startPosition: activePage,
                    isDialog: true,
                    //white colors because showDialog makes everything grey
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                    maxHeight: MediaQuery.of(context).size.height/1.6,
                    isLoadetFromWeb: true,
                    epps: epps,
                    imagePaths: []),
              ],
            ));
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
