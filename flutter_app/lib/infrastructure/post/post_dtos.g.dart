// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostDto _$_$_PostDtoFromJson(Map<String, dynamic> json) {
  return _$_PostDto(
    id: json['id'] as int,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    postContent: json['postContent'] as String,
    owner: json['owner'] as String,
    event: json['event'] as String,
  );
}

Map<String, dynamic> _$_$_PostDtoToJson(_$_PostDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate?.toIso8601String(),
      'postContent': instance.postContent,
      'owner': instance.owner,
      'event': instance.event,
    };
