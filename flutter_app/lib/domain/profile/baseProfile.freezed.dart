// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'baseProfile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$BaseProfileTearOff {
  const _$BaseProfileTearOff();

// ignore: unused_element
  _BaseProfile call({@required int id, @required ProfileName name}) {
    return _BaseProfile(
      id: id,
      name: name,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $BaseProfile = _$BaseProfileTearOff();

/// @nodoc
mixin _$BaseProfile {
  int get id;
  ProfileName get name;

  $BaseProfileCopyWith<BaseProfile> get copyWith;
}

/// @nodoc
abstract class $BaseProfileCopyWith<$Res> {
  factory $BaseProfileCopyWith(
          BaseProfile value, $Res Function(BaseProfile) then) =
      _$BaseProfileCopyWithImpl<$Res>;
  $Res call({int id, ProfileName name});
}

/// @nodoc
class _$BaseProfileCopyWithImpl<$Res> implements $BaseProfileCopyWith<$Res> {
  _$BaseProfileCopyWithImpl(this._value, this._then);

  final BaseProfile _value;
  // ignore: unused_field
  final $Res Function(BaseProfile) _then;

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
abstract class _$BaseProfileCopyWith<$Res>
    implements $BaseProfileCopyWith<$Res> {
  factory _$BaseProfileCopyWith(
          _BaseProfile value, $Res Function(_BaseProfile) then) =
      __$BaseProfileCopyWithImpl<$Res>;
  @override
  $Res call({int id, ProfileName name});
}

/// @nodoc
class __$BaseProfileCopyWithImpl<$Res> extends _$BaseProfileCopyWithImpl<$Res>
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
class _$_BaseProfile implements _BaseProfile {
  const _$_BaseProfile({@required this.id, @required this.name})
      : assert(id != null),
        assert(name != null);

  @override
  final int id;
  @override
  final ProfileName name;

  @override
  String toString() {
    return 'BaseProfile(id: $id, name: $name)';
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
}

abstract class _BaseProfile implements BaseProfile {
  const factory _BaseProfile({@required int id, @required ProfileName name}) =
      _$_BaseProfile;

  @override
  int get id;
  @override
  ProfileName get name;
  @override
  _$BaseProfileCopyWith<_BaseProfile> get copyWith;
}
