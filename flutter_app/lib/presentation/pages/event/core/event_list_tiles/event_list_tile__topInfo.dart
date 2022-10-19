import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/core/utils/converters/date_time_converter.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/cubit/event_tile_functions_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/es_ec_UesMenuButton.dart';
import 'dart:math' as math;

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
            if (event.distance != null)
              TextWithIcon(
                  text: event.distance!.toStringAsFixed(1),
                  icon: Icons.social_distance_rounded)
            else
              const SizedBox.shrink(),
            SizedBox(
              //Todo how to fix this idk
              width: MediaQuery.of(context).size.width - 120,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(event.name.getOrCrash(),
                    style: Theme.of(context).textTheme.headline5),
              ),
            ),
            if (event.maxPersons != null)
              TextWithIcon(
                  text:
                      "${event.attendingCount ?? "?"} / ${event.maxPersons.toString()}",
                  icon: Icons.accessibility_new_rounded),
          ],
        ),
        SizedBox(height: Constants.stdSpacesBetweenContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextWithIcon(
              text: event.owner?.name.getOrEmptyString() ?? '',
              icon: Icons.location_on_outlined,
            ),
            Text(
              DateTimeConverter.convertToStringWithMonthName(event.date),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            UESButton(context),
          ],
        ),
        SizedBox(height: Constants.stdSpacesBetweenContent),
      ],
    );
  }

  Widget UESButton(BuildContext context) {
    return BlocBuilder<EventTileFunctionsCubit, EventTileFunctionsState>(
      builder: (context, state) {
        IconData uesIcon = Icons.error;
        switch (state.status) {
          case EventStatus.attending:
            uesIcon = AppIcons.attending;
            break;
          case EventStatus.notAttending:
            uesIcon = AppIcons.notAttending;
            break;
          case EventStatus.interested:
            uesIcon = AppIcons.interested;
            break;
          case null:
            break;
          case EventStatus.invited:
            uesIcon = AppIcons.invited;
            break;
          case EventStatus.confirmAttending:
            uesIcon = AppIcons.there;
            break;
        }
        return UesMenuButton(
          icon: uesIcon,
          deactivated: EventStatus.confirmAttending == state.status,
          onClickFunction: (EventStatus status) => {
            context.read<EventTileFunctionsCubit>().changeStatus(status),
            Navigator.pop(context)
          },
          isLoading: state is EventTileUESLoading,
        );
      },
    );
  }
}
