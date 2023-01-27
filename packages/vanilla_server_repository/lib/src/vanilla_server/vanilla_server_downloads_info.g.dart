// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vanilla_server_downloads_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VanillaServerDownloadsInfo _$VanillaServerDownloadsInfoFromJson(
        Map<String, dynamic> json) =>
    VanillaServerDownloadsInfo(
      server: VanillaServerDownloadsServerInfo.fromJson(
          json['server'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VanillaServerDownloadsInfoToJson(
        VanillaServerDownloadsInfo instance) =>
    <String, dynamic>{
      'server': instance.server,
    };
