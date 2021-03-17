
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/EventForm/event_form_cubit.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';


class DescriptionField extends StatefulWidget{
  const DescriptionField({
    Key key,
  }) : super(key: key);


  @override
  _DescriptionFieldState createState() => _DescriptionFieldState();

}

class _DescriptionFieldState extends State<DescriptionField> {


  @override
  Widget build(BuildContext context) {
    int lenght = EventDescription.maxLength;
    //final textEditingController = useTextEditingController();
    final textEditingController = TextEditingController();

    return BlocListener<EventFormCubit, EventFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        textEditingController.text = state.event.description.getOrCrash();
      },
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
           controller: textEditingController,
            decoration: const InputDecoration(
              labelText: 'Note',
              //counterText: '',
            ),
            maxLength: lenght,
            maxLines: null,
            minLines: 5,
            onChanged: (value) => {
             context.bloc<EventFormCubit>()..changeBody(value)}
            ,
            validator: (_) => context.bloc<EventFormCubit>().state.event.description.value
                .fold(
                  (f) => f.maybeMap(
                empty: (f) => 'Cannot be empty',
                exceedingLength: (f) => 'Exceeding length, max: ${f.maxLength}',
                orElse: () => null,
              ),
                  (r) => null,
            ),
          )),
    );
  }
}