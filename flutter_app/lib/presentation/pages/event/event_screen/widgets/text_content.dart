
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';

class TextContent extends StatelessWidget{

  const TextContent({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state){
        return state.maybeMap(
            loaded: (state) {
              return Column(
                children: [
                  TitleText(state.event.name.getOrCrash())
                ],
              );
            },
            orElse: () => throw FallThroughError());
      },
    );
  }




  Widget TitleText(String title){
    return Text(title, style: const TextStyle(height: 5, fontSize: 10));
  }


}