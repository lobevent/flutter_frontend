import 'package:dartz/dartz.dart' as darz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/ImageCarousell.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/EventProfilePictures/SmallCarousel/cubit/es_ec_epp_smal_carousel_cubit.dart';

import '../../../../../../../../../domain/event/event.dart';
import '../../../../../../../../core/styles/colors.dart';


///
/// Displays some EPP
///
class EventProfilePicturesSmallCarousell extends StatefulWidget {
  final Event event;

  const EventProfilePicturesSmallCarousell({Key? key, required this.event}) : super(key: key);

  @override
  State<EventProfilePicturesSmallCarousell> createState() => _EventProfilePicturesSmallCarousellState();
}

class _EventProfilePicturesSmallCarousellState extends State<EventProfilePicturesSmallCarousell> {

  @override
  Widget build(BuildContext context) {
    return _generateWithCapacity();
    
    return Container();
  }

  
  Widget _generateWithCapacity(){
    return BlocProvider(
        create: (context) => EsEcEppSmalCarouselCubit(widget.event),
        child: BlocBuilder<EsEcEppSmalCarouselCubit, EsEcEppSmalCarouselState>(
        builder: (context, state){
          return state.maybeMap(orElse: ()=>Text("ss"),
              loadingPictures: (_)=>Text("loading"),
              error: (fal)=> Text(fal.failure.toString()),
              picsLoaded: (pls){
                return Stack(
                  children: [
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        //make it 1/2 big of height
                        heightFactor: 0.9,
                        //gen post widget
                        child:  ImageCarousel(
                  isLoadetFromWeb: true,
                  imagePaths:  pls.picPaths.map((e) => e.path).toList(),),
                    ),
                    ),
                    Positioned.fromRelativeRect(
                      rect: RelativeRect.fromLTRB(0, 50, 0, 0),
                        child: InkWell(
                          onTap: (){},
                          child: Container(
                            child: Text(""),
                            //gradient for displaying the opacity
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.black.withOpacity(0.2),
                                    AppColors.black,
                                  ],
                                )),
                          ),
                        )),
                    Positioned.fill(
                        child: Align(
                          //put the button on top of stack and align it bottom center
                            alignment: Alignment.bottomCenter,
                            child: rollEPPopen(widget.event, context)))
                  ],
                );
          });
        }
        ));
    
    
  }



  Widget rollEPPopen(Event event, BuildContext context) {
    return MaterialButton(
      onPressed: () {
      },
      child: Icon(Icons.arrow_downward_rounded),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return BlocProvider(
  //       create: (context) => EsEcEppSmalCarouselCubit(widget.event),
  //     child: BlocBuilder<EsEcEppSmalCarouselCubit, EsEcEppSmalCarouselState>(
  //       builder: (context, state){
  //
  //         return BasicContentContainer(
  //           isLoading: state is LoadingPictures,
  //           child_ren: darz.right(
  //             state.maybeMap(orElse: ()=>Spacer(), picsLoaded: (pls){
  //               return ImageCarousel(imagePaths:  pls.picPaths.map((e) => e.path).toList(),);
  //             })
  //         ),
  //         );
  //       },
  //     ),
  //
  //   );
  //   return Container();
  // }
}
