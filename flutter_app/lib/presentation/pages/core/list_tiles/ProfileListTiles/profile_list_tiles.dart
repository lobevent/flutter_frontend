import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/list_tiles/ProfileListTiles/profile_tile_cubit/profile_list_tile_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:get_it/get_it.dart';

class ProfileListTiles extends StatelessWidget {
  final Profile profile;

  //accept/send friendrequest
  @Deprecated("has own cubit now")
  final Function(Profile profile)? onFriendRequest;

  //decline/delete friendrequest
  @Deprecated("has own cubit now")
  final Function(Profile profile)? onDeleteFriend;

  final bool hideActions;

  //profile list tiles for searching profiles
  const ProfileListTiles({required ObjectKey key,
    required this.profile,
    this.onDeleteFriend,
    this.onFriendRequest, this.hideActions = true})
      : super(key: key);

  //card for the friendlisttile with the actionbuttons
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProfileListTileCubit(profile),
        child: BlocConsumer<ProfileListTileCubit, ProfileListTileState>(
          listener: (context, state) {
            if(state.status == PLTStatus.error && state.failure!= null){
              // show snackbar on error
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(NetWorkFailure.getDisplayStringFromFailure(state.failure!))));
            }
          },
          builder: (context, state) => Card(
            color: state.status == PLTStatus.deleting ? AppColors.deletionOngoingColor : (state.status == PLTStatus.updating ? AppColors.textOnAccentColor :null),
              child: ListTile(
                leading: IconButton(
                  //load the avatar
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundImage: ProfileImage.getAssetOrNetworkFromProfile(profile),
                  ),
                  onPressed: () => showProfile(context),
                ),
                title: Text(profile.name.getOrCrash()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(hideActions)
                      actionButtonsLegacy(
                          onFriendRequest != null, onDeleteFriend != null, context),
                    if(!hideActions)
                      newActionButtons()
                  ],
                ),
              )),
        ));
  }

  /// new actionbuttonscontainer
  /// generates variety of actionbuttons
  /// normaly there should be only one button active at a time
  /// uses [ProfileListTileCubit] and the profile in the state, to determine what buttons to show
  Widget newActionButtons() {
    return BlocBuilder<ProfileListTileCubit, ProfileListTileState>(
      builder: (context, state) {
        if (CommonHive.checkIfOwnId(profile.id.value)) {
          return Text("Me");
        }
        return PaddingRowWidget(
          paddinfLeft: 5,
          paddingRight: 5,
          children: [
            //button for sending a friendship
            if(state.profile.friendShipStatus == FriendShipStatus.noFriendStatus)
              IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    context.read<ProfileListTileCubit>().sendFriendship(profile.id);
                  }),
            _acceptFriendShipButton(context, state),
            _removeFriendRequestButton(context, state),
            //button for deleting a friendship, opens a showdialog for submitting
            if(state.profile.isFriend ?? false)
              _deleteFriendButton(context, context
                  .read<ProfileListTileCubit>()
                  .deleteFriendship)
          ],
        );
      },
    );
  }


  /// generates Friendshipaccept button, if the profile send the user an request
  /// [state] is used to determine if the thats the case over [friendshipstatus]
  /// is hidden if the conditions arent met
  Widget _acceptFriendShipButton(BuildContext context, ProfileListTileState state) {
    return Visibility(
      visible: state.profile.friendShipStatus == FriendShipStatus.theySend,
      child: IconButton(
          icon: Icon(Icons.check_circle_outline_outlined),
          onPressed: () {
            context.read<ProfileListTileCubit>().sendFriendship(profile.id);
          }),
    );
  }

  /// generates Friendshipdelete button, if the user send the profile an request
  /// [state] is used to determine if the thats the case over [friendshipstatus]
  /// is hidden if the conditions arent met, shows dialog
  Widget _removeFriendRequestButton(BuildContext context, ProfileListTileState state) {
    return Visibility(
      visible: state.profile.friendShipStatus == FriendShipStatus.iSend,
      child: IconButton(
          icon: Icon(Icons.stop_circle_outlined),
          onPressed: () {
            GenDialog.genericDialog(
                context,
                AppStrings.deleteFriendDialogTitle,
                AppStrings.stopFriendRequestDialogText,
                AppStrings.stopFriendRequestDialogConfirm,
                AppStrings.stopFriendRequestDialogAbort)
                .then((value) async =>
            {
              if (value)
                context.read<ProfileListTileCubit>().removeFriendRequest(profile.id)
              else
                print("abort delete Friend"),
            });
          }),
    );
  }


  //build the send friendrequest buttons
  Widget actionButtonsLegacy(bool acceptOrSend, bool deleteOrDeny, BuildContext context) {
    //only build friend buttons if its not our own profile
    if (CommonHive.checkIfOwnId(profile.id.value)) {
      return Text("Me");
    }
    //for building both buttons to accept or decline the friendrequest
    if (acceptOrSend && deleteOrDeny) {
      return PaddingRowWidget(
        paddinfLeft: 5,
        paddingRight: 5,
        children: [
          //button for sending a friendship
          IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                onFriendRequest!(profile);
              }),
          //button for deleting a friendship, opens a showdialog for submitting
          _deleteFriendButton(context, onDeleteFriend)
        ],
      );
      //this is for building the delete or decline friend/request buttons
    } else if (!acceptOrSend && deleteOrDeny) {
      return _deleteFriendButton(context, onDeleteFriend);
      //only build the send friendrequest button
    } else if (!deleteOrDeny && acceptOrSend) {
      return IconButton(
          icon: Icon(Icons.person_add_alt_1_rounded),
          onPressed: () {
            onFriendRequest!(profile);
          });
    }
    return Text("");
  }


  /// generates delete Friends button
  /// it takes [onDeleteFriend], which is a function,
  /// that is executed if the the user confirms the deletion
  Widget _deleteFriendButton(BuildContext context, Function(Profile profile)? onDeleteFriend) {
    return IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () {
          GenDialog.genericDialog(
              context,
              AppStrings.deleteFriendDialogTitle,
              AppStrings.deleteFriendDialogText,
              AppStrings.deleteFriendDialogConfirm,
              AppStrings.deleteFriendDialogAbort)
              .then((value) async =>
          {
            if (value)
              onDeleteFriend!(profile)
            else
              print("abort delete Friend"),
          });
        });
  }

  /// opens profile route
  void showProfile(BuildContext context) {
    context.router.push(ProfilePageRoute(profileId: profile.id));
  }
}
