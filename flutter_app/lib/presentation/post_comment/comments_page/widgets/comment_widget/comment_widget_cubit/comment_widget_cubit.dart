import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/post/comment_repository.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_frontend/domain/event/event.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../domain/post/comment.dart';

part 'comment_widget_cubit.g.dart';

part 'comment_widget_state.dart';

class CommentWidgetCubit extends Cubit<CommentWidgetState> {
  final CommentRepository repository = GetIt.I<CommentRepository>();

  CommentWidgetCubit({required Comment comment}) : super(CommentWidgetState(comment: comment, status: StatusCWS.loaded)) {}

  Future<void> editComment(Comment comment) async {
    repository.update(comment).then((postOrFailure) =>
        postOrFailure.fold(
                (failure) => emit(state.copyWith(failure: failure, status: StatusCWS.editFailure)),
                (updatedComment) {emit(state.copyWith(comment: updatedComment, status: StatusCWS.editSuccess));}
        ));
  }

  Future<void> deleteComment(Comment comment) async {
    emit(state.copyWith(status: StatusCWS.deletionInProgress));
    repository.delete(comment).then((value) {
      value.fold(
              (l) => emit(state.copyWith(status: StatusCWS.deletionFailure, failure: l)),
              (r) => emit(state.copyWith(status: StatusCWS.deletionSuccess)));
    });
  }

}