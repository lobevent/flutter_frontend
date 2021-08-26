import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_form/event_form_cubit.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String buttonText = "select Date";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(
      builder: (context, state) {
        return StdTextButton(
            child: Text(buttonText, style: TextStyle(color: AppColors.stdTextColor)),
            onPressed: () => selectDate(context).then((value) {
                  if (value != null) {
                    /// set the button string
                    buttonText = DateFormat('EEEE, MMM d, yyyy').format(value);
                    // set the state for the stateless widget
                    setState(() {});
                    /// set the date in the cubit
                    context.read<EventFormCubit>().changeDate(value);
                  }
                }));
      },
    );
  }

  Future<DateTime?> selectDate(BuildContext context) {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime.now().add(Duration(days: 365 * 10));

    //this method shows the date Picker
    return showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate);
  }
}
