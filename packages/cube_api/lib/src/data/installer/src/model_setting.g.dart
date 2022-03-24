// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelSetting _$ModelSettingFromJson(Map<String, dynamic> json) => ModelSetting(
      name: json['name'] as String,
      program: json['program'] as String,
      path: json['path'] as String,
    );

Map<String, dynamic> _$ModelSettingToJson(ModelSetting instance) =>
    <String, dynamic>{
      'name': instance.name,
      'program': instance.program,
      'path': instance.path,
    };
