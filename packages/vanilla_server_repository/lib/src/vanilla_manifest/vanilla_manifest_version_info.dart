import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vanilla_manifest_version_info.g.dart';

@JsonSerializable()
class VanillaManifestVersionInfo extends Equatable {
  const VanillaManifestVersionInfo({
    required this.id,
    required this.type,
    required this.url,
    required this.time,
    required this.releaseTime,
  });
  final String id;
  final String type;
  final String url;
  final DateTime time;
  final DateTime releaseTime;

  factory VanillaManifestVersionInfo.fromJson(Map<String, dynamic> json) =>
      _$VanillaManifestVersionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VanillaManifestVersionInfoToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      type,
      url,
      time,
      releaseTime,
    ];
  }
}
