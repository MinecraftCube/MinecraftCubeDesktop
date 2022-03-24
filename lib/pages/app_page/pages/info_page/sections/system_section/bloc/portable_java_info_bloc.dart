import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:java_info_repository/java_info_repository.dart';

abstract class PortableJavaInfoEvent extends Equatable {
  const PortableJavaInfoEvent();
  @override
  List<Object?> get props => [];
}

class PortableJavaInfoStarted extends PortableJavaInfoEvent {
  const PortableJavaInfoStarted();
}

class PortableJavaInfoState extends Equatable {
  const PortableJavaInfoState({
    this.infos = const [],
    this.status = NetworkStatus.uninit,
  });
  final List<JavaInfo> infos;
  final NetworkStatus status;

  PortableJavaInfoState copyWith({
    List<JavaInfo>? infos,
    NetworkStatus? status,
  }) {
    return PortableJavaInfoState(
      infos: infos ?? this.infos,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [infos, status];
}

class PortableJavaInfoBloc
    extends Bloc<PortableJavaInfoEvent, PortableJavaInfoState> {
  PortableJavaInfoBloc({
    required JavaInfoRepository javaInfoRepository,
  })  : _javaInfoRepository = javaInfoRepository,
        super(const PortableJavaInfoState()) {
    on<PortableJavaInfoStarted>((event, emit) async {
      emit(state.copyWith(status: NetworkStatus.inProgress));
      try {
        final List<JavaInfo> infos = [];
        await for (final info in _javaInfoRepository.getPortableJavas()) {
          infos.add(info);
        }
        emit(state.copyWith(status: NetworkStatus.success, infos: infos));
      } catch (_) {
        emit(state.copyWith(status: NetworkStatus.failure));
      }
    });
  }

  final JavaInfoRepository _javaInfoRepository;
}
