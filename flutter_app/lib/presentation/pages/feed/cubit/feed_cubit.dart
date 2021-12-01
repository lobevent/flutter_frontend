import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';


part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedState()) {
    loadFeed();
    controller.addListener(_scrollListener);
    
  }
  PostRepository repository = GetIt.I<PostRepository>();
  ScrollController controller = ScrollController();

  Future<void> loadFeed() async {
    state.isLoading = true;
    emit(state);
    repository.getFeed(lastPostTime: DateTime.now(), amount: 20).then((value) => value.fold(
            // (failure) {
            //   state.isLoading = false;
            //   state.error = some(failure.toString());
            //   emit(state);
            // },
            // (posts) {
            //   state.isLoading = false;
            //   state.posts = posts;
            //   emit(state);
            // }));
        (failure) {
          emit(state.copywith(isLoading: false, error: some(failure.toString())));
        },
            (posts) {
          emit(state.copywith(isLoading: false, posts: posts));
        }));
  }
  
  
  
  _scrollListener(){
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
    }
  }
}
