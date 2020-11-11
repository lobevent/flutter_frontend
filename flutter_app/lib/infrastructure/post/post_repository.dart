import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/i_post_repository.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/post_failure.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_remote_service.dart';

class PostRepository implements IPostRepository {
  final PostRemoteService _postRemoteService;

  PostRepository(this._postRemoteService);

  @override
  Future<Either<PostFailure, Profile>> create(Post post) async {
    try {
      final postDto = PostDto.fromDomain(post);
      _postRemoteService.create(postDto);
      return right(returnedpost); //TODO implement with .toDomain
    } on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const PostFailure.insufficientPermissions());
      } else {
        return left(const PostFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<PostFailure, Profile>> delete(Post post) async {
    try {
      final postDto = PostDto.fromDomain(post);
      _postRemoteService.delete(postDto);
      return right(returnedpost); //TODO implement with .toDomain
    } on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const PostFailure.insufficientPermissions());
      } else {
        return left(const PostFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<PostFailure, List<Profile>>> getList(Operation operation, {Profile profile}) async {
    try {
      List<PostDto> postDtos;
      switch(operation) {
        case Operation.own:
          postDtos = await _postRemoteService.getOwnPosts();
          break;
        case Operation.feed:
          postDtos = await _postRemoteService.getFeed();
          break;
        case Operation.fromUser:
          postDtos = await _postRemoteService.getPostsFromUser();
          break;
      }
      //convert the dto objects to domain Objects
      final List<Profile> post =  postDtos.map((postDto) => postDto.toDomain()).toList();
      return right(post);
    }  on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const PostFailure.insufficientPermissions());
      } else {
        return left(const PostFailure.unexpected());
      }
    }
  }
  @override
  Future<Either<PostFailure, Profile>> getSinglePost(Id id) async {
    try {
      final PostDto postDto = await _postRemoteService.getSinglePost(id.getOrCrash());
      final Profile post = postDto.toDomain();
      return right(post);
    }  on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const PostFailure.insufficientPermissions());
      } else {
        return left(const PostFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<PostFailure, Profile>> update(Post post) async {
    try {
      final postDto = PostDto.fromDomain(post);
      _postRemoteService.update(postDto);
      return right(returnedpost); //TODO implement with .toDomain
    } on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const PostFailure.insufficientPermissions());
      } else {
        return left(const PostFailure.unexpected());
      }
    }
  }
}
