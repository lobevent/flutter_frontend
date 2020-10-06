// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EventDto _$_$_EventDtoFromJson(Map<String, dynamic> json) {
  return _$_EventDto(
    id: json['id'] as int,
    name: json['name'] as String,
    public: json['public'] as bool,
    description: json['description'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$_$_EventDtoToJson(_$_EventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'public': instance.public,
      'description': instance.description,
      'date': instance.date?.toIso8601String(),
    };
