import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

class EventNameField extends StatefulWidget {
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
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        textEditingController.text = state.event.name.getOrCrash();
      },
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(labelText: "Event Name", border: OutlineInputBorder()),
            /*decoration: InputDecoration(
              filled: true,
              focusColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                if (states.contains(MaterialState.focused)) {
                  return Colors.white;
                  //Theme.of(context).colorScheme.secondary;
                }
                if (states.contains(MaterialState.error)) {
                  return Theme.of(context).colorScheme.onError;
                }
                return Theme.of(context).colorScheme.primary;
              }),
              labelText: 'Event Name',
              //counterText: '',
            ),

             */
            maxLength: EventName.maxLength,
            onChanged: (value) => {
              context.read<EventFormCubit>().changeTitle(value)
            }, // For value error validaton
            validator: (_) =>
                context.read<EventFormCubit>().state.event.name.value.fold(
                      (f) => f.maybeMap(
                        empty: (f) => 'Cannot be empty',
                        exceedingLength: (f) =>
                            'Exceeding length, max: ${f.maxLength}',
                        orElse: () => null,
                      ),
                      (r) => null,
                    ),
          )),
    );
  }
}
