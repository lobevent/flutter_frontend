import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_form/event_form_cubit.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:intl/intl.dart';

/// The Datepicker widget contains two buttons
/// an button for date and one for time picking
/// they are opening an datepicker and timepicker respectively
class DatePicker extends StatefulWidget {
  //TODO: Fix localization problem

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
        // if its editing, there should be a date, then
        if(state.isEditing){
          date = state.event.date;
          // set the button string
          dateButtonText = _formatDateOrTime(dateTime: date!);
          // set the button string
          timeButtonText = _formatDateOrTime(dateTime: date!, time: true);

        }
        return
        // as there are two buttons, the paddingrowwidget is the natural choice
          PaddingRowWidget(children: [
            // the date button; opens datepicker
            _DateButton(context),

            Spacer(),

            // the time button; opens time picker
            _TimeButton(context)


          ]);

      },
    );
  }

  /// the time button; opens time picker
  Widget _TimeButton(BuildContext context){
    return TextWithIconButton(
        icon: Icons.access_time,
        text: timeButtonText,
        onPressed: () => _selectTime(context).then((value) {
          if (value != null) {
            /// merge the date and the time
            if(date != null){
              date = DateTime(date!.year, date!.month, date!.day, value.hour, value.minute);
            }else{
              DateTime now = DateTime.now().toLocal();
              date = DateTime(now.year, now.month, now.day, value.hour, value.minute);
            }
            /// set the button string
            timeButtonText = _formatDateOrTime(dateTime: date!, time: true);
            // set the state for the stateless widget
            setState(() {});
            date = date!.toLocal();
            /// set the date in the cubit
            context.read<EventFormCubit>().changeDate(date!.toLocal());
          }
        }));
  }

  /// the date button; opens datepicker
  Widget _DateButton(BuildContext context){
    return TextWithIconButton(
        icon: Icons.calendar_today_outlined,
        text: dateButtonText,
        onPressed: () => _selectDate(context).then((value) {
          if (value != null) {
            /// merge the date and the time
            if(date != null){
              date = DateTime(value.year, value.month, value.day, date!.hour, date!.minute);
            }else{
              date = value;
            }

            /// set the button string
            dateButtonText = _formatDateOrTime(dateTime: date!);
            // set the state for the stateless widget
            setState(() {});

            /// set the date in the cubit
            context.read<EventFormCubit>().changeDate(date!.toLocal());
          }
        }));
  }



  String _formatDateOrTime({required DateTime dateTime, bool time = false}){
    if(time){
      return TimeOfDay.fromDateTime(dateTime).format(context);
    }else{
      return  DateFormat('EEEE, MMM d, yyyy').format(dateTime);
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) {
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


  Future<TimeOfDay?> _selectTime(BuildContext context) {
    TimeOfDay initialTime =  date != null ? TimeOfDay.fromDateTime(date!.toLocal()) : TimeOfDay.now();

    // https://api.flutter.dev/flutter/material/showTimePicker.html
    //this method shows the date Picker
    return showTimePicker(
      initialTime: initialTime,
      context: context,
    );
  }


}
