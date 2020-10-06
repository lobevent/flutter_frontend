// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'event_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
EventDto _$EventDtoFromJson(Map<String, dynamic> json) {
  return _EventDto.fromJson(json);
}

/// @nodoc
class _$EventDtoTearOff {
  const _$EventDtoTearOff();

// ignore: unused_element
  _EventDto call(
      {@required int id,
      @required String name,
      @required bool public,
      @required String description,
      @required DateTime date,
      @required DateTime creationDate}) {
    return _EventDto(
      id: id,
      name: name,
      public: public,
      description: description,
      date: date,
      creationDate: creationDate,
    );
  }

// ignore: unused_element
  EventDto fromJson(Map<String, Object> json) {
    return EventDto.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $EventDto = _$EventDtoTearOff();

/// @nodoc
mixin _$EventDto {
  int get id;
  String get name;
  bool get public;
  String get description;
  DateTime get date;
  DateTime get creationDate;

  Map<String, dynamic> toJson();
  $EventDtoCopyWith<EventDto> get copyWith;
}

/// @nodoc
abstract class $EventDtoCopyWith<$Res> {
  factory $EventDtoCopyWith(EventDto value, $Res Function(EventDto) then) =
      _$EventDtoCopyWithImpl<$Res>;
  $Res call(
      {int id,
      String name,
      bool public,
      String description,
      DateTime date,
      DateTime creationDate});
}

/// @nodoc
class _$EventDtoCopyWithImpl<$Res> implements $EventDtoCopyWith<$Res> {
  _$EventDtoCopyWithImpl(this._value, this._then);

  final EventDto _value;
  // ignore: unused_field
  final $Res Function(EventDto) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object public = freezed,
    Object description = freezed,
    Object date = freezed,
    Object creationDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as String,
      public: public == freezed ? _value.public : public as bool,
      description:
          description == freezed ? _value.description : description as String,
      date: date == freezed ? _value.date : date as DateTime,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$EventDtoCopyWith<$Res> implements $EventDtoCopyWith<$Res> {
  factory _$EventDtoCopyWith(_EventDto value, $Res Function(_EventDto) then) =
      __$EventDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      String name,
      bool public,
      String description,
      DateTime date,
      DateTime creationDate});
}

/// @nodoc
class __$EventDtoCopyWithImpl<$Res> extends _$EventDtoCopyWithImpl<$Res>
    implements _$EventDtoCopyWith<$Res> {
  __$EventDtoCopyWithImpl(_EventDto _value, $Res Function(_EventDto) _then)
      : super(_value, (v) => _then(v as _EventDto));

  @override
  _EventDto get _value => super._value as _EventDto;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object public = freezed,
    Object description = freezed,
    Object date = freezed,
    Object creationDate = freezed,
  }) {
    return _then(_EventDto(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as String,
      public: public == freezed ? _value.public : public as bool,
      description:
          description == freezed ? _value.description : description as String,
      date: date == freezed ? _value.date : date as DateTime,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_EventDto extends _EventDto {
  const _$_EventDto(
      {@required this.id,
      @required this.name,
      @required this.public,
      @required this.description,
      @required this.date,
      @required this.creationDate})
      : assert(id != null),
        assert(name != null),
        assert(public != null),
        assert(description != null),
        assert(date != null),
        assert(creationDate != null),
        super._();

  factory _$_EventDto.fromJson(Map<String, dynamic> json) =>
      _$_$_EventDtoFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final bool public;
  @override
  final String description;
  @override
  final DateTime date;
  @override
  final DateTime creationDate;

  @override
  String toString() {
    return 'EventDto(id: $id, name: $name, public: $public, description: $description, date: $date, creationDate: $creationDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _EventDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.public, public) ||
                const DeepCollectionEquality().equals(other.public, public)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(public) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(creationDate);

  @override
  _$EventDtoCopyWith<_EventDto> get copyWith =>
      __$EventDtoCopyWithImpl<_EventDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_EventDtoToJson(this);
  }
}

abstract class _EventDto extends EventDto {
  const _EventDto._() : super._();
  const factory _EventDto(
      {@required int id,
      @required String name,
      @required bool public,
      @required String description,
      @required DateTime date,
      @required DateTime creationDate}) = _$_EventDto;

  factory _EventDto.fromJson(Map<String, dynamic> json) = _$_EventDto.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  bool get public;
  @override
  String get description;
  @override
  DateTime get date;
  @override
  DateTime get creationDate;
  @override
  _$EventDtoCopyWith<_EventDto> get copyWith;
}
