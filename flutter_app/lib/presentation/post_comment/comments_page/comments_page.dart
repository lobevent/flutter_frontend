import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';



class CommentsPage extends StatelessWidget {
  final Either<Post, Comment> parent;
  const CommentsPage({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
