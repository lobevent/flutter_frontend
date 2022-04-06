import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_remote_service.dart';
import 'package:image_picker/image_picker.dart';

enum Operation { fromUser }

class PostRepository extends Repository {
  final PostRemoteService _postRemoteService;

  PostRepository(this._postRemoteService);
  // ---------------------------------- Image Crud ------------------------------------------
  
  Future<Either<NetWorkFailure, String>> uploadImages(UniqueId postId, XFile image) async{
    return localErrorHandler(() async {
      return right(
         await _postRemoteService.uploadImageToEvent(postId.value, File(image.path)));
    });
  }

  
  // ---------------------------------- Simple CRUD ------------------------------------
  ///
  /// Creates an post in the backend or returns failure
  ///
  Future<Either<NetWorkFailure, Post>> create(Post post) async {
    return localErrorHandler(() async {
      final postDto = PostDto.fromDomain(post);
      final PostDto returnedPostDto = await _postRemoteService.createPost(
          postDto, post.event!.id.value.toString());
      return right(returnedPostDto.toDomain());
    });
  }

  ///
  /// deletes an post in the backend or returns failure
  ///
  Future<Either<NetWorkFailure, Post>> delete(Post post) async {
    return localErrorHandler(() async {
      final postDto = PostDto.fromDomain(post);
      final PostDto returnedPostDto =
          await _postRemoteService.deletePost(postDto);
      return right(returnedPostDto.toDomain()); //TODO implement with .toDomain
    });
  }

  ///
  /// gets an single post in the backend or returns failure
  ///
  Future<Either<NetWorkFailure, Post>> getSingle(UniqueId id) async {
    return localErrorHandler(() async {
      final PostDto postDto = await _postRemoteService.getSingle(id.value);
      final Post post = postDto.toDomain();
      return right(post);
    });
  }

  ///
  /// updates an post in the backend or returns failure
  ///
  Future<Either<NetWorkFailure, Post>> update(Post post) async {
    return localErrorHandler(() async {
      final postDto = PostDto.fromDomain(post);
      PostDto returnedPost;
      returnedPost = await _postRemoteService.updatePost(postDto);
      return right(returnedPost.toDomain());
    });
  }

  // ------------------------- List Getters ----------------------------------

  ///
  /// gets posts from logged in user
  ///
  Future<Either<NetWorkFailure, List<Post>>> getOwnPosts(
      {required DateTime lastPostTime, required int amount}) async {
    return localErrorHandler(() async {
      final List<PostDto> postDtos =
          await _postRemoteService.getOwnPosts(lastPostTime, amount);
      return right(_convertToDomainList(postDtos));
    });
  }

  ///
  /// gets the feed for logged in user
  ///
  Future<Either<NetWorkFailure, List<Post>>> getFeed(
      {required DateTime lastPostTime, required int amount}) async {
    return localErrorHandler(() async {
      final List<PostDto> postDtos =
          await _postRemoteService.getFeed(lastPostTime, amount);
      return right(_convertToDomainList(postDtos));
    });
  }

  ///
  /// gets the public posts from specific user
  ///
  Future<Either<NetWorkFailure, List<Post>>> getPostsFromUser(
      {required DateTime lastPostTime,
      required int amount,
      required Profile profile}) async {
    return localErrorHandler(() async {
      final List<PostDto> postDtos = await _postRemoteService.getPostsFromUser(
          lastPostTime, amount, profile.id.value.toString());
      return right(_convertToDomainList(postDtos));
    });
  }

  ///
  /// gets the public posts from a specific event
  ///
  Future<Either<NetWorkFailure, List<Post>>> getPostsFromEvent(
      {required DateTime lastPostTime,
      required int amount,
      required Event event}) async {
    return localErrorHandler(() async {
      final List<PostDto> postDtos = await _postRemoteService.getPostsFromEvent(
          lastPostTime, amount, event.id.value.toString());
      return right(_convertToDomainList(postDtos));
    });
  }

  ///
  /// converts to domain list
  ///
  List<Post> _convertToDomainList(List<PostDto> dtos) {
    return dtos.map((postDto) => postDto.toDomain()).toList();
  }

  ///---------------------------------------------------------------------Post ADD/EDIT/DELETE-----------------------------------------------------
  ///
  /// adds a post
  ///
  Future<Either<NetWorkFailure, Post>> createPost(
      Post post, String eventId) async {
    return localErrorHandler<Post>(() async {
      final postDto = PostDto.fromDomain(post);
      PostDto returnedPostDto =
          await _postRemoteService.createPost(postDto, eventId);
      return right(returnedPostDto.toDomain());
    });
  }

  Future<void> deletePost(Post post) async {
    await _postRemoteService.deletedPost(post.id!.value.toString());
  }
}
