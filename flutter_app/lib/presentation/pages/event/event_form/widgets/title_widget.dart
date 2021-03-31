
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_form/event_form_cubit.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';


class EventNameField extends StatefulWidget{
  const EventNameField({
    Key? key,
  }) : super(key: key);


  @override
  _EventNameFieldState createState() => _EventNameFieldState();

}

class _EventNameFieldState extends State<EventNameField> {


  @override
  Widget build(BuildContext context) {
    //final textEditingController = useTextEditingController();
    final textEditingController = TextEditingController();

    return BlocListener<EventFormCubit, EventFormState>(
      listenWhen: (p, c) => p.isLoading != c.isLoading,
      listener: (context, state) {
        textEditingController.text = state.event.name.getOrCrash();
      },
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              //counterText: '',
            ),
            maxLength: EventName.maxLength,
            maxLines: 1,
            onChanged: (value) => {
              context.read<EventFormCubit>().changeTitle(value)} // For value error validaton
            ,
            validator: (_) => context.read<EventFormCubit>().state.event.name.value
                .fold(
                  (f) => f.maybeMap(
                empty: (f) => 'Cannot be empty',
                exceedingLength: (f) => 'Exceeding length, max: ${f.maxLength}',
                orElse: () => "",
              ),
                  (r) => "",
            ),
          )),
    );
  }
}