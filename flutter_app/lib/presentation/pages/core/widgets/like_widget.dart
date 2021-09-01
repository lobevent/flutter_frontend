import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/like/like_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

class LikeButton extends StatelessWidget {
  final UniqueId objectId;
  final LikeTypeOption? option;
  final bool? likeStatus;

  const LikeButton(
      {required ObjectKey key,
        required this.objectId,
        LikeTypeOption? this.option,
        bool? this.likeStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikeCubit,LikeState>(
      builder: (context, state){
        /*return IconButton(
            onPressed: (){
              context.read<LikeCubit>().like(objectId, option!);
            }, icon: const Icon(Icons.radio_button_unchecked_rounded));

         */
        if(likeStatus!){
          return IconButton(
              onPressed: (){
                context.read<LikeCubit>().like(objectId, option!);
              },
              icon: Icon(Icons.map));
        }else{
          return IconButton(onPressed: null, icon: Icon(Icons.ac_unit));
        }
      },
    );
  }

  IconButton buildLikeWithStatus(BuildContext context){
    if(likeStatus!){
      return IconButton(
          onPressed: (){
            context.read<LikeCubit>().like(objectId, option!);
            },
          icon: Icon(Icons.map));
    }else{
      return IconButton(onPressed: null, icon: Icon(Icons.ac_unit));
    }
  }
}
