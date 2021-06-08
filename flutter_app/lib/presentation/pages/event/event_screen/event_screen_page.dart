


import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_screen.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/event_screen_description.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/header_visual.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/event_content.dart';

import '../../core/widgets/loading_overlay.dart';







class EventScreenPage extends StatelessWidget {

  final UniqueId eventId;

  const EventScreenPage({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///init the bloc provider
    return BlocProvider(
      create: (context) => EventScreenCubit(eventId),

      ///the blocbuilder is needed to determine the state class
      ///to determine what to show (errormessage, loadingoverlay or content)
      /// this part of the class therefore contains logic
      child: BlocBuilder<EventScreenCubit, EventScreenState>(
        builder: (context, state) {

          ///the loading Overlay wraps the whole tree
          return LoadingOverlay(
            isLoading: state is LoadInProgress,
            child: state.maybeMap(
                /// check if an error has occured and show error message in that case
                error: (failure) => ErrorMessage(errorText: failure.toString(),),

                /// if the error state is not active, load the content container
                orElse: () => ContentContainer()),
          );
        },
      )
    );
  }




  /// the content Container should contain no logic, but should only call the
  /// content widgets
  Widget ContentContainer(){
    return  Scaffold(
      body: ColorfulSafeArea(
        color: Colors.yellow,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              /// the Header with the pictures etc
              HeaderVisual(),
              EventContent(),
            ],
          ),
      ),
    ));
  }


}

