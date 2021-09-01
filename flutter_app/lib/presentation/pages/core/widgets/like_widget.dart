import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/like/like_cubit.dart';
import 'package:flutter_frontend/application/post_comment/comment_screen/comment_screen_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';

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
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool likeStatus = false;

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
          return buildLikeWithStatus();
        },
      ),
    );
  }

  IconButton buildLikeWithStatus() {
    if (this.likeStatus) {
      return IconButton(
          onPressed: () {
            context.read<LikeCubit>().unlike(widget.objectId, widget.option);
          },
          icon: Icon(Icons.map));
    } else {
      return IconButton(
          onPressed: () {
            context.read<LikeCubit>().like(widget.objectId, widget.option);
          },
          icon: Icon(Icons.ac_unit));
    }
  }
}
