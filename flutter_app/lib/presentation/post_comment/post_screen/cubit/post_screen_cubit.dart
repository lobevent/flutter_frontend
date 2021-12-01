import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

part 'post_screen_state.dart';
part 'post_screen_cubit.freezed.dart';

class PostScreenCubit extends Cubit<PostScreenState> {
  final Event? event;
  final PostRepository repository = GetIt.I<PostRepository>();

  PostScreenCubit({this.event})
      : super(PostScreenState.initial()) {
    emit(PostScreenState.initial());
    loadPosts();
  }

  /// the function that actually loads the comments
  Future<void> loadPosts() async {
    final Either<NetWorkFailure, List<Post>> postsList;
    try {
      emit(PostScreenState.loading());
      postsList = await repository.getPostsFromEvent(lastPostTime: DateTime.now(),amount: 30,event: event!);
      emit(PostScreenState.loaded(
          posts: postsList.fold((l) => throw Exception, (r) => r)));
    } catch (e) {
      emit(PostScreenState.error(error: e.toString()));
    }
  }


  // an simple error handler for eithers
  dynamic postsErrorHandler(Either<NetWorkFailure, dynamic> response) {
    return response.fold(
        (networfailure) =>
            emit(PostScreenState.error(error: networfailure.toString())),
        (payload) => payload);
  }
}