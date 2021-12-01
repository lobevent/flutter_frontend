import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedState());
  PostRepository repository = GetIt.I<PostRepository>();


  void loadFeed(){
    repository.getFeed(lastPostTime: DateTime.now(), amount: 20).then((value) => value.fold(
            (failure) => {
              state.error = some(failure.toString()),
              emit(state)
            },
            (posts) {
              state.posts = posts;
              emit(state);
            }));
  }
}
