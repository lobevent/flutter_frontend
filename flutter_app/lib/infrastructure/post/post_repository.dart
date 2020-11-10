import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/i_post_repository.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/post_failure.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

class PostRepository implements IPostRepository {
  @override
  Future<Either<PostFailure, Unit>> create(Post post) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<PostFailure, Unit>> delete(Post post) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<PostFailure, List<Post>>> getList(Operation operation, {Profile profile}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<Either<PostFailure, Post>> getSingle(Id id) {
    // TODO: implement getSingle
    throw UnimplementedError();
  }

  @override
  Future<Either<PostFailure, Unit>> update(Post post) {
    // TODO: implement update
    throw UnimplementedError();
  }

}