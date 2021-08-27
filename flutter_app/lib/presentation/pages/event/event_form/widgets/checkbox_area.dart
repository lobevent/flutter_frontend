import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_form/event_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

class CheckBoxArea extends StatefulWidget{

  const CheckBoxArea({Key? key}): super(key: key);

  _CheckBoxAreaState createState() => _CheckBoxAreaState();


}

class _CheckBoxAreaState extends State<CheckBoxArea>{
  bool isPublic = false;
  bool visibleWithoutLogin = false;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(builder: (context, state) {
      if(state.isEditing){
        isPublic = state.event.public;
        visibleWithoutLogin = false;
      }
      return PaddingRowWidget(children: [
        TextCheckbox(
            text: "public?   ",
            value: isPublic,
            onChanged: (bool? value) {
              context.read<EventFormCubit>().changePublic(value!);
              isPublic = value;
              setState(() {});
            }),
      ]);
    });
  }

}