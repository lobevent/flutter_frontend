import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/post/post.dart';

/// this is the post widget, which should be used everywhere
class PostWidget extends StatelessWidget{
  /// the post attribute, which contains all the post data
  final Post post;
  const PostWidget({Key? key, required this.post}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(post.postContent.getOrCrash()),);
  }

}