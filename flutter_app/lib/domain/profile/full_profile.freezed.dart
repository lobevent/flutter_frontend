// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'full_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$FullProfileTearOff {
  const _$FullProfileTearOff();

// ignore: unused_element
  _FullProfile call(
      {@required int id,
      @required ProfileName name,
      @required List<UsrEvntStats> userEventStatus,
      @required List<Event> ownedEvents,
      @required List<Invitation> invitations,
      @required List<Friendship> friendships,
      @required List<Friendship2> friendships2,
      @required List<Post> posts,
      @required List<Comment> comments}) {
    return _FullProfile(
      id: id,
      name: name,
      userEventStatus: userEventStatus,
      ownedEvents: ownedEvents,
      invitations: invitations,
      friendships: friendships,
      friendships2: friendships2,
      posts: posts,
      comments: comments,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $FullProfile = _$FullProfileTearOff();

/// @nodoc
mixin _$FullProfile {
  int get id;
  ProfileName get name;
  List<UsrEvntStats> get userEventStatus;
  List<Event> get ownedEvents;
  List<Invitation> get invitations;
  List<Friendship> get friendships;
  List<Friendship2> get friendships2;
  List<Post> get posts;
  List<Comment> get comments;

  $FullProfileCopyWith<FullProfile> get copyWith;
}

/// @nodoc
abstract class $FullProfileCopyWith<$Res> {
  factory $FullProfileCopyWith(
          FullProfile value, $Res Function(FullProfile) then) =
      _$FullProfileCopyWithImpl<$Res>;
  $Res call(
      {int id,
      ProfileName name,
      List<UsrEvntStats> userEventStatus,
      List<Event> ownedEvents,
      List<Invitation> invitations,
      List<Friendship> friendships,
      List<Friendship2> friendships2,
      List<Post> posts,
      List<Comment> comments});
}

/// @nodoc
class _$FullProfileCopyWithImpl<$Res> implements $FullProfileCopyWith<$Res> {
  _$FullProfileCopyWithImpl(this._value, this._then);

  final FullProfile _value;
  // ignore: unused_field
  final $Res Function(FullProfile) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object userEventStatus = freezed,
    Object ownedEvents = freezed,
    Object invitations = freezed,
    Object friendships = freezed,
    Object friendships2 = freezed,
    Object posts = freezed,
    Object comments = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as ProfileName,
      userEventStatus: userEventStatus == freezed
          ? _value.userEventStatus
          : userEventStatus as List<UsrEvntStats>,
      ownedEvents: ownedEvents == freezed
          ? _value.ownedEvents
          : ownedEvents as List<Event>,
      invitations: invitations == freezed
          ? _value.invitations
          : invitations as List<Invitation>,
      friendships: friendships == freezed
          ? _value.friendships
          : friendships as List<Friendship>,
      friendships2: friendships2 == freezed
          ? _value.friendships2
          : friendships2 as List<Friendship2>,
      posts: posts == freezed ? _value.posts : posts as List<Post>,
      comments:
          comments == freezed ? _value.comments : comments as List<Comment>,
    ));
  }
}

/// @nodoc
abstract class _$FullProfileCopyWith<$Res>
    implements $FullProfileCopyWith<$Res> {
  factory _$FullProfileCopyWith(
          _FullProfile value, $Res Function(_FullProfile) then) =
      __$FullProfileCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      ProfileName name,
      List<UsrEvntStats> userEventStatus,
      List<Event> ownedEvents,
      List<Invitation> invitations,
      List<Friendship> friendships,
      List<Friendship2> friendships2,
      List<Post> posts,
      List<Comment> comments});
}

/// @nodoc
class __$FullProfileCopyWithImpl<$Res> extends _$FullProfileCopyWithImpl<$Res>
    implements _$FullProfileCopyWith<$Res> {
  __$FullProfileCopyWithImpl(
      _FullProfile _value, $Res Function(_FullProfile) _then)
      : super(_value, (v) => _then(v as _FullProfile));

  @override
  _FullProfile get _value => super._value as _FullProfile;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object userEventStatus = freezed,
    Object ownedEvents = freezed,
    Object invitations = freezed,
    Object friendships = freezed,
    Object friendships2 = freezed,
    Object posts = freezed,
    Object comments = freezed,
  }) {
    return _then(_FullProfile(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as ProfileName,
      userEventStatus: userEventStatus == freezed
          ? _value.userEventStatus
          : userEventStatus as List<UsrEvntStats>,
      ownedEvents: ownedEvents == freezed
          ? _value.ownedEvents
          : ownedEvents as List<Event>,
      invitations: invitations == freezed
          ? _value.invitations
          : invitations as List<Invitation>,
      friendships: friendships == freezed
          ? _value.friendships
          : friendships as List<Friendship>,
      friendships2: friendships2 == freezed
          ? _value.friendships2
          : friendships2 as List<Friendship2>,
      posts: posts == freezed ? _value.posts : posts as List<Post>,
      comments:
          comments == freezed ? _value.comments : comments as List<Comment>,
    ));
  }
}

/// @nodoc
class _$_FullProfile implements _FullProfile {
  const _$_FullProfile(
      {@required this.id,
      @required this.name,
      @required this.userEventStatus,
      @required this.ownedEvents,
      @required this.invitations,
      @required this.friendships,
      @required this.friendships2,
      @required this.posts,
      @required this.comments})
      : assert(id != null),
        assert(name != null),
        assert(userEventStatus != null),
        assert(ownedEvents != null),
        assert(invitations != null),
        assert(friendships != null),
        assert(friendships2 != null),
        assert(posts != null),
        assert(comments != null);

  @override
  final int id;
  @override
  final ProfileName name;
  @override
  final List<UsrEvntStats> userEventStatus;
  @override
  final List<Event> ownedEvents;
  @override
  final List<Invitation> invitations;
  @override
  final List<Friendship> friendships;
  @override
  final List<Friendship2> friendships2;
  @override
  final List<Post> posts;
  @override
  final List<Comment> comments;

  @override
  String toString() {
    return 'FullProfile(id: $id, name: $name, userEventStatus: $userEventStatus, ownedEvents: $ownedEvents, invitations: $invitations, friendships: $friendships, friendships2: $friendships2, posts: $posts, comments: $comments)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FullProfile &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.userEventStatus, userEventStatus) ||
                const DeepCollectionEquality()
                    .equals(other.userEventStatus, userEventStatus)) &&
            (identical(other.ownedEvents, ownedEvents) ||
                const DeepCollectionEquality()
                    .equals(other.ownedEvents, ownedEvents)) &&
            (identical(other.invitations, invitations) ||
                const DeepCollectionEquality()
                    .equals(other.invitations, invitations)) &&
            (identical(other.friendships, friendships) ||
                const DeepCollectionEquality()
                    .equals(other.friendships, friendships)) &&
            (identical(other.friendships2, friendships2) ||
                const DeepCollectionEquality()
                    .equals(other.friendships2, friendships2)) &&
            (identical(other.posts, posts) ||
                const DeepCollectionEquality().equals(other.posts, posts)) &&
            (identical(other.comments, comments) ||
                const DeepCollectionEquality()
                    .equals(other.comments, comments)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(userEventStatus) ^
      const DeepCollectionEquality().hash(ownedEvents) ^
      const DeepCollectionEquality().hash(invitations) ^
      const DeepCollectionEquality().hash(friendships) ^
      const DeepCollectionEquality().hash(friendships2) ^
      const DeepCollectionEquality().hash(posts) ^
      const DeepCollectionEquality().hash(comments);

  @override
  _$FullProfileCopyWith<_FullProfile> get copyWith =>
      __$FullProfileCopyWithImpl<_FullProfile>(this, _$identity);
}

abstract class _FullProfile implements FullProfile {
  const factory _FullProfile(
      {@required int id,
      @required ProfileName name,
      @required List<UsrEvntStats> userEventStatus,
      @required List<Event> ownedEvents,
      @required List<Invitation> invitations,
      @required List<Friendship> friendships,
      @required List<Friendship2> friendships2,
      @required List<Post> posts,
      @required List<Comment> comments}) = _$_FullProfile;

  @override
  int get id;
  @override
  ProfileName get name;
  @override
  List<UsrEvntStats> get userEventStatus;
  @override
  List<Event> get ownedEvents;
  @override
  List<Invitation> get invitations;
  @override
  List<Friendship> get friendships;
  @override
  List<Friendship2> get friendships2;
  @override
  List<Post> get posts;
  @override
  List<Comment> get comments;
  @override
  _$FullProfileCopyWith<_FullProfile> get copyWith;
}
