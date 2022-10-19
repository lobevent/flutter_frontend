import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/utils/converters/date_time_converter.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/cubit/event_tile_functions_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tile__topInfo.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles__topImage.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../../../infrastructure/core/local/common_hive/common_hive.dart';
import '../../../core/widgets/styling_widgets.dart';

class EventListTiles extends StatefulWidget {
  final Event event;
  final Function(Event event)? onDeletion;
  final bool isInvitation;
  final EventStatus? eventStatus;

  const EventListTiles(
      {required ObjectKey key,
      required this.event,
      this.onDeletion,
      this.isInvitation = false,
      this.eventStatus})
      : super(key: key);

  @override
  State<EventListTiles> createState() => _EventListTilesState();
}

class _EventListTilesState extends State<EventListTiles> {
  bool vilibility = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventTileFunctionsCubit(widget.event),
        child: BlocConsumer<EventTileFunctionsCubit, EventTileFunctionsState>(
          listener: (context, state) {
            if (state is EventTileDeletionSuccess) {
              setState(() {
                vilibility = false;
              });
            }
          },
          builder: (context, state) => Visibility(
            visible: vilibility,
            child: Card(
                child: Column(children: [
              TopInfo(event: widget.event),
              TopImage(event: widget.event),
              if (widget.event.isHost)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.event.isHost
                      ? actionButtons(
                          CommonHive.checkIfOwnId(
                              widget.event.owner?.id.value ?? ""),
                          context)
                      : [],
                ),
              Row(
                children: [],
              )
            ])),
          ),
        ));
  }

  /// action buttons for the event, can be made invisible, if its not own events
  List<Widget> actionButtons(bool visible, BuildContext context) {
    Icon uesIcon = Icon(Icons.error);
    if (widget.isInvitation) {
      switch (widget.eventStatus) {
        case EventStatus.attending:
          uesIcon = Icon(Icons.check);
          break;
        case EventStatus.notAttending:
          uesIcon = Icon(Icons.clear);
          break;
        case EventStatus.interested:
          uesIcon = Icon(Icons.lightbulb);
          break;
        case null:
          break;
        case EventStatus.invited:
          uesIcon = Icon(Icons.lightbulb);
          break;
        case EventStatus.confirmAttending:
          // TODO: Handle this case.
          break;
      }
      return <Widget>[
        IconButton(icon: uesIcon, onPressed: () => {}),
      ];
    }
    if (visible) {
      return <Widget>[
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              GenDialog.genericDialog(
                      context,
                      AppStrings.deleteEventDialogTitle,
                      AppStrings.deleteEventDialogText,
                      AppStrings.deleteEventDialogConfirm,
                      AppStrings.deleteEventDialogAbort)
                  .then((value) async => {
                        if (value)
                          {
                            if (widget.onDeletion != null)
                              {widget.onDeletion!(widget.event)}
                            else
                              {
                                context
                                    .read<EventTileFunctionsCubit>()
                                    .deleteEvent(widget.event)
                              }
                          }
                        else
                          {print("abort delete")}
                      });
            }),
        IconButton(
            icon: Icon(Icons.edit), onPressed: () => {editEvent(context)}),
      ];
    }
    return <Widget>[];
  }

  void editEvent(BuildContext context) {
    context.router
        .push(EventFormPageRoute(editedEventId: widget.event.id.value));
  }
}
