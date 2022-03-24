import 'package:equatable/equatable.dart';

class JavaInfo extends Equatable {
  const JavaInfo({
    required this.executablePaths,
    required this.name,
    this.output = '',
  });
  final List<String> executablePaths;
  final String name;
  final String output;

  @override
  List<Object?> get props => [executablePaths, name, output];

  JavaInfo copyWith({
    List<String>? executablePaths,
    String? name,
    String? output,
  }) {
    return JavaInfo(
      executablePaths: executablePaths ?? this.executablePaths,
      name: name ?? this.name,
      output: output ?? this.output,
    );
  }
}
