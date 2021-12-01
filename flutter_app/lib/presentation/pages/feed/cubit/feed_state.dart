part of 'feed_cubit.dart';

/// ATTTENTION THIS Class has to be updated entirely if something new comes in
class FeedState {
  FeedState({this.isLoading = false, Option<String>? error, List<Post>? posts}){
    this.error = error?? this.error;
    this.posts = posts?? this.posts;
  } // you have to update the constructor

  bool isLoading = false;
  Option<String> error = none();
  List<Post> posts = [];


  FeedState copywith({bool? isLoading, Option<String>? error, List<Post>? posts}){ // and ofcourse the copywith method if you want to be happy
    return FeedState(isLoading: isLoading?? this.isLoading, error: error??this.error, posts: posts??this.posts);
  }
}

