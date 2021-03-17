
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/EventForm/event_form_cubit.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return BlocListener<EventFormCubit, EventFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        textEditingController.text = state.note.body.getOrCrash();
      },
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(
              labelText: 'Note',
              counterText: '',
            ),
            maxLength: NoteBody.maxLength,
            maxLines: null,
            minLines: 5,
            onChanged: (value) => context
                .bloc<NoteFormBloc>()
                .add(NoteFormEvent.bodyChanged(value)),
            validator: (_) => context.bloc<NoteFormBloc>().state.note.body.value
                .fold(
                  (f) => f.maybeMap(
                empty: (f) => 'Cannot be empty',
                exceedingLength: (f) => 'Exceeding length, max: ${f.max}',
                orElse: () => null,
              ),
                  (r) => null,
            ),
          )),
    );
  }
}