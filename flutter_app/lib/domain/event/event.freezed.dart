// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$EventTearOff {
  const _$EventTearOff();

// ignore: unused_element
  _Event call(
      {@required int id,
      @required EventName name,
      @required DateTime creationDate,
      @required EventDescription description,
      @required Profile owner}) {
    return _Event(
      id: id,
      name: name,
      creationDate: creationDate,
      description: description,
      owner: owner,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $Event = _$EventTearOff();

/// @nodoc
mixin _$Event {
  int get id;
  EventName get name;
  DateTime get creationDate;
  EventDescription get description;
  Profile get owner;

  $EventCopyWith<Event> get copyWith;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res>;
  $Res call(
      {int id,
      EventName name,
      DateTime creationDate,
      EventDescription description,
      Profile owner});

  $ProfileCopyWith<$Res> get owner;
}

/// @nodoc
class _$EventCopyWithImpl<$Res> implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  final Event _value;
  // ignore: unused_field
  final $Res Function(Event) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object creationDate = freezed,
    Object description = freezed,
    Object owner = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as EventName,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      description: description == freezed
          ? _value.description
          : description as EventDescription,
      owner: owner == freezed ? _value.owner : owner as Profile,
    ));
  }

  @override
  $ProfileCopyWith<$Res> get owner {
    if (_value.owner == null) {
      return null;
    }
    return $ProfileCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value));
    });
  }
}

/// @nodoc
abstract class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) then) =
      __$EventCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      EventName name,
      DateTime creationDate,
      EventDescription description,
      Profile owner});

  @override
  $ProfileCopyWith<$Res> get owner;
}

/// @nodoc
class __$EventCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(_Event _value, $Res Function(_Event) _then)
      : super(_value, (v) => _then(v as _Event));

  @override
  _Event get _value => super._value as _Event;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object creationDate = freezed,
    Object description = freezed,
    Object owner = freezed,
  }) {
    return _then(_Event(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as EventName,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      description: description == freezed
          ? _value.description
          : description as EventDescription,
      owner: owner == freezed ? _value.owner : owner as Profile,
    ));
  }
}

/// @nodoc
class _$_Event extends _Event {
  const _$_Event(
      {@required this.id,
      @required this.name,
      @required this.creationDate,
      @required this.description,
      @required this.owner})
      : assert(id != null),
        assert(name != null),
        assert(creationDate != null),
        assert(description != null),
        assert(owner != null),
        super._();

  @override
  final int id;
  @override
  final EventName name;
  @override
  final DateTime creationDate;
  @override
  final EventDescription description;
  @override
  final Profile owner;

  @override
  String toString() {
    return 'Event(id: $id, name: $name, creationDate: $creationDate, description: $description, owner: $owner)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Event &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.owner, owner) ||
                const DeepCollectionEquality().equals(other.owner, owner)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(owner);

  @override
  _$EventCopyWith<_Event> get copyWith =>
      __$EventCopyWithImpl<_Event>(this, _$identity);
}

abstract class _Event extends Event {
  const _Event._() : super._();
  const factory _Event(
      {@required int id,
      @required EventName name,
      @required DateTime creationDate,
      @required EventDescription description,
      @required Profile owner}) = _$_Event;

  @override
  int get id;
  @override
  EventName get name;
  @override
  DateTime get creationDate;
  @override
  EventDescription get description;
  @override
  Profile get owner;
  @override
  _$EventCopyWith<_Event> get copyWith;
}
