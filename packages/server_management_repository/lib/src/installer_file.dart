import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';

class InstallerFile extends Equatable {
  final Installer installer;
  final String path;
  const InstallerFile({
    required this.installer,
    required this.path,
  });

  @override
  List<Object> get props => [installer, path];
}
