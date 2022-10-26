import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_frontend/domain/event/event.dart';
import 'package:image_picker/image_picker.dart';

part 'post_widget_cubit.g.dart';

part 'post_widget_state.dart';

class PostWidgetCubit extends Cubit<PostWidgetState> {
  final Post post;
  final Event? event;
  final PostRepository repository = GetIt.I<PostRepository>();

  PostWidgetCubit({this.event, required this.post}) : super(PostWidgetState(post: post, status: StatusPWS.loaded)) {}

  Future<void> editPost(Post post) async {
    repository.update(post).then((postOrFailure) =>
        postOrFailure.fold(
                (failure) => emit(state.copyWith(failure: failure, status: StatusPWS.editFailure)),
                (updatedPost) {emit(state.copyWith(post: updatedPost, status: StatusPWS.editSuccess));}
        ));
  }

  Future<void> deletePost(Post post) async {
    emit(state.copyWith(status: StatusPWS.deletionInProgress));
    repository.deletePost(post).then((value) {
      value.fold(
              (l) => emit(state.copyWith(status: StatusPWS.deletionFailure, failure: l)),
              (r) => emit(state.copyWith(status: StatusPWS.deletionSuccess)));
    });
  }


  // ///creates a post and send it to backend with eventId
  // Future<void> postPost(String postDesc, String eventId) async {
  //   Post post = Post(
  //       id: UniqueId(),
  //       creationDate: DateTime.now(),
  //       postContent: PostContent(postDesc),
  //       event: event,
  //       owner: Profile(id: UniqueId(), name: ProfileName("test")));
  //   var statecheck = state;
  //   await state.maybeMap(
  //     loaded: (value) async {
  //       emit(PostWidgetState.initial());
  //       await repository.createPost(post, eventId).then((postOrFailure) =>
  //           postOrFailure.fold(
  //                   (failure) =>
  //               //if failure emit to error screen
  //               emit(PostWidgetState.error(error: failure.toString())),
  //                   (postReturned) async {
  //                 post = await uploadImages(postReturned, value);
  //                 //add our post to posts and emit the postsscreen
  //                 emit(PostWidgetState.loaded(post: postReturned));
  //               }));
  //     },
  //     initial: (st){ print("intial");},
  //     orElse: () => throw LogicError(),
  //   );
  // }
  // ///
  // /// Uploads all images in the state one by one to the server and returns altered Post with the images inside
  // ///
  // Future<Post> uploadImages(Post post, _Loaded loaded) async {
  //   if (post.images == null) {
  //     post = post.copyWith(images: []);
  //   }
  //   for (XFile? element in loaded.images) {
  //     if (element != null) {
  //       await repository.uploadImages(post.id!, element).then((value) {
  //         value.fold((l) => null, (imagePath) => post.images!.add(imagePath));
  //       });
  //     }
  //   }
  //   ;
  //   return post;
  // }

}