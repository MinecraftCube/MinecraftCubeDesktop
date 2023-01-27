import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vanilla_server_downloads_server_info.g.dart';

@JsonSerializable()
class VanillaServerDownloadsServerInfo extends Equatable {
  const VanillaServerDownloadsServerInfo({
    required this.sha1,
    required this.size,
    required this.url,
  });

  final String sha1;
  final int size;
  final String url;

  factory VanillaServerDownloadsServerInfo.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$VanillaServerDownloadsServerInfoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VanillaServerDownloadsServerInfoToJson(this);

  @override
  List<Object> get props => [sha1, size, url];
}
