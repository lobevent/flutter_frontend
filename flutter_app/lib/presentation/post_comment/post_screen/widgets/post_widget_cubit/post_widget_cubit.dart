import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_frontend/domain/event/event.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../domain/core/failures.dart';
import '../../../../../domain/core/value_objects.dart';
import '../../../../../domain/post/value_objects.dart';
import '../../../../../domain/profile/profile.dart';
import '../../../../../domain/profile/value_objects.dart';

part 'post_widget_cubit.freezed.dart';

part 'post_widget_state.dart';

class PostWidgetCubit extends Cubit<PostWidgetState> {
  final Post? post;
  final Event? event;
  final PostRepository repository = GetIt.I<PostRepository>();

  PostWidgetCubit({this.event, this.post}) : super(PostWidgetState.initial()) {
    emit(PostWidgetState.loaded(post: post!));
  }

  Future<void> editPost(Post post) async {
    Either<NetWorkFailure, Post> failureOrSuccess =
    await repository.update(post);

    await state.maybeMap(
        loaded: (postLoaded)
    async {
      repository.update(post).then((postOrFailure) =>
          postOrFailure.fold(
                  (failure) =>
                  emit(PostWidgetState.error(error: failure.toString())),
                  (updatedPost) {
                //emit the loading bar
                emit(PostWidgetState.initial());
                emit(PostWidgetState.edited(post: updatedPost));
              }
          ));
    },
    error: (st){
    emit(PostWidgetState.error(error: st.error));
    },
    orElse: () => throw LogicError());
  }

  //we dont use this
  Future<void> deletePost(Post post) async {
    await state.maybeMap(
        loaded: (postLoaded) async {
          repository.deletePost(post).then((value) {
            //emit the loading bar
            emit(PostWidgetState.initial());
            emit(PostWidgetState.deleted());
          });
        },
        edited: (postLoaded) async {
          repository.deletePost(post).then((value) {
            //emit the loading bar
            emit(PostWidgetState.initial());
            emit(PostWidgetState.deleted());
          });
        },
        error: (err){
          emit(PostWidgetState.error(error: err.error));
        },
        orElse: () {
          throw LogicError();
        }
    );
  }

  ///creates a post and send it to backend with eventId
  Future<void> postPost(String postDesc, String eventId) async {
    Post post = Post(
        id: UniqueId(),
        creationDate: DateTime.now(),
        postContent: PostContent(postDesc),
        event: event,
        owner: Profile(id: UniqueId(), name: ProfileName("test")));
    var statecheck = state;
    await state.maybeMap(
      loaded: (value) async {
        emit(PostWidgetState.initial());
        await repository.createPost(post, eventId).then((postOrFailure) =>
            postOrFailure.fold(
                    (failure) =>
                //if failure emit to error screen
                emit(PostWidgetState.error(error: failure.toString())),
                    (postReturned) async {
                  post = await uploadImages(postReturned, value);
                  //add our post to posts and emit the postsscreen
                  emit(PostWidgetState.loaded(post: postReturned));
                }));
      },
      initial: (st){ print("intial");},
      orElse: () => throw LogicError(),
    );
  }
  ///
  /// Uploads all images in the state one by one to the server and returns altered Post with the images inside
  ///
  Future<Post> uploadImages(Post post, _Loaded loaded) async {
    if (post.images == null) {
      post = post.copyWith(images: []);
    }
    for (XFile? element in loaded.images) {
      if (element != null) {
        await repository.uploadImages(post.id!, element).then((value) {
          value.fold((l) => null, (imagePath) => post.images!.add(imagePath));
        });
      }
    }
    ;
    return post;
  }

}