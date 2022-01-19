import 'package:auto_route/auto_route.dart' hide Router;
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/add_friends_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/like_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/add_friends/add_friends_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/like/like_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/add_friends_button.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:intl/intl.dart';

class EventContent extends StatelessWidget {
  ///the color used to display the text on this page
  final Color textColor = AppColors.stdTextColor;

  const EventContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state) {
        ///state mapping
        return state.maybeMap(
            loaded: (state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// at first the title of course
                  TitleText(state.event.name.getOrCrash()),

                  /// Used as space
                  const SizedBox(height: 20),

                  AttendingAndOwnStatus(
                      state.event.attendingCount!, state.event.status),

                  /// Used as space
                  const SizedBox(height: 20),

                  /// the date of the event
                  DateAndOwner(state.event.date, state.event.owner!, context),

                  /// Used as space
                  const SizedBox(height: 20),

                  ///likebutton and information
                  LikeWidget(state.event),

                  /// Used as space
                  const SizedBox(height: 20),

                  PostWidget(state.event, context),
                  /// Used as space
                  const SizedBox(height: 20),

                  if (state.event.isHost) AddFriendsWidget(context),

                  /// Used as space
                  const SizedBox(height: 20,),


                  /// Contains the description of the event
                  DescriptionWidget(state.event.description!.getOrCrash()),
                ],
              );
            },

            /// If some other state is active, display empty
            orElse: () => TitleText(''));
      },
    );
  }

  /// this contains the attending paritcipants and the own attending status view for this event
  Widget AttendingAndOwnStatus(int attending, EventStatus? status) {
    IconData icon;
    String text;

    switch (status) {
      case EventStatus.attending:
        icon = Icons.check;
        text = AppStrings.attending;
        break;
      case EventStatus.notAttending:
        icon = Icons.block;
        text = AppStrings.notAttending;
        break;
      case EventStatus.interested:
        icon = Icons.lightbulb;
        text = AppStrings.interested;
        break;
      default:
        icon = Icons.lightbulb;
        text = AppStrings.interested;
        break;
    }

    return PaddingWidget(
      children: [
        Icon(Icons.group),
        Text(
          AppStrings.participants + ':' + attending.toString(),
          style: TextStyle(color: textColor),
        ),
        Spacer(),
        Icon(icon),
        Text(
          text,
          style: TextStyle(color: textColor),
        )
      ],
    );
  }

  /// contains owner and the date
  Widget DateAndOwner(DateTime date, Profile profile, BuildContext context) {
    return PaddingWidget(children: [
      Icon(Icons.date_range),

      /// Format the date
      Text(
        DateFormat('EEEE, MMM d, yyyy').format(date),
        style: TextStyle(color: textColor),
      ),
      Spacer(),

      /// We want to be able to navigate to the owner of the event
      OutlinedButton(
          onPressed: () =>
              context.router.push(ProfilePageRoute(profileId: profile.id)),
          child:
              // this looks cancer, and maybe you are right
              // feel free to correct this
              // used to hide overflow
              ClipRect(
                  // overflow is alowed, so no overflowerror arises
                  child: SizedOverflowBox(
                      //the alignment of the content should be on the left side and
                      // vertical it should be centered
                      alignment: Alignment.centerLeft,
                      size: Size(MediaQuery.of(context).size.width * 0.2, 30),
                      // Row is used so the button can contain icon and text
                      child: Row(children: [
                        Icon(Icons.supervised_user_circle),
                        Text(
                          profile.name.getOrCrash(),
                          style: TextStyle(color: textColor),
                        )
                      ] // TODO: maybe change textsize dynamicaly: https://stackoverflow.com/questions/50751226/how-to-dynamically-resize-text-in-flutter
                          ))))
    ]);
  }

  /// A text widget, styled for headings
  Widget TitleText(String title) {
    return PaddingWidget(children: [
      Text(title,
          style: TextStyle(
              height: 2,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textColor))
    ]);
  }

  /// returns widget, that ist padded and expands
  Widget DescriptionWidget(String description) {
    return PaddingWidget(children: [
      // the flexible widget is used for the text wrap property, overflowing text
      // wraps to next line
      Flexible(
          child: ExpandText(
        description,
        maxLines: 3,
        style: const TextStyle(color: Color(0xFF2F1919)),
      )),
    ]);
  }

  Widget LikeWidget(Event event) {
    return PaddingWidget(children: [
      Flexible(
        child: BlocProvider(
          create: (context) => LikeCubit(event.id),
          child: LikeButton(
            key: ObjectKey(this.key),
            objectId: event.id,
            option: LikeTypeOption.Event,
            likeStatus: event.liked?? false,
          ),
        ),
      )
    ]);
  }


  Widget AddFriendsWidget(BuildContext eventCubitContext){
    return AddFriendsButton();
  }

  Widget PostWidget(Event event, BuildContext context){
    return MaterialButton(
      onPressed: () { context.router.push(PostsScreenRoute(event: event)); });
  }

  /// Widget used for making padding with a row, so the children start on the
  /// correct side and is padded from the side
  Widget PaddingWidget({required List<Widget> children}) {
    return PaddingRowWidget(children: children);
  }
}
