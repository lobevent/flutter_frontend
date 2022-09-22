import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

part 'post_screen_cubit.freezed.dart';
part 'post_screen_state.dart';

class PostScreenCubit extends Cubit<PostScreenState> {
  final Event? event;
  final PostRepository repository = GetIt.I<PostRepository>();

  PostScreenCubit({this.event}) : super(PostScreenState.initial()) {
    emit(PostScreenState.initial());
    loadPosts();
  }

  /// the function that actually loads the comments
  Future<void> loadPosts() async {
    final Either<NetWorkFailure, List<Post>> postsList;
    try {
      emit(PostScreenState.loading());
      postsList = await repository.getPostsFromEvent(
          lastPostTime: DateTime.now(), amount: 30, event: event!);
      emit(PostScreenState.loaded(
          posts: postsList.fold((l) => throw NetWorkFailure, (r) => r)));
    } catch (e) {
      emit(PostScreenState.error(error: e.toString()));
    }
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
        emit(PostScreenState.loading());
        await repository.createPost(post, eventId).then((postOrFailure) =>
            postOrFailure.fold(
                (failure) =>
                    //if failure emit to error screen
                    emit(PostScreenState.error(error: failure.toString())),
                (postReturned) async {
              post = await uploadImages(postReturned, value);
              //add our post to posts and emit the postsscreen
              List<Post> postsAdded=  [...value.posts, postReturned];
              emit(PostScreenState.loaded(posts: postsAdded));
            }));
      },
      initial: (st){ print("intial");},
      orElse: () => throw LogicError(),
    );
  }

  Future<void> editPost(Post post) async {
    Either<NetWorkFailure, Post> failureOrSuccess =
    await repository.update(post);

    await state.maybeMap(
        loaded: (postLoaded) async {
          repository.update(post).then((postOrFailure) => postOrFailure.fold(
                  (failure) => emit(PostScreenState.error(error: failure.toString())),
                  (updatedPost) {
                  //emit the loading bar
                  emit(PostScreenState.loading());

                   //delete post out of postlist and emit updated postlist
                   List<Post> oldPostList = postLoaded.posts;
                   int postPos = postLoaded.posts.indexWhere((element) => element.id?.value == post.id?.value);
                     oldPostList[postPos]= updatedPost;
                    //emit our updated postlist
                  emit(PostScreenState.loaded(posts: oldPostList));
                  }
                  ));
        },
        error: (st){
          emit(PostScreenState.error(error: st.error));
        },
        orElse: () =>
        throw LogicError());
  }

  //we dont use this
  Future<void> deletePost(Post post) async {
      await state.maybeMap(
          loaded: (postLoaded) async {
            repository.deletePost(post).then((value) {
              //emit the loading bar
              emit(PostScreenState.loading());
              //delete post out of postlist and emit updated postlist
              List<Post> updatedPostList = postLoaded.posts;
              //returns true if element is in there and removed
              updatedPostList.remove(post);
              //emit our updated postlist
              emit(PostScreenState.loaded(posts: updatedPostList));
            });
          },
          orElse: () {
            emit(PostScreenState.error(error: 'Logic Problem'));
          }
          );
  }

  // an simple error handler for eithers
  dynamic postsErrorHandler(Either<NetWorkFailure, dynamic> response) {
    return response.fold(
        (networfailure) =>
            emit(PostScreenState.error(error: networfailure.toString())),
        (payload) => payload);
  }

  void changePictures(List<XFile?> images) {
    state.maybeMap(
        orElse: () {},
        loaded: (loadedState) {
          emit(loadedState.copyWith(images: images));
        });
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
