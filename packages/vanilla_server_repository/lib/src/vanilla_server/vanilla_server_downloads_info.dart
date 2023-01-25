import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vanilla_server_repository/vanilla_server_repository.dart';

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
