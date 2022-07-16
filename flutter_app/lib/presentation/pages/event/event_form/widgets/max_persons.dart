import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

class MaxPersons extends StatefulWidget {
  const MaxPersons({Key? key}) : super(key: key);

  @override
  State<MaxPersons> createState() => _MaxPersonsState();
}

class _MaxPersonsState extends State<MaxPersons> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(builder: (context, state) {
      if(!state.event.public){
        return SizedBox.shrink();
      }
      return FullWidthPaddingInput(
        padding: EdgeInsets.only(left: 50, right: 50, bottom: 10, top: 10),
        labelText: "max persons count",
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => {context.read<EventFormCubit>().changeMaxPersons(int.parse(value == "" ? '0' : value))},
        textInputType: TextInputType.numberWithOptions(decimal: true, signed: false),
        autoValidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => int.parse(value == "" ? '0' : value??'0') < 50 ? null : 'Howdy, that`s to many!',
      );
    });
  }
}
