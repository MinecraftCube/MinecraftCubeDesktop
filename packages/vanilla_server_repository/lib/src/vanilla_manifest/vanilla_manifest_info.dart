import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:system_repository/src/vanilla_manifest/vanilla_manifest_version_info.dart';

part 'vanilla_manifest_info.g.dart';

@JsonSerializable()
class VanillaManifestInfo extends Equatable {
  const VanillaManifestInfo({
    required this.versions,
  });
  final List<VanillaManifestVersionInfo> versions;

  factory VanillaManifestInfo.fromJson(Map<String, dynamic> json) =>
      _$VanillaManifestInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VanillaManifestInfoToJson(this);

  @override
  List<Object> get props => [versions];
}
