import 'package:flutter/material.dart';
import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/presentation/core/utils/converters/date_time_converter.dart';

import '../../../../../domain/event/event.dart';
import '../../../core/widgets/styling_widgets.dart';

class TopInfo extends StatelessWidget {
  final Event event;
  const TopInfo({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: Constants.stdSpacesBetweenContent),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                      event.name.getOrCrash(), style: Theme.of(context).textTheme.headline5),
                ),
              )
            ],),
          SizedBox(height: Constants.stdSpacesBetweenContent),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextWithIcon(
                text: event.owner?.name.getOrEmptyString() ?? '',
                icon: Icons.location_on_outlined,
              ),
              Text(DateTimeConverter.convertToStringWithMonthName(event.date), style: TextStyle(fontWeight: FontWeight.bold),)
            ],),
          SizedBox(height: Constants.stdSpacesBetweenContent),
        ],

      );
  }
}
