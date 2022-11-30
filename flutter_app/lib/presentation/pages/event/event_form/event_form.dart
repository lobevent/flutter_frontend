//import 'package:flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/event_form_container.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import 'cubit/event_form_cubit.dart';

class EventFormPage extends StatefulWidget {
  final String? editedEventId;
  final DateTime? selectedCalenderDate;

  const EventFormPage({
    Key? key,
    this.editedEventId,
    this.selectedCalenderDate,
  }) : super(key: key);


  static EventFormPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<EventFormPageState>();

  @override
  State<EventFormPage> createState() => EventFormPageState();
}


class EventFormPageState extends State<EventFormPage> {

  bool _canSubmit = false;
  set canSubmit(bool value) => setState(() => _canSubmit = value);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventFormCubit(optionOf(widget.editedEventId)),
        child: BlocConsumer<EventFormCubit, EventFormState>(
          //listener: (context, state) {},
          listenWhen: (p, c) =>
              p.status == MainStatus.saving && c.status != MainStatus.saving,
          listener: (context, state) {
            successAndErrorHandler(state, context);
          },
          //buildWhen: (p, c) => p.isSaving != c.isSaving /*|| p.isLoading != c.isLoading*/,

          builder: (context, state) {
            // generate the heading
            String text = state.isEditing ? "Saving" : "Loading";
            return BasicContentContainer(
              isLoading: state.status == MainStatus.loading || state.status == MainStatus.saving,
              // its scrollable, because the form might get big
              scrollable: false,

              /// add a sticky bottom navigation
              bottomNavigationBar: BottomNavigation(context),

              child_ren: left([
                /// Title text for this page
                Text(state.isEditing ? 'Edit a Event' : 'Create a Event'),

                /// the form which contains all the inputs
                /// because the inputs have to be wrapped in a Form to function
                /// properly
                EventFormContainer(
                  event: state.event,
                  isEditing: state.isEditing,
                  showErrorMessages: state.showErrorMessages,
                  selectedCalenderDate: widget.selectedCalenderDate,
                ),
              ]),
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
          tooltip: !_canSubmit ? AppStrings.submitButtonToolTip : null,
          color: Theme.of(context).colorScheme.secondary,
          onPressed: _canSubmit ? () => context.read<EventFormCubit>().submit(): null
      )
    ]);
  }

  void successAndErrorHandler(EventFormState state, BuildContext context) {
    if(state.status == MainStatus.formHasErrors){
      //throw UnimplementedError();
    }
    if(state.status == MainStatus.saved){
      context.router.popUntil(
            (route) => route.settings.name == FeedScreenRoute.name,
      );
    }
    if(state.status == MainStatus.error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(NetWorkFailure.getDisplayStringFromFailure(state.eventFailure!))));
    }
  }
}
