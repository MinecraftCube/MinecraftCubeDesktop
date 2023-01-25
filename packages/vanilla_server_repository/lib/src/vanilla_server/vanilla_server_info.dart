import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:system_repository/src/vanilla_server/vanilla_server_downloads_info.dart';

part 'vanilla_server_info.g.dart';

@JsonSerializable()
class VanillaServerInfo extends Equatable {
  const VanillaServerInfo({
    required this.downloads,
  });

  final VanillaServerDownloadsInfo downloads;

  factory VanillaServerInfo.fromJson(Map<String, dynamic> json) =>
      _$VanillaServerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VanillaServerInfoToJson(this);

  @override
  List<Object> get props => [downloads];
}
