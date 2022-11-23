import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

class CheckBoxArea extends StatefulWidget {
  const CheckBoxArea({Key? key}) : super(key: key);

  _CheckBoxAreaState createState() => _CheckBoxAreaState();
}

class _CheckBoxAreaState extends State<CheckBoxArea> {
  bool isPublic = false;
  bool visibleWithoutLogin = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(
        builder: (context, state) {
      if (state.isEditing) {
        isPublic = state.event.public;
        visibleWithoutLogin = state.event.visibleWithoutLogin;
      }
      return Row(
          children: [
            //the checkboxes with the buttons
            _PublicCheckbox(context),
            Spacer(),
            _visibleWitoutLoginCheckbox(context)
          ]);
    });
  }

  /// the checkbox for checking the public status of the event
  Widget _PublicCheckbox(BuildContext context) {
    return TextCheckbox(
        text: "${AppStrings.publicEvent}?   ",
        value: isPublic,
        onChanged: (bool? value) {
          if (value != null) {
            context.read<EventFormCubit>().changePublic(value);
            isPublic = value;
            setState(() {});
          }
        });
  }

  /// the checkbox for checking the visiblity of the event when the user isnt logged in
  Widget _visibleWitoutLoginCheckbox(BuildContext context) {
    return TextCheckbox(
        text: "${AppStrings.visibleWithoutLoginEvent}?   ",
        value: visibleWithoutLogin,
        onChanged: (bool? value) {
          if (value != null) {
            context.read<EventFormCubit>().changeVisibleWithoutLogin(value);
            visibleWithoutLogin = value;
            setState(() {});
          }
        });
  }
}
