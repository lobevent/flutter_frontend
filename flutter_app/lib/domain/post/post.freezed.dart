// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$PostTearOff {
  const _$PostTearOff();

// ignore: unused_element
  _Post call(
      {@required int id,
      @required DateTime creationDate,
      @required PostContent postContent,
      @required BaseProfile owner,
      @required Event event,
      @required List<Comment> comments}) {
    return _Post(
      id: id,
      creationDate: creationDate,
      postContent: postContent,
      owner: owner,
      event: event,
      comments: comments,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $Post = _$PostTearOff();

/// @nodoc
mixin _$Post {
  int get id;
  DateTime get creationDate;
  PostContent get postContent;
  BaseProfile get owner;
  Event get event;
  List<Comment> get comments;

  $PostCopyWith<Post> get copyWith;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res>;
  $Res call(
      {int id,
      DateTime creationDate,
      PostContent postContent,
      BaseProfile owner,
      Event event,
      List<Comment> comments});

  $BaseProfileCopyWith<$Res> get owner;
  $EventCopyWith<$Res> get event;
}

/// @nodoc
class _$PostCopyWithImpl<$Res> implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  final Post _value;
  // ignore: unused_field
  final $Res Function(Post) _then;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object postContent = freezed,
    Object owner = freezed,
    Object event = freezed,
    Object comments = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      postContent: postContent == freezed
          ? _value.postContent
          : postContent as PostContent,
      owner: owner == freezed ? _value.owner : owner as BaseProfile,
      event: event == freezed ? _value.event : event as Event,
      comments:
          comments == freezed ? _value.comments : comments as List<Comment>,
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
}

/// @nodoc
abstract class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) then) =
      __$PostCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      DateTime creationDate,
      PostContent postContent,
      BaseProfile owner,
      Event event,
      List<Comment> comments});

  @override
  $BaseProfileCopyWith<$Res> get owner;
  @override
  $EventCopyWith<$Res> get event;
}

/// @nodoc
class __$PostCopyWithImpl<$Res> extends _$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(_Post _value, $Res Function(_Post) _then)
      : super(_value, (v) => _then(v as _Post));

  @override
  _Post get _value => super._value as _Post;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object postContent = freezed,
    Object owner = freezed,
    Object event = freezed,
    Object comments = freezed,
  }) {
    return _then(_Post(
      id: id == freezed ? _value.id : id as int,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      postContent: postContent == freezed
          ? _value.postContent
          : postContent as PostContent,
      owner: owner == freezed ? _value.owner : owner as BaseProfile,
      event: event == freezed ? _value.event : event as Event,
      comments:
          comments == freezed ? _value.comments : comments as List<Comment>,
    ));
  }
}

/// @nodoc
class _$_Post implements _Post {
  const _$_Post(
      {@required this.id,
      @required this.creationDate,
      @required this.postContent,
      @required this.owner,
      @required this.event,
      @required this.comments})
      : assert(id != null),
        assert(creationDate != null),
        assert(postContent != null),
        assert(owner != null),
        assert(event != null),
        assert(comments != null);

  @override
  final int id;
  @override
  final DateTime creationDate;
  @override
  final PostContent postContent;
  @override
  final BaseProfile owner;
  @override
  final Event event;
  @override
  final List<Comment> comments;

  @override
  String toString() {
    return 'Post(id: $id, creationDate: $creationDate, postContent: $postContent, owner: $owner, event: $event, comments: $comments)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Post &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)) &&
            (identical(other.postContent, postContent) ||
                const DeepCollectionEquality()
                    .equals(other.postContent, postContent)) &&
            (identical(other.owner, owner) ||
                const DeepCollectionEquality().equals(other.owner, owner)) &&
            (identical(other.event, event) ||
                const DeepCollectionEquality().equals(other.event, event)) &&
            (identical(other.comments, comments) ||
                const DeepCollectionEquality()
                    .equals(other.comments, comments)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(postContent) ^
      const DeepCollectionEquality().hash(owner) ^
      const DeepCollectionEquality().hash(event) ^
      const DeepCollectionEquality().hash(comments);

  @override
  _$PostCopyWith<_Post> get copyWith =>
      __$PostCopyWithImpl<_Post>(this, _$identity);
}

abstract class _Post implements Post {
  const factory _Post(
      {@required int id,
      @required DateTime creationDate,
      @required PostContent postContent,
      @required BaseProfile owner,
      @required Event event,
      @required List<Comment> comments}) = _$_Post;

  @override
  int get id;
  @override
  DateTime get creationDate;
  @override
  PostContent get postContent;
  @override
  BaseProfile get owner;
  @override
  Event get event;
  @override
  List<Comment> get comments;
  @override
  _$PostCopyWith<_Post> get copyWith;
}
