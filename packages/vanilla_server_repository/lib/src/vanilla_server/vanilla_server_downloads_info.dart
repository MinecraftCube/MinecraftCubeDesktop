import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:system_repository/src/vanilla_server/vanilla_server_downloads_server_info.dart';

part 'vanilla_server_downloads_info.g.dart';

@JsonSerializable()
class VanillaServerDownloadsInfo extends Equatable {
  const VanillaServerDownloadsInfo({
    required this.server,
  });
  final VanillaServerDownloadsServerInfo server;

  factory VanillaServerDownloadsInfo.fromJson(Map<String, dynamic> json) =>
      _$VanillaServerDownloadsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VanillaServerDownloadsInfoToJson(this);

  @override
  List<Object> get props => [server];
}
