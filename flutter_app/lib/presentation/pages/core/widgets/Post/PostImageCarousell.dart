import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final bool isLoadetFromWeb;
  const PostImageCarousel({Key? key, required this.imagePaths, this.isLoadetFromWeb = false}) : super(key: key);


  @override
  State<PostImageCarousel> createState() => _PostImageCarouselState();
}

class _PostImageCarouselState extends State<PostImageCarousel> {

  late PageController _pageController;
  int activePage = 0;
  //int maxImages = 5;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }



  @override
  Widget build(BuildContext context) {
    return Column(
        children: [ConstrainedBox(
          constraints: new BoxConstraints(
            minWidth: 20.0,
            maxHeight: widget.imagePaths.length == 0 ? 10 : 120.0,
          ),
          child:

          PageView.builder(
            // mainly for the indicators, so they are updated
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              pageSnapping: true,
              itemBuilder: (context,pagePosition){
                // we use container, because we use the images as boxdecoration
                return Container(
                  // so the images dont overlap
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(dotenv.env['ipSim']!.toString() + widget.imagePaths[pagePosition])
                          //image: widget.isLoadetFromWeb ? NetworkImage(widget.imagePaths[pagePosition]) : Image.file(File(preview[pagePosition]!.path)).image
                      )),

                );}),


        ),
          // The indicators!
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: indicators(widget.imagePaths.length, activePage))
        ]
      // Pageview so we have a nice little carousel

    );
  }



    /// This method generate indicator dots in the image preview
    List<Widget> indicators(int imagesLength, int currentIndex) {
      return List<Widget>.generate(imagesLength, (index) {
        return Container(
          margin: EdgeInsets.all(3),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: currentIndex == index ? Colors.black : Colors.black26,
              shape: BoxShape.circle),
        );
      });
    }
}
