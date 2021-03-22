import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/i_post_repository.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/post_failure.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_remote_service.dart';

class PostRepository implements IPostRepository {
  final PostRemoteService _postRemoteService;

  PostRepository(this._postRemoteService);

  @override
  Future<Either<PostFailure, Post>> create(Post post) async {
    try {
      final postDto = PostDto.fromDomain(post);
      PostDto returnedPostDto = await _postRemoteService.createPost(postDto);
      return right(returnedPostDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<PostFailure, Post>> delete(Post post) async {
    try {
      final postDto = PostDto.fromDomain(post);
      PostDto returnedPostDto = await _postRemoteService.deletePost(postDto);
      return right(returnedPostDto.toDomain()); //TODO implement with .toDomain
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<PostFailure, List<Post>>> getList(Operation operation,
      DateTime lastPostTime, int amount, Event eventParent,  //TODO add eventparent
      {Profile? profile}) async {
    try {
      List<PostDto> postDtos;
      switch (operation) {
        case Operation.own:
          postDtos =
              await _postRemoteService.getOwnPosts(lastPostTime, amount);
          break;
        case Operation.feed:
          postDtos = await _postRemoteService.getFeed(lastPostTime, amount);
          break;
        case Operation.fromUser:
          if(profile == null){
            throw UnexpectedTypeError();
          }
          postDtos = await _postRemoteService.getPostsFromUser(
              lastPostTime, amount, profile.id.getOrCrash().toString());
          break;
      }
      //convert the dto objects to domain Objects
      final List<Post> posts =
          postDtos.map((postDto) => postDto.toDomain()).toList();
      return right(posts);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<PostFailure, Post>> getSingle(Id id) async {
    try {
      final PostDto postDto =
          await _postRemoteService.getSingle(id.getOrCrash());
      final Post post = postDto.toDomain();
      return right(post);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<PostFailure, Post>> update(Post post) async {
    try {
      final postDto = PostDto.fromDomain(post);
      PostDto returnedPost;
      returnedPost = await _postRemoteService.updatePost(postDto);
      return right(returnedPost.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  PostFailure _reactOnCommunicationException(CommunicationException e) {
    switch (e.runtimeType) {
      case NotFoundException:
        return const PostFailure.notFound();
        break;
      case InternalServerException:
        return const PostFailure.internalServer();
        break;
      case NotAuthenticatedException:
        return const PostFailure.notAuthenticated();
        break;
      case NotAuthorizedException:
        return const PostFailure.insufficientPermissions();
        break;
      case UnexpectedFormatException:
        return const PostFailure.unexpected();
      default:
        return const PostFailure.unexpected();
        break;
    }
  }
}
