import 'package:flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/EventForm/event_form_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/Event/Event_Form/widgets/description_body_widged.dart';
import 'package:flutter_frontend/presentation/pages/Event/Event_Form/widgets/title_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/Widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventFormPage extends StatelessWidget {
  final Event editedEvent;

  const EventFormPage({
    Key key,
    required this.editedEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventFormCubit(),
        child: BlocConsumer<EventFormCubit, EventFormState>(
          listenWhen: (p, c) =>
              p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
          listener: (context, state) {
            state.saveFailureOrSuccessOption.fold(
              () {},
              (either) {
                either.fold( //TODO: the flashbar is only shown oncegngfh
                  (failure) {
                    FlushbarHelper.createError(
                      message: failure.map(
                        insufficientPermissions: (_) =>
                            'Insufficient permissions ❌',
                        unableToUpdate: (_) =>
                            "Couldn't update the note. Was it deleted from another device?",
                        unexpected: (_) =>
                            'Unexpected error occured, please contact support.',
                        notFound: (_) => "Not Found",
                        notAuthenticated: (_) => "Not Authenticated",
                        internalServer: (_) => "Internal Server", //TODO: localization
                      ),
                    ).show(context);
                  },
                  (_) {
                    ExtendedNavigator.of(context).popUntil(
                      (route) => route.settings.name == Routes.feedScreen,
                    );
                  },
                );
              },
            );
          },
          buildWhen: (p, c) => p.isSaving != c.isSaving,
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                const EventFormPageScaffold(),
                LoadingOverlay(isLoading: state.isSaving, text: "Saving")
              ],
            );
          },
        ));
  }
}


class EventFormPageScaffold extends StatelessWidget {
  const EventFormPageScaffold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<EventFormCubit, EventFormState>(
          buildWhen: (p, c) => p.isEditing != c.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit a Event' : 'Create a Event');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              context.bloc<EventFormCubit>().saveEvent();
            },
          )
        ],
      ),
      body: BlocBuilder<EventFormCubit, EventFormState>(
          buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
          builder: (context, state) {
            return Form(
              autovalidateMode: state.showErrorMessages? AutovalidateMode.always : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const EventNameField(),
                    const DescriptionField(),
                  ],
                ),
              ),
            );
          }),
    );
  }

}
