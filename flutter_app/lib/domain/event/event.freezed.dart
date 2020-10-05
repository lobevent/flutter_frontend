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
  _Event call({@required int Id, @required String content}) {
    return _Event(
      Id: Id,
      content: content,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $Event = _$EventTearOff();

/// @nodoc
mixin _$Event {
  int get Id;
  String get content;

  $EventCopyWith<Event> get copyWith;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res>;
  $Res call({int Id, String content});
}

/// @nodoc
class _$EventCopyWithImpl<$Res> implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  final Event _value;
  // ignore: unused_field
  final $Res Function(Event) _then;

  @override
  $Res call({
    Object Id = freezed,
    Object content = freezed,
  }) {
    return _then(_value.copyWith(
      Id: Id == freezed ? _value.Id : Id as int,
      content: content == freezed ? _value.content : content as String,
    ));
  }
}

/// @nodoc
abstract class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) then) =
      __$EventCopyWithImpl<$Res>;
  @override
  $Res call({int Id, String content});
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
    Object Id = freezed,
    Object content = freezed,
  }) {
    return _then(_Event(
      Id: Id == freezed ? _value.Id : Id as int,
      content: content == freezed ? _value.content : content as String,
    ));
  }
}

/// @nodoc
class _$_Event implements _Event {
  const _$_Event({@required this.Id, @required this.content})
      : assert(Id != null),
        assert(content != null);

  @override
  final int Id;
  @override
  final String content;

  @override
  String toString() {
    return 'Event(Id: $Id, content: $content)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Event &&
            (identical(other.Id, Id) ||
                const DeepCollectionEquality().equals(other.Id, Id)) &&
            (identical(other.content, content) ||
                const DeepCollectionEquality().equals(other.content, content)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(Id) ^
      const DeepCollectionEquality().hash(content);

  @override
  _$EventCopyWith<_Event> get copyWith =>
      __$EventCopyWithImpl<_Event>(this, _$identity);
}

abstract class _Event implements Event {
  const factory _Event({@required int Id, @required String content}) = _$_Event;

  @override
  int get Id;
  @override
  String get content;
  @override
  _$EventCopyWith<_Event> get copyWith;
}
