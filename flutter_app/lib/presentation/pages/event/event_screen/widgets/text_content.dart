
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';

class TextContent extends StatelessWidget{

  ///the color used to display the text on this page
  final Color textColor = Colors.black38;

  const TextContent({Key? key}): super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state){
        ///state mapping
        return state.maybeMap(
            loaded: (state) {
              return Column(
                children: [
                  /// at first the title of course
                  TitleText(state.event.name.getOrCrash()),

                  /// Used as space
                  Text(''),

                  /// the date of the event
                  DateView(state.event.date)


                ],
              );
            },
            /// If some other state is active, display empty
            orElse: () => TitleText(''));
      },
    );
  }




  /// A Widged used to show dates
  Widget DateView(DateTime date){
    return PaddingWidget(
        children: [
          Icon(Icons.date_range),
          Text(date.toString())
        ]);
  }


  /// A text widget, styled for headings
  Widget TitleText(String title){
    return PaddingWidget(
      children: [
          Text(title,
              style: TextStyle(
                  height: 2,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: textColor))
        ]
      );
  }

  Widget DescriptionWidget(String description){
    return PaddingWidget(children: [
      Text(description)
    ]);
  }

  /// Widget used for making padding with a row, so the children start on the
  /// correct side and is padded from the side
  Widget PaddingWidget({required List<Widget> children}){
    return Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child:  Row(
            children: children
        ));
  }



  

}