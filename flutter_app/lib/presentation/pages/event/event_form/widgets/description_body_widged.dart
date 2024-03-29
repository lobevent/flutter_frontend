import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

class DescriptionField extends StatefulWidget {
  const DescriptionField({
    Key? key,
  }) : super(key: key);

  @override
  _DescriptionFieldState createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  @override
  Widget build(BuildContext context) {
    //final textEditingController = useTextEditingController();
    final textEditingController = TextEditingController();

    return BlocListener<EventFormCubit, EventFormState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        textEditingController.text = state.event.description!.getOrCrash();
      },
      child: Padding(
          padding: const EdgeInsets.all(
              10), //TODO: the textfield does not count emojis. we need to fix that
          child: TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Event description',
              //counterText: '',
            ),

            maxLength: EventDescription.maxLength - 1,
            maxLines: null,
            minLines: 5,
            onChanged: (value) =>
                {context.read<EventFormCubit>().changeBody(value)},
            validator: (_) => context
                .read<EventFormCubit>()
                .state
                .event
                .description!
                .value
                .fold(
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
