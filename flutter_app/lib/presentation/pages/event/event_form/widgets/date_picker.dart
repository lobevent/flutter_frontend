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
  String dateButtonText = "select Date";
  String timeButtonText = "select Time";
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(
      builder: (context, state) {
        if(state.isEditing){
          date = state.event.date;
          /// set the button string
          dateButtonText = formatDateOrTime(dateTime: date!);
          /// set the button string
          timeButtonText = formatDateOrTime(dateTime: date!, time: true);

        }
        return
          PaddingRowWidget(children: [
            StdTextButton(
                child: Text(dateButtonText, style: TextStyle(color: AppColors.stdTextColor)),
                onPressed: () => selectDate(context).then((value) {
                  if (value != null) {
                    /// merge the date and the time
                    if(date != null){
                      date = DateTime(value.year, value.month, value.day, date!.hour, date!.minute);
                    }else{
                      date = value;
                    }

                    /// set the button string
                    dateButtonText = formatDateOrTime(dateTime: date!);
                    // set the state for the stateless widget
                    setState(() {});

                    /// set the date in the cubit
                    context.read<EventFormCubit>().changeDate(date!);
                  }
                })),
            Spacer(),

            StdTextButton(
                child: Text(timeButtonText, style: TextStyle(color: AppColors.stdTextColor)),
                onPressed: () => selectTime(context).then((value) {
                  if (value != null) {
                    /// merge the date and the time
                    if(date != null){
                      date = DateTime(date!.year, date!.month, date!.day, value.hour, value.minute);
                    }else{
                      DateTime now = DateTime.now();
                      date = DateTime(now.year, now.month, now.day, value.hour, value.minute);
                    }
                    /// set the button string
                    timeButtonText = formatDateOrTime(dateTime: date!, time: true);
                    // set the state for the stateless widget
                    setState(() {});

                    /// set the date in the cubit
                    context.read<EventFormCubit>().changeDate(date!);
                  }
                }))


          ]);

      },
    );
  }

  String formatDateOrTime({required DateTime dateTime, bool time = false}){
    if(time){
      return TimeOfDay.fromDateTime(dateTime).format(context);
    }else{
      return  DateFormat('EEEE, MMM d, yyyy').format(dateTime);
    }
  }

  Future<DateTime?> selectDate(BuildContext context) {
    DateTime initialDate = date != null ? date! : DateTime.now();
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime.now().add(Duration(days: 365 * 10));



    // https://api.flutter.dev/flutter/material/showDatePicker.html
    //this method shows the date Picker
    return showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate);
  }


  Future<TimeOfDay?> selectTime(BuildContext context) {
    TimeOfDay initialTime =  date != null ? TimeOfDay.fromDateTime(date!) : TimeOfDay.now();

    // https://api.flutter.dev/flutter/material/showTimePicker.html
    //this method shows the date Picker
    return showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }


}
