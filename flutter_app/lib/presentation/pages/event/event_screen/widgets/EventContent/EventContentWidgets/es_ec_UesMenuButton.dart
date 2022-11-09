import 'package:flutter/material.dart';
import 'package:flutter_frontend/data/icons_with_texts.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/loading_button.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


///
/// UserEventStatus change button, when clicked shows menu to change ues for that event
///
class UesMenuButton extends StatefulWidget {
  final IconData icon;
  final String? text;
  final bool isLoading;
  final Function(EventStatus)? onClickFunction;
  final double loadingButtonSize;
  final bool deactivated;
  const UesMenuButton({Key? key, required this.icon, this.text, required this.isLoading, this.onClickFunction,  this.loadingButtonSize=20, this.deactivated  = false}) : super(key: key);

  @override
  _UesMenuButtonState createState() => _UesMenuButtonState();
}

class _UesMenuButtonState extends State<UesMenuButton> {
  @override
  Widget build(BuildContext context) {
    final onClickFunction = widget.onClickFunction?? (EventStatus status) {
      context.read<EventScreenCubit>().changeStatus(status);
      Navigator.pop(context);
    };

    // the request is still running show this dialog
    if (widget.isLoading) {
      return LoadingButton(size: widget.loadingButtonSize,);
    }
    if(widget.deactivated){
      return Row(children: [Icon(widget.icon), if(widget.text != null) Text(widget.text??'', style: Theme.of(context).textTheme.bodyText1)]);
    }

// This menu button widget updates a _selection field (of type EventStatus,
// not shown here).
    return PopupMenuButton(
        child: Row(children: [Icon(widget.icon), if(widget.text != null) Text(widget.text??'', style: Theme.of(context).textTheme.bodyText1)]),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuWidget(
                height: 20,
                child: PaddingRowWidget(
                  paddingRight: 20,
                  paddinfLeft: 20,
                  children: [
                    TextWithIconButton(
                      onPressed: () => onClickFunction(EventStatus.attending),
                      text: '',
                      icon: IconsWithTexts.uesWithIcons[EventStatus.attending]!.values.first,
                    ),
                    Spacer(),
                    TextWithIconButton(
                        onPressed: () => onClickFunction(EventStatus.interested),
                        text: '',
                        icon: IconsWithTexts.uesWithIcons[EventStatus.interested]!.values.first),
                    Spacer(),
                    TextWithIconButton(
                        onPressed: () => onClickFunction(EventStatus.notAttending),
                        text: '',
                        icon: IconsWithTexts.uesWithIcons[EventStatus.notAttending]!.values.first),
                  ],
                ))
          ];
        });
  }
}

class PopupMenuWidget<T> extends PopupMenuEntry<T> {
  const PopupMenuWidget({Key? key, required this.height, required this.child}) : super(key: key);

  @override
  final Widget child;

  @override
  final double height;

  @override
  bool get enabled => false;

  @override
  _PopupMenuWidgetState createState() => new _PopupMenuWidgetState();

  @override
  bool represents(T? value) {
    // TODO: implement represents
    throw UnimplementedError();
  }
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) => widget.child;
}
