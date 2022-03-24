import 'package:cube_api/src/data/jar/jar_type.dart';
import 'package:equatable/equatable.dart';

class JarArchiveInfo extends Equatable {
  final JarType type;
  final String executable;
  const JarArchiveInfo({
    required this.type,
    required this.executable,
  });

  @override
  List<Object> get props => [type, executable];

  JarArchiveInfo copyWith({
    JarType? type,
    String? executable,
  }) {
    return JarArchiveInfo(
      type: type ?? this.type,
      executable: executable ?? this.executable,
    );
  }
}
