//import 'package:flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/event_form_container.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import 'cubit/event_form_cubit.dart';

class EventFormPage extends StatelessWidget {
  final String? editedEventId;

  const EventFormPage({
    Key? key,
    this.editedEventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventFormCubit(optionOf(editedEventId)),
        child: BlocConsumer<EventFormCubit, EventFormState>(
          //listener: (context, state) {},
          listenWhen: (p, c) =>
              p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
          listener: (context, state) {
            successAndErrorHandler(state, context);
          },
          //buildWhen: (p, c) => p.isSaving != c.isSaving /*|| p.isLoading != c.isLoading*/,

          builder: (context, state) {
            // generate the heading
            String text = state.isSaving ? "Saving" : "Loading";
            return LoadingOverlay(
              // controll the overlay
              isLoading: state.isSaving || state.isLoading,
              // set the custom loading text
              text: text,

              // the basic container, as everywhere
              child: BasicContentContainer(
                // its scrollable, because the form might get big
                scrollable: true,

                /// add a sticky bottom navigation
                bottomNavigationBar: BottomNavigation(context),

                children: [
                  /// Title text for this page
                  Text(state.isEditing ? 'Edit a Event' : 'Create a Event'),

                  /// the form which contains all the inputs
                  /// because the inputs have to be wrapped in a Form to function
                  /// properly
                  EventFormContainer(
                    showErrorMessages: state.showErrorMessages,
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget BottomNavigation(BuildContext context) {
    return PaddingRowWidget(children: [
      IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.router.pop();
          }),
      Spacer(),
      IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            context.read<EventFormCubit>().submit();
          })
    ]);
  }

  void successAndErrorHandler(state, BuildContext context) {
    state.saveFailureOrSuccessOption.fold(
      () {},
      (either) {
        either.fold(
          (failure) {
            //TODO: ADD flushbar
          },
          (_) {
            context.router.popUntil(
              (route) => route.settings.name == FeedScreenRoute.name,
            );
          },
        );
      },
    );
  }
}
