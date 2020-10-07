import 'package:dartz/dartz.dart';

import 'post_failure.dart';
import 'post.dart';

enum Operation{
  owned,
  notOwned

}

abstract class IPostRepository{

  Future <Either<PostFailure, List<Post>>> getList(Operation operation, {Profile profile});
  Future <Either<PostFailure, Post>> getSingle(Operation operation, {Profile profile});
  Future<Either<PostFailure, Unit>> create(Post post);
  Future<Either<PostFailure, Unit>> update(Post post);
  Future<Either<PostFailure, Unit>> delete(Post post);
}