import 'package:flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/EventForm/event_form_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventFormPage extends StatelessWidget{
  final Event editedEvent;


  const EventFormPage({
    Key key,
    @required this.editedEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    BlocProvider(create:
    (context) => EventFormCubit(),
    child: BlocConsumer<EventFormCubit, EventFormState>(
        listenWhen: (p, c) =>
        p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
                () {},
                (either) {
              either.fold(
                    (failure) {
                  FlushbarHelper.createError(
                    message: failure.map(
                      insufficientPermissions: (_) =>
                      'Insufficient permissions ❌',
                      unableToUpdate: (_) =>
                      "Couldn't update the note. Was it deleted from another device?",
                      unexpected: (_) =>
                      'Unexpected error occured, please contact support.',
                      notFound: (_) => "dd",
                      notAuthenticated: (_) => "dd",
                      internalServer: (_) => "dd", //TODO: localization
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
              SavingInProgressOverlay(isSaving: state.isSaving)
            ],
          );
        },
    )
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;

  const SavingInProgressOverlay({
    Key key,
    @required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                'Saving',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              context.read()<EventFormCubit>().saveEvent();
            },
          )
        ],
      ),
    body: BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
    builder: (context, state) {
    return ChangeNotifierProvider(
    create: (_) => FormTodos(),
    child: Form(
    autovalidate: state.showErrorMessages,
    child: SingleChildScrollView(
    child: Column(
    children: [
    const BodyField(),
    const ColorField(),
    const TodoList(),
    const AddTodoTile(),
    ],
    ),
    ),
    );
  }

  // @override
  //  Widget build(BuildContext context) {
  //    return Scaffold(
  //        appBar: AppBar(
  //          title: Text("Add Event"),
  //        ),
  //        body: Form(
  //            child: Column(
  //              children: [
  //
  //              ],
  //          ),
  //        )
  //    );
  //  }
}