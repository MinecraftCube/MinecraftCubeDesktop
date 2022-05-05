import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'server_configuration.g.dart';

@JsonSerializable()
class ServerConfiguration extends Equatable {
  final bool? isAgreeDangerous;
  const ServerConfiguration({
    this.isAgreeDangerous,
  });

  factory ServerConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$ServerConfigurationToJson(this);

  @override
  List<Object?> get props => [isAgreeDangerous];
}
