import 'package:equatable/equatable.dart';

class MemoryInfo extends Equatable {
  final double? totalSize;
  final double? freeSize;
  const MemoryInfo({
    this.totalSize = -1,
    this.freeSize = -1,
  });

  MemoryInfo copyWith({
    double? totalSize,
    double? freeSize,
  }) {
    return MemoryInfo(
      totalSize: totalSize ?? this.totalSize,
      freeSize: freeSize ?? this.freeSize,
    );
  }

  @override
  List<Object?> get props => [totalSize, freeSize];
}
