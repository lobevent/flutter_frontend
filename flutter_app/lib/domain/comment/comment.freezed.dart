// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$CommentTearOff {
  const _$CommentTearOff();

// ignore: unused_element
  _Comment call(
      {@required int id,
      @required DateTime creationDate,
      @required CommentContent commentContent,
      @required BaseProfile owner,
      @required Event event,
      @required Post post,
      @required Comment commentParent,
      @required List<Comment> commentChilds}) {
    return _Comment(
      id: id,
      creationDate: creationDate,
      commentContent: commentContent,
      owner: owner,
      event: event,
      post: post,
      commentParent: commentParent,
      commentChilds: commentChilds,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $Comment = _$CommentTearOff();

/// @nodoc
mixin _$Comment {
  int get id;
  DateTime get creationDate;
  CommentContent get commentContent;
  BaseProfile get owner;
  Event get event;
  Post get post;
  Comment get commentParent;
  List<Comment> get commentChilds;

  $CommentCopyWith<Comment> get copyWith;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res>;
  $Res call(
      {int id,
      DateTime creationDate,
      CommentContent commentContent,
      BaseProfile owner,
      Event event,
      Post post,
      Comment commentParent,
      List<Comment> commentChilds});

  $BaseProfileCopyWith<$Res> get owner;
  $EventCopyWith<$Res> get event;
  $PostCopyWith<$Res> get post;
  $CommentCopyWith<$Res> get commentParent;
}

/// @nodoc
class _$CommentCopyWithImpl<$Res> implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  final Comment _value;
  // ignore: unused_field
  final $Res Function(Comment) _then;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object commentContent = freezed,
    Object owner = freezed,
    Object event = freezed,
    Object post = freezed,
    Object commentParent = freezed,
    Object commentChilds = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      commentContent: commentContent == freezed
          ? _value.commentContent
          : commentContent as CommentContent,
      owner: owner == freezed ? _value.owner : owner as BaseProfile,
      event: event == freezed ? _value.event : event as Event,
      post: post == freezed ? _value.post : post as Post,
      commentParent: commentParent == freezed
          ? _value.commentParent
          : commentParent as Comment,
      commentChilds: commentChilds == freezed
          ? _value.commentChilds
          : commentChilds as List<Comment>,
    ));
  }

  @override
  $BaseProfileCopyWith<$Res> get owner {
    if (_value.owner == null) {
      return null;
    }
    return $BaseProfileCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value));
    });
  }

  @override
  $EventCopyWith<$Res> get event {
    if (_value.event == null) {
      return null;
    }
    return $EventCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value));
    });
  }

  @override
  $PostCopyWith<$Res> get post {
    if (_value.post == null) {
      return null;
    }
    return $PostCopyWith<$Res>(_value.post, (value) {
      return _then(_value.copyWith(post: value));
    });
  }

  @override
  $CommentCopyWith<$Res> get commentParent {
    if (_value.commentParent == null) {
      return null;
    }
    return $CommentCopyWith<$Res>(_value.commentParent, (value) {
      return _then(_value.copyWith(commentParent: value));
    });
  }
}

/// @nodoc
abstract class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) then) =
      __$CommentCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      DateTime creationDate,
      CommentContent commentContent,
      BaseProfile owner,
      Event event,
      Post post,
      Comment commentParent,
      List<Comment> commentChilds});

  @override
  $BaseProfileCopyWith<$Res> get owner;
  @override
  $EventCopyWith<$Res> get event;
  @override
  $PostCopyWith<$Res> get post;
  @override
  $CommentCopyWith<$Res> get commentParent;
}

/// @nodoc
class __$CommentCopyWithImpl<$Res> extends _$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(_Comment _value, $Res Function(_Comment) _then)
      : super(_value, (v) => _then(v as _Comment));

  @override
  _Comment get _value => super._value as _Comment;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object commentContent = freezed,
    Object owner = freezed,
    Object event = freezed,
    Object post = freezed,
    Object commentParent = freezed,
    Object commentChilds = freezed,
  }) {
    return _then(_Comment(
      id: id == freezed ? _value.id : id as int,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      commentContent: commentContent == freezed
          ? _value.commentContent
          : commentContent as CommentContent,
      owner: owner == freezed ? _value.owner : owner as BaseProfile,
      event: event == freezed ? _value.event : event as Event,
      post: post == freezed ? _value.post : post as Post,
      commentParent: commentParent == freezed
          ? _value.commentParent
          : commentParent as Comment,
      commentChilds: commentChilds == freezed
          ? _value.commentChilds
          : commentChilds as List<Comment>,
    ));
  }
}

/// @nodoc
class _$_Comment implements _Comment {
  const _$_Comment(
      {@required this.id,
      @required this.creationDate,
      @required this.commentContent,
      @required this.owner,
      @required this.event,
      @required this.post,
      @required this.commentParent,
      @required this.commentChilds})
      : assert(id != null),
        assert(creationDate != null),
        assert(commentContent != null),
        assert(owner != null),
        assert(event != null),
        assert(post != null),
        assert(commentParent != null),
        assert(commentChilds != null);

  @override
  final int id;
  @override
  final DateTime creationDate;
  @override
  final CommentContent commentContent;
  @override
  final BaseProfile owner;
  @override
  final Event event;
  @override
  final Post post;
  @override
  final Comment commentParent;
  @override
  final List<Comment> commentChilds;

  @override
  String toString() {
    return 'Comment(id: $id, creationDate: $creationDate, commentContent: $commentContent, owner: $owner, event: $event, post: $post, commentParent: $commentParent, commentChilds: $commentChilds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Comment &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)) &&
            (identical(other.commentContent, commentContent) ||
                const DeepCollectionEquality()
                    .equals(other.commentContent, commentContent)) &&
            (identical(other.owner, owner) ||
                const DeepCollectionEquality().equals(other.owner, owner)) &&
            (identical(other.event, event) ||
                const DeepCollectionEquality().equals(other.event, event)) &&
            (identical(other.post, post) ||
                const DeepCollectionEquality().equals(other.post, post)) &&
            (identical(other.commentParent, commentParent) ||
                const DeepCollectionEquality()
                    .equals(other.commentParent, commentParent)) &&
            (identical(other.commentChilds, commentChilds) ||
                const DeepCollectionEquality()
                    .equals(other.commentChilds, commentChilds)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(commentContent) ^
      const DeepCollectionEquality().hash(owner) ^
      const DeepCollectionEquality().hash(event) ^
      const DeepCollectionEquality().hash(post) ^
      const DeepCollectionEquality().hash(commentParent) ^
      const DeepCollectionEquality().hash(commentChilds);

  @override
  _$CommentCopyWith<_Comment> get copyWith =>
      __$CommentCopyWithImpl<_Comment>(this, _$identity);
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {@required int id,
      @required DateTime creationDate,
      @required CommentContent commentContent,
      @required BaseProfile owner,
      @required Event event,
      @required Post post,
      @required Comment commentParent,
      @required List<Comment> commentChilds}) = _$_Comment;

  @override
  int get id;
  @override
  DateTime get creationDate;
  @override
  CommentContent get commentContent;
  @override
  BaseProfile get owner;
  @override
  Event get event;
  @override
  Post get post;
  @override
  Comment get commentParent;
  @override
  List<Comment> get commentChilds;
  @override
  _$CommentCopyWith<_Comment> get copyWith;
}
