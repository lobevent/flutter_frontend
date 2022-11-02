import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/like/like_cubit.dart';

import 'animations/loading_button.dart';
import 'animations/palk_animation.dart';

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
        state.maybeMap(
            loaded: (state) {
              this.likeStatus = state.likeStatus;
              setState(() {});
            },
            orElse: () => {});
      },
      child: BlocBuilder<LikeCubit, LikeState>(
        builder: (context, state) {
          //return the likebutton only if it fetched the status from backend
          return state.maybeMap(
              loading: (loading) {
                return PalkAnimation(
                  size: 30,
                );
              },
              loaded: (state) {
                return OutlinedButton(
                    onPressed: () {
                      //call the backend
                      context.read<LikeCubit>().unOrlike(
                          widget.objectId, widget.option, state.likeStatus);
                    },
                    //icon liked or not liked?
                    child: state.likeStatus == true
                        ? const Icon(Icons.thumb_up_alt)
                        : const Icon(Icons.thumb_up_alt_outlined));
              },
              error: (err) {
                return ErrorWidget(err);
              },
              orElse: () => Icon(Icons.local_airport_outlined));
        },
      ),
    );
  }
}
