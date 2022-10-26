import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:meta/meta.dart';

part 'comments_page_state.dart';
part 'comments_page_cubit.g.dart';

class CommentsPageCubit extends Cubit<CommentsPageState> {
  CommentsPageCubit() : super(CommentsPageState(state: StateCPS.loading));
}
