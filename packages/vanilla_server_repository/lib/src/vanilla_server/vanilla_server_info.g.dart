// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vanilla_server_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VanillaServerInfo _$VanillaServerInfoFromJson(Map<String, dynamic> json) =>
    VanillaServerInfo(
      downloads: VanillaServerDownloadsInfo.fromJson(
          json['downloads'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VanillaServerInfoToJson(VanillaServerInfo instance) =>
    <String, dynamic>{
      'downloads': instance.downloads,
    };
