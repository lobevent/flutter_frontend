import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/like/like_cubit.dart';

class LikeButton extends StatefulWidget {
  final UniqueId objectId;
  final LikeTypeOption option;
  final bool likeStatus;

  const LikeButton(
      {Key? key,
      required this.objectId,
      required this.option,
      required this.likeStatus})
      : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState(likeStatus);
}

class _LikeButtonState extends State<LikeButton> {
  bool likeStatus = false;
  List<Profile> profilesWhichLiked = [];
  _LikeButtonState(bool likeStatus) : likeStatus = likeStatus;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LikeCubit, LikeState>(
      listener: (context, state) {
        state.maybeMap((value) => {},
            loaded: (state) {
              this.likeStatus = state.likeStatus;
              setState(() {});
            },
            orElse: () => {});
      },
      child: BlocBuilder<LikeCubit, LikeState>(
        builder: (context, state) {
          //return the likebutton only if it fetched the status from backend
          return state.maybeMap((value) => (Text("")),
              loaded: (state) {
                return buildLikeWithStatus();
              },
              orElse: () => buildLikeWithStatus());
        },
      ),
    );
  }

  //just
  void changeLikeStatus() {
    setState(() {
      likeStatus = !likeStatus;
    });
  }

  ///decide if the icon for liking or unliking is shown
  Icon decideIcon(bool likeStatus) {
    if (likeStatus) {
      return Icon(Icons.airplanemode_active_sharp);
    } else {
      return Icon(Icons.airplanemode_inactive_sharp);
    }
  }

  ///build the likebutton, fetch if user liked it and change Icon and likestatus if user presses the button
  Widget buildLikeWithStatus() {
    return StdTextButton(
        onPressed: () {
          //call the backend
          context
              .read<LikeCubit>()
              .unOrlike(widget.objectId, widget.option, likeStatus);
          //change the bool likestatus
          changeLikeStatus();
        },
        //icon liked or not liked?
        child: decideIcon(likeStatus));
  }
}
