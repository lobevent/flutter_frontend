// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ProfileTearOff {
  const _$ProfileTearOff();

// ignore: unused_element
  _BaseProfile call({@required int id, @required ProfileName name}) {
    return _BaseProfile(
      id: id,
      name: name,
    );
  }

// ignore: unused_element
  _FullProfile full(
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
const $Profile = _$ProfileTearOff();

/// @nodoc
mixin _$Profile {
  int get id;
  ProfileName get name;

  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(int id, ProfileName name), {
    @required
        Result full(
            int id,
            ProfileName name,
            List<UsrEvntStats> userEventStatus,
            List<Event> ownedEvents,
            List<Invitation> invitations,
            List<Friendship> friendships,
            List<Friendship2> friendships2,
            List<Post> posts,
            List<Comment> comments),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(int id, ProfileName name), {
    Result full(
        int id,
        ProfileName name,
        List<UsrEvntStats> userEventStatus,
        List<Event> ownedEvents,
        List<Invitation> invitations,
        List<Friendship> friendships,
        List<Friendship2> friendships2,
        List<Post> posts,
        List<Comment> comments),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_BaseProfile value), {
    @required Result full(_FullProfile value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_BaseProfile value), {
    Result full(_FullProfile value),
    @required Result orElse(),
  });

  $ProfileCopyWith<Profile> get copyWith;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res>;
  $Res call({int id, ProfileName name});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res> implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  final Profile _value;
  // ignore: unused_field
  final $Res Function(Profile) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as ProfileName,
    ));
  }
}

/// @nodoc
abstract class _$BaseProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$BaseProfileCopyWith(
          _BaseProfile value, $Res Function(_BaseProfile) then) =
      __$BaseProfileCopyWithImpl<$Res>;
  @override
  $Res call({int id, ProfileName name});
}

/// @nodoc
class __$BaseProfileCopyWithImpl<$Res> extends _$ProfileCopyWithImpl<$Res>
    implements _$BaseProfileCopyWith<$Res> {
  __$BaseProfileCopyWithImpl(
      _BaseProfile _value, $Res Function(_BaseProfile) _then)
      : super(_value, (v) => _then(v as _BaseProfile));

  @override
  _BaseProfile get _value => super._value as _BaseProfile;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
  }) {
    return _then(_BaseProfile(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as ProfileName,
    ));
  }
}

/// @nodoc
class _$_BaseProfile extends _BaseProfile {
  const _$_BaseProfile({@required this.id, @required this.name})
      : assert(id != null),
        assert(name != null),
        super._();

  @override
  final int id;
  @override
  final ProfileName name;

  @override
  String toString() {
    return 'Profile(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BaseProfile &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name);

  @override
  _$BaseProfileCopyWith<_BaseProfile> get copyWith =>
      __$BaseProfileCopyWithImpl<_BaseProfile>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(int id, ProfileName name), {
    @required
        Result full(
            int id,
            ProfileName name,
            List<UsrEvntStats> userEventStatus,
            List<Event> ownedEvents,
            List<Invitation> invitations,
            List<Friendship> friendships,
            List<Friendship2> friendships2,
            List<Post> posts,
            List<Comment> comments),
  }) {
    assert($default != null);
    assert(full != null);
    return $default(id, name);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(int id, ProfileName name), {
    Result full(
        int id,
        ProfileName name,
        List<UsrEvntStats> userEventStatus,
        List<Event> ownedEvents,
        List<Invitation> invitations,
        List<Friendship> friendships,
        List<Friendship2> friendships2,
        List<Post> posts,
        List<Comment> comments),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(id, name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_BaseProfile value), {
    @required Result full(_FullProfile value),
  }) {
    assert($default != null);
    assert(full != null);
    return $default(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_BaseProfile value), {
    Result full(_FullProfile value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _BaseProfile extends Profile {
  const _BaseProfile._() : super._();
  const factory _BaseProfile({@required int id, @required ProfileName name}) =
      _$_BaseProfile;

  @override
  int get id;
  @override
  ProfileName get name;
  @override
  _$BaseProfileCopyWith<_BaseProfile> get copyWith;
}

/// @nodoc
abstract class _$FullProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
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
class __$FullProfileCopyWithImpl<$Res> extends _$ProfileCopyWithImpl<$Res>
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
class _$_FullProfile extends _FullProfile {
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
        assert(comments != null),
        super._();

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
    return 'Profile.full(id: $id, name: $name, userEventStatus: $userEventStatus, ownedEvents: $ownedEvents, invitations: $invitations, friendships: $friendships, friendships2: $friendships2, posts: $posts, comments: $comments)';
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

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(int id, ProfileName name), {
    @required
        Result full(
            int id,
            ProfileName name,
            List<UsrEvntStats> userEventStatus,
            List<Event> ownedEvents,
            List<Invitation> invitations,
            List<Friendship> friendships,
            List<Friendship2> friendships2,
            List<Post> posts,
            List<Comment> comments),
  }) {
    assert($default != null);
    assert(full != null);
    return full(id, name, userEventStatus, ownedEvents, invitations,
        friendships, friendships2, posts, comments);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(int id, ProfileName name), {
    Result full(
        int id,
        ProfileName name,
        List<UsrEvntStats> userEventStatus,
        List<Event> ownedEvents,
        List<Invitation> invitations,
        List<Friendship> friendships,
        List<Friendship2> friendships2,
        List<Post> posts,
        List<Comment> comments),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (full != null) {
      return full(id, name, userEventStatus, ownedEvents, invitations,
          friendships, friendships2, posts, comments);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_BaseProfile value), {
    @required Result full(_FullProfile value),
  }) {
    assert($default != null);
    assert(full != null);
    return full(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_BaseProfile value), {
    Result full(_FullProfile value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (full != null) {
      return full(this);
    }
    return orElse();
  }
}

abstract class _FullProfile extends Profile {
  const _FullProfile._() : super._();
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
  List<UsrEvntStats> get userEventStatus;
  List<Event> get ownedEvents;
  List<Invitation> get invitations;
  List<Friendship> get friendships;
  List<Friendship2> get friendships2;
  List<Post> get posts;
  List<Comment> get comments;
  @override
  _$FullProfileCopyWith<_FullProfile> get copyWith;
}
