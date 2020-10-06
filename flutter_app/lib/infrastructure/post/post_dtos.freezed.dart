// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'post_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
PostDto _$PostDtoFromJson(Map<String, dynamic> json) {
  return _PostDto.fromJson(json);
}

/// @nodoc
class _$PostDtoTearOff {
  const _$PostDtoTearOff();

// ignore: unused_element
  _PostDto call(
      {@required int id,
      @required DateTime creationDate,
      @required String postContent,
      @required String owner,
      @required EventDto event}) {
    return _PostDto(
      id: id,
      creationDate: creationDate,
      postContent: postContent,
      owner: owner,
      event: event,
    );
  }

// ignore: unused_element
  PostDto fromJson(Map<String, Object> json) {
    return PostDto.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $PostDto = _$PostDtoTearOff();

/// @nodoc
mixin _$PostDto {
  int get id;
  DateTime get creationDate;
  String get postContent;
  String get owner;
  EventDto get event;

  Map<String, dynamic> toJson();
  $PostDtoCopyWith<PostDto> get copyWith;
}

/// @nodoc
abstract class $PostDtoCopyWith<$Res> {
  factory $PostDtoCopyWith(PostDto value, $Res Function(PostDto) then) =
      _$PostDtoCopyWithImpl<$Res>;
  $Res call(
      {int id,
      DateTime creationDate,
      String postContent,
      String owner,
      EventDto event});

  $EventDtoCopyWith<$Res> get event;
}

/// @nodoc
class _$PostDtoCopyWithImpl<$Res> implements $PostDtoCopyWith<$Res> {
  _$PostDtoCopyWithImpl(this._value, this._then);

  final PostDto _value;
  // ignore: unused_field
  final $Res Function(PostDto) _then;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object postContent = freezed,
    Object owner = freezed,
    Object event = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      postContent:
          postContent == freezed ? _value.postContent : postContent as String,
      owner: owner == freezed ? _value.owner : owner as String,
      event: event == freezed ? _value.event : event as EventDto,
    ));
  }

  @override
  $EventDtoCopyWith<$Res> get event {
    if (_value.event == null) {
      return null;
    }
    return $EventDtoCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value));
    });
  }
}

/// @nodoc
abstract class _$PostDtoCopyWith<$Res> implements $PostDtoCopyWith<$Res> {
  factory _$PostDtoCopyWith(_PostDto value, $Res Function(_PostDto) then) =
      __$PostDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      DateTime creationDate,
      String postContent,
      String owner,
      EventDto event});

  @override
  $EventDtoCopyWith<$Res> get event;
}

/// @nodoc
class __$PostDtoCopyWithImpl<$Res> extends _$PostDtoCopyWithImpl<$Res>
    implements _$PostDtoCopyWith<$Res> {
  __$PostDtoCopyWithImpl(_PostDto _value, $Res Function(_PostDto) _then)
      : super(_value, (v) => _then(v as _PostDto));

  @override
  _PostDto get _value => super._value as _PostDto;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object postContent = freezed,
    Object owner = freezed,
    Object event = freezed,
  }) {
    return _then(_PostDto(
      id: id == freezed ? _value.id : id as int,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      postContent:
          postContent == freezed ? _value.postContent : postContent as String,
      owner: owner == freezed ? _value.owner : owner as String,
      event: event == freezed ? _value.event : event as EventDto,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_PostDto extends _PostDto {
  const _$_PostDto(
      {@required this.id,
      @required this.creationDate,
      @required this.postContent,
      @required this.owner,
      @required this.event})
      : assert(id != null),
        assert(creationDate != null),
        assert(postContent != null),
        assert(owner != null),
        assert(event != null),
        super._();

  factory _$_PostDto.fromJson(Map<String, dynamic> json) =>
      _$_$_PostDtoFromJson(json);

  @override
  final int id;
  @override
  final DateTime creationDate;
  @override
  final String postContent;
  @override
  final String owner;
  @override
  final EventDto event;

  @override
  String toString() {
    return 'PostDto(id: $id, creationDate: $creationDate, postContent: $postContent, owner: $owner, event: $event)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PostDto &&
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
                const DeepCollectionEquality().equals(other.event, event)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(postContent) ^
      const DeepCollectionEquality().hash(owner) ^
      const DeepCollectionEquality().hash(event);

  @override
  _$PostDtoCopyWith<_PostDto> get copyWith =>
      __$PostDtoCopyWithImpl<_PostDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PostDtoToJson(this);
  }
}

abstract class _PostDto extends PostDto {
  const _PostDto._() : super._();
  const factory _PostDto(
      {@required int id,
      @required DateTime creationDate,
      @required String postContent,
      @required String owner,
      @required EventDto event}) = _$_PostDto;

  factory _PostDto.fromJson(Map<String, dynamic> json) = _$_PostDto.fromJson;

  @override
  int get id;
  @override
  DateTime get creationDate;
  @override
  String get postContent;
  @override
  String get owner;
  @override
  EventDto get event;
  @override
  _$PostDtoCopyWith<_PostDto> get copyWith;
}
