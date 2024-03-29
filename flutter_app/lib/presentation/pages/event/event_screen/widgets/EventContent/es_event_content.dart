import 'package:auto_route/auto_route.dart' hide Router;
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/data/icons_with_texts.dart';
import 'package:flutter_frontend/data/icons_with_texts.dart';
import 'package:flutter_frontend/data/icons_with_texts.dart';
import 'package:flutter_frontend/data/icons_with_texts.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/add_friends_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/like_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/add_friends/add_friends_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/like/like_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/EventProfilePictures/SmallCarousel/es_ec_epp_carousel.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/es_ec_UesMenuButton.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/es_ec_add_friends_button.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/Overlays/es_ol_invited_persons.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/generic_invite_friends/gen_invite_friends_button.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../../../../application/core/geo_functions_cubit.dart';
import '../../../../../../domain/event/invitation.dart';
import '../../../../../../infrastructure/core/local/common_hive/common_hive.dart';
import '../../../../../../domain/post/post.dart';
import '../../../../core/widgets/animations/animated_check.dart';
import '../../../../core/widgets/timer_widget.dart';
import 'EventContentWidgets/EventTodoWidget/es_ec_td_todo_widget.dart';
import 'EventContentWidgets/es_ec_uploadImageButton.dart';

class EventContent extends StatelessWidget {
  ///the color used to display the text on this page

  const EventContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state) {
        ///state mapping
        return state.maybeMap(
            loaded: (stateLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// at first the title of course
                  TitleText(stateLoaded.event.name.getOrCrash(), context),

                  /// Used as space
                  const SizedBox(height: 20),

                  AttendingAndOwnStatus(
                      stateLoaded.event.attendingCount ?? 0,
                      stateLoaded.event.status,
                      context,
                      stateLoaded.loadingStatus),

                  /// Used as space
                  const SizedBox(height: 20),

                  /// the date of the event
                  DateAndOwner(stateLoaded.event.date, stateLoaded.event.owner!,
                      context),

                  /// Used as space
                  const SizedBox(height: 20),

                  /// coords of the event
                  CoordsWidget(
                      stateLoaded.event.longitude, stateLoaded.event.latitude),

                  /// timerwidget to display when party starts
                  if (stateLoaded.event.status != null ||
                      CommonHive.checkIfOwnId(
                          stateLoaded.event.owner!.id.value.toString()))
                    if (stateLoaded.event.date.isAfter(DateTime.now()))
                      TimerWidget(dateTime: stateLoaded.event.date),

                  ///for confirming the attending of an event
                  ImHereButton(
                      context,
                      stateLoaded.event.longitude,
                      stateLoaded.event.latitude,
                      stateLoaded.event,
                      stateLoaded.event.status),

                  /// todoevents list
                  TodoWidget(),

                  if (stateLoaded.event.status != null &&
                      stateLoaded.event.status == EventStatus.confirmAttending)
                    UploadImageButton(),

                  EventProfilePicturesSmallCarousell(event: stateLoaded.event),

                  /// Contains the description of the event
                  DescriptionWidget(
                      stateLoaded.event.description!.getOrCrash()),

                  /// Used as space
                  const SizedBox(height: 20),

                  ///likebutton and information
                  LikeWidget(
                      stateLoaded.event, stateLoaded.event.series, context),

                  /// Used as space
                  const SizedBox(
                    height: 20,
                  ),

                  if (stateLoaded.event.isHost) GenInviteFriendsButton<Invitation>(
                      inviteFriendsButtonType: InviteFriendsButtonType.event,
                    event: stateLoaded.event,
                  ),
                    //AddFriendsButton(),

                  /// Used as space
                  const SizedBox(height: 20),

                  PostWidget(
                      stateLoaded.event, context, stateLoaded.last2Posts),

                  /// Used as space
                  const SizedBox(height: 20),
                ],
              );
            },

            /// If some other state is active, display empty
            orElse: () => TitleText('', context));
      },
    );
  }

  /// this contains the attending paritcipants and the own attending status view for this event
  Widget AttendingAndOwnStatus(int attending, EventStatus? status,
      BuildContext context, bool isLoadingStatus) {
    IconData icon;
    String text;

    switch (status) {
      case EventStatus.attending:
        icon = IconsWithTexts.uesWithIcons[EventStatus.attending]!.values.first;
        text = IconsWithTexts.uesWithIcons[EventStatus.attending]!.keys.first;
        break;
      case EventStatus.notAttending:
        icon =
            IconsWithTexts.uesWithIcons[EventStatus.notAttending]!.values.first;
        text =
            IconsWithTexts.uesWithIcons[EventStatus.notAttending]!.keys.first;
        break;
      case EventStatus.interested:
        icon =
            IconsWithTexts.uesWithIcons[EventStatus.interested]!.values.first;
        text = IconsWithTexts.uesWithIcons[EventStatus.interested]!.keys.first;
        break;
      case EventStatus.invited:
        icon = IconsWithTexts.uesWithIcons[EventStatus.invited]!.values.first;
        text = IconsWithTexts.uesWithIcons[EventStatus.invited]!.keys.first;
        break;
      case EventStatus.confirmAttending:
        icon = IconsWithTexts
            .uesWithIcons[EventStatus.confirmAttending]!.values.first;
        text = IconsWithTexts
            .uesWithIcons[EventStatus.confirmAttending]!.keys.first;
        break;
      default:
        icon = Icons.lightbulb;
        text = AppStrings.interested;
        break;
    }

    //return TextWithIconButton(onPressed: null, text: AppStrings.participants + ':' + attending.toString());
    return PaddingWidget(
      children: [
        Icon(Icons.group),
        GestureDetector(
          child: Text(
            AppStrings.participants + ':' + attending.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onTap: () {
            InvitedPersonsOverlay.showInvitedPersonsOverlay(context);
          },
        ),
        Spacer(),
        //Icon(icon),
        UesMenuButton(
          deactivated: status == EventStatus.confirmAttending,
          icon: icon,
          text: text,
          isLoading: isLoadingStatus,
        )
        //Text(text, style: TextStyle(color: textColor))

        //TextWithIconButton(onPressed: null, text: text, icon: icon,)
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
        style: Theme.of(context).textTheme.bodyText1,
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
                          //style: TextStyle(color: textColor),
                        )
                      ] // TODO: maybe change textsize dynamicaly: https://stackoverflow.com/questions/50751226/how-to-dynamically-resize-text-in-flutter
                          ))))
    ]);
  }

  /// A text widget, styled for headings
  Widget TitleText(String title, BuildContext context) {
    return PaddingWidget(children: [
      Text(title,
          style: Theme.of(context).textTheme.headline1)
    ]);
  }

  Widget CoordsWidget(double? longitude, double? latitude) {
    return FittedBox(
      child: InkWell(
          onTap: () {
            if (latitude != null && longitude != null) {
              MapsLauncher.launchCoordinates(latitude, longitude);
            }
          },
          child: PaddingWidget(children: [
            Icon(Icons.my_location),
            Text("Latitude: ${latitude ?? 'NaN'}"),
            Text(" Longitude: ${longitude ?? 'NaN'}"),
          ])),
    );
  }

  Widget ImHereButton(BuildContext contextEvent, double? latitude,
      double? longitude, Event event, EventStatus? status) {
    //check if already confirmed attending
    if (status != null) {
      if (status != EventStatus.confirmAttending) {
        return BlocProvider(
          create: (context) => GeoFunctionsCubit(event: event),
          child: BlocBuilder<GeoFunctionsCubit, GeoFunctionsState>(
              builder: (context, state) {
            return state.maybeMap(
                loaded: (loadedState) {
                  //check if wwe display the button
                  if (loadedState.nearby == true) {
                    return TextWithIconButton(
                      onPressed: () async {
                        //send confirm at event
                        contextEvent
                            .read<EventScreenCubit>()
                            .UserConfirmAtEvent(
                                event,
                                loadedState.position.longitude,
                                loadedState.position.latitude);
                      },
                      text: "I am here!",
                    );
                  } else {
                    return const Text("Confirm when you are at the location.");
                  }
                },
                orElse: () => const Text(""));
          }),
        );
      } else {
        return Icon(Icons.local_fire_department);
      }
    } else
      return Text("");
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
        //style: const TextStyle(color: Color(0xFF2F1919)),
      )),
    ]);
  }

  Widget LikeWidget(Event event, EventSeries? series, BuildContext context) {
    return PaddingWidget(children: [
      Flexible(
        child: BlocProvider(
          create: (context) => LikeCubit(event.id),
          child: LikeButton(
            key: ObjectKey(this.key),
            objectId: event.id,
            option: LikeTypeOption.Event,
            likeStatus: event.liked ?? false,
          ),
        ),
      ),
      Spacer(),
      if (series != null)
        TextWithIconButton(
          onPressed: () => context.router
              .push(EventSeriesScreenPageRoute(seriesId: series.id)),
          text: series.name.getOrCrash(),
          icon: AppIcons.eventSeriesIcon,
        )
    ]);
  }

  Widget rollPostsOpen(Event event, BuildContext context) {
    return MaterialButton(
      onPressed: () {
        context.router.push(PostsScreenRoute(event: event));
      },
      child: Icon(Icons.arrow_downward_rounded),
    );
  }

  Widget PostWidget(
      Event event, BuildContext context, List<Post?>? last2Posts) {
    if (last2Posts != null && last2Posts.isNotEmpty) {
      //last2posts is min 1
      if (last2Posts.length > 1) {
        //build 2 paths with opacity
        return generate2PostsWithOpacity(last2Posts, event, context);
      } else {
        //build 1 post
        return generate1HalfPostWithOpacity(last2Posts.first!, event, context);
      }
    } else {
      //no posts there, so go to postsscreen button
      return MaterialButton(
        onPressed: () {
          context.router.push(PostsScreenRoute(event: event));
        },
        child: Icon(Icons.local_post_office_outlined),
      );
    }
  }

  /// Widget used for making padding with a row, so the children start on the
  /// correct side and is padded from the side
  Widget PaddingWidget({required List<Widget> children}) {
    return PaddingRowWidget(children: children);
  }

  /// widget which is 1 half of a post, also it got gradient and an postscreen button
  Widget generate1HalfPostWithOpacity(
      Post last2Posts, Event event, BuildContext context) {
    //stack so we can put some gradient over half post
    return Stack(
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            //make it 1/2 big of height
            heightFactor: 0.5,
            //gen post widget
            child: PostCommentBaseWidget(
                date: last2Posts.creationDate,
                content: last2Posts.postContent.getOrCrash(),
                images: last2Posts.images == null ? [] : last2Posts.images!,
                autor: last2Posts.owner,
                //dont need no action buttons here
                actionButtonsWidgets: Text("")),
          ),
        ),
        Positioned.fill(
            child: Container(
          child: Text(""),
          //gradient for displaying the opacity
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.black.withOpacity(0.2),
              AppColors.black,
            ],
          )),
        )),
        Positioned.fill(
            child: Align(
                //put the button on top of stack and align it bottom center
                alignment: Alignment.bottomCenter,
                child: rollPostsOpen(event, context)))
      ],
    );
  }

  /// build 1 post and 1 opacitied half post
  Widget generate2PostsWithOpacity(
      List<Post?> last2Posts, Event event, BuildContext context) {
    //clickable, we can go to postscreen
    return InkWell(
      child: Column(
        children: [
          //gen post ...
          PostCommentBaseWidget(
              date: last2Posts.first!.creationDate,
              content: last2Posts.first!.postContent.getOrCrash(),
              images: last2Posts.first!.images == null
                  ? []
                  : last2Posts.first!.images!,
              autor: last2Posts.first!.owner,
              actionButtonsWidgets: Text("")),
          //generate the half post after the 1st full post
          generate1HalfPostWithOpacity(last2Posts[1]!, event, context)
        ],
      ),
      onTap: () {
        context.router.push(PostsScreenRoute(event: event));
      },
    );
  }
}
