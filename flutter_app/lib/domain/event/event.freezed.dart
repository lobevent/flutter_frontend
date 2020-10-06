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
      @required DateTime date,
      @required EventDescription description,
      @required Profile owner,
      @required bool public}) {
    return _Event(
      id: id,
      name: name,
      date: date,
      description: description,
      owner: owner,
      public: public,
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
  DateTime get date;
  EventDescription get description;
  Profile get owner;
  bool get public;

  $EventCopyWith<Event> get copyWith;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res>;
  $Res call(
      {int id,
      EventName name,
      DateTime date,
      EventDescription description,
      Profile owner,
      bool public});

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
    Object date = freezed,
    Object description = freezed,
    Object owner = freezed,
    Object public = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as EventName,
      date: date == freezed ? _value.date : date as DateTime,
      description: description == freezed
          ? _value.description
          : description as EventDescription,
      owner: owner == freezed ? _value.owner : owner as Profile,
      public: public == freezed ? _value.public : public as bool,
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
      DateTime date,
      EventDescription description,
      Profile owner,
      bool public});

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
    Object date = freezed,
    Object description = freezed,
    Object owner = freezed,
    Object public = freezed,
  }) {
    return _then(_Event(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as EventName,
      date: date == freezed ? _value.date : date as DateTime,
      description: description == freezed
          ? _value.description
          : description as EventDescription,
      owner: owner == freezed ? _value.owner : owner as Profile,
      public: public == freezed ? _value.public : public as bool,
    ));
  }
}

/// @nodoc
class _$_Event extends _Event {
  const _$_Event(
      {@required this.id,
      @required this.name,
      @required this.date,
      @required this.description,
      @required this.owner,
      @required this.public})
      : assert(id != null),
        assert(name != null),
        assert(date != null),
        assert(description != null),
        assert(owner != null),
        assert(public != null),
        super._();

  @override
  final int id;
  @override
  final EventName name;
  @override
  final DateTime date;
  @override
  final EventDescription description;
  @override
  final Profile owner;
  @override
  final bool public;

  @override
  String toString() {
    return 'Event(id: $id, name: $name, date: $date, description: $description, owner: $owner, public: $public)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Event &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.owner, owner) ||
                const DeepCollectionEquality().equals(other.owner, owner)) &&
            (identical(other.public, public) ||
                const DeepCollectionEquality().equals(other.public, public)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(owner) ^
      const DeepCollectionEquality().hash(public);

  @override
  _$EventCopyWith<_Event> get copyWith =>
      __$EventCopyWithImpl<_Event>(this, _$identity);
}

abstract class _Event extends Event {
  const _Event._() : super._();
  const factory _Event(
      {@required int id,
      @required EventName name,
      @required DateTime date,
      @required EventDescription description,
      @required Profile owner,
      @required bool public}) = _$_Event;

  @override
  int get id;
  @override
  EventName get name;
  @override
  DateTime get date;
  @override
  EventDescription get description;
  @override
  Profile get owner;
  @override
  bool get public;
  @override
  _$EventCopyWith<_Event> get copyWith;
}
