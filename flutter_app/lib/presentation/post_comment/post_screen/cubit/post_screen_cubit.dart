import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
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

part 'post_screen_state.dart';
part 'post_screen_cubit.freezed.dart';

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
    await state.maybeMap(
      loaded: (value) async {
        emit(PostScreenState.loading());
        await repository
            .createPost(post, eventId)
            .then((postOrFailure) => postOrFailure.fold(
                (failure) =>
                    //if failure emit to error screen
                    emit(PostScreenState.error(error: failure.toString())),
                (post) => {
                      //add our post to posts and emit the postsscreen
                      value.posts.add(post),
                      emit(PostScreenState.loaded(posts: value.posts))
                    }));
      },
      orElse: () => throw LogicError(),
    );
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
        orElse: () => throw LogicError());
  }

  // an simple error handler for eithers
  dynamic postsErrorHandler(Either<NetWorkFailure, dynamic> response) {
    return response.fold(
        (networfailure) =>
            emit(PostScreenState.error(error: networfailure.toString())),
        (payload) => payload);
  }
}
