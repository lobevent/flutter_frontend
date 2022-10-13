import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/presentation/core/style.dart';

class TimerWidget extends StatefulWidget {
  final DateTime dateTime;

  const TimerWidget({Key? key, required this.dateTime}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerState();
}

class _TimerState extends State<TimerWidget> {
  final DateTime dateTimeNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(
        duration:
            Duration(hours: widget.dateTime.difference(dateTimeNow).inHours),
        tween: Tween(
            begin: Duration(
                hours: widget.dateTime.difference(dateTimeNow).inHours),
            end: Duration.zero),
        onEnd: () {
          print('Party starts!');
        },
        builder: (BuildContext context, Duration value, Widget? child) {
          final days = value.inDays;
          final hours = value.inHours % 24;
          final minutes = value.inMinutes % 60;
          final seconds = value.inSeconds % 60;
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text('$days:$hours:$minutes:$seconds',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)));
        });
  }
}
