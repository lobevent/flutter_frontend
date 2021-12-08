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
  DateTime lastLoadedDate = DateTime.now();

  Future<void> loadFeed() async {
    state.isLoading = true;
    emit(state);
    repository.getFeed(lastPostTime: DateTime.now(), amount: 2).then((value) => value.fold(
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
  
  Future<void> loadMore() async{
    // if(lastLoadedDate.toIso8601String() == state.posts.last.creationDate.toIso8601String()){
    //   return;
    // }
    emit(state.copywith(isLoadingNew: true));
    repository.getFeed(lastPostTime: state.posts.last.creationDate, amount: 2).then((value) => value.fold(
      (failure) {
          emit(state.copywith(isLoadingNew: false, error: some(failure.toString())));
        },
      (posts) {
          state.posts.addAll(posts);
          emit(state.copywith(isLoadingNew: false, posts: state.posts));
        }));
    //this.lastLoadedDate = state.posts.last.creationDate;
  }
  
  _scrollListener(){
    if (controller.offset >= controller.position.maxScrollExtent - 100.0 &&
        !controller.position.outOfRange) {
        //loadMore();
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
    }
  }
}
