import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventContent extends StatelessWidget{

  ///the color used to display the text on this page
  final Color textColor = Colors.black38;

  const EventContent({Key? key}): super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state){
        ///state mapping
        return state.maybeMap(
            loaded: (state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// at first the title of course
                  TitleText(state.event.name.getOrCrash()),

                  /// Used as space
                  const SizedBox(height: 20),

                  /// the date of the event
                  MetaView(state.event.date, state.event.owner, context),


                  /// Used as space
                  const SizedBox(height: 20),

                  /// Contains the description of the event
                  DescriptionWidget(state.event.description.getOrCrash()),



                ],
              );
            },
            /// If some other state is active, display empty
            orElse: () => TitleText(''));
      },
    );
  }




  /// contains different metadata for the event, like owner or the date
  Widget MetaView(DateTime date, Profile profile, BuildContext context){
    return PaddingWidget(
        children: [
          Icon(Icons.date_range),
          /// Format the date
          Text(DateFormat('EEEE, MMM d, yyyy').format(date), style: TextStyle(color: textColor),),
          Spacer(),
          /// We want to be able to navigate to the owner of the event
          OutlinedButton(
              onPressed: ()=>context.router.push(ProfilePageRoute(
                profileId: profile.id
              )),
          child:
                // this looks cancer, and maybe you are right
                // feel free to correct this
          // used to hide overflow
            ClipRect(
              // overflow is alowed, so no overflowerror arises
              child: SizedOverflowBox(
                //the alignment of the content should be on the left side and
                // vertical it should be centered
                alignment: Alignment.centerLeft,
                size: Size(MediaQuery.of(context).size.width*0.2, 30),
                // Row is used so the button can contain icon and text
                child: Row(children: [
                    Icon(Icons.supervised_user_circle),
                    Text(profile.name.getOrCrash() , style:  TextStyle(color: textColor),)]
                )))
          )
        ]);
  }


  /// A text widget, styled for headings
  Widget TitleText(String title){
    return PaddingWidget(
      children: [
          Text(title, style: TextStyle(height: 2, fontSize: 30,
              fontWeight: FontWeight.bold, color: textColor))
        ]
      );
  }

  Widget DescriptionWidget(String description){
    return PaddingWidget(children: [
      /// the flexible widget is used for the text wrap property, overflowing text
      /// wraps to next line
      Flexible(child: Text(description)),
    ]);
  }

  /// Widget used for making padding with a row, so the children start on the
  /// correct side and is padded from the side
  Widget PaddingWidget({required List<Widget> children}){
    return Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Row(children: children),
        );
  }





  

}