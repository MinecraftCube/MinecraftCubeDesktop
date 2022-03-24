import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:java_info_repository/java_info_repository.dart';

abstract class SystemJavaInfoEvent extends Equatable {
  const SystemJavaInfoEvent();
  @override
  List<Object?> get props => [];
}

class SystemJavaInfoStarted extends SystemJavaInfoEvent {
  const SystemJavaInfoStarted();
}

class SystemJavaInfoState extends Equatable {
  const SystemJavaInfoState({
    this.info,
    this.status = NetworkStatus.uninit,
  });
  final JavaInfo? info;
  final NetworkStatus status;

  SystemJavaInfoState copyWith({
    JavaInfo? info,
    NetworkStatus? status,
  }) {
    return SystemJavaInfoState(
      info: info ?? this.info,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [info, status];
}

class SystemJavaInfoBloc
    extends Bloc<SystemJavaInfoEvent, SystemJavaInfoState> {
  SystemJavaInfoBloc({
    required JavaInfoRepository javaInfoRepository,
  })  : _javaInfoRepository = javaInfoRepository,
        super(const SystemJavaInfoState()) {
    on<SystemJavaInfoStarted>((event, emit) async {
      emit(state.copyWith(status: NetworkStatus.inProgress));
      try {
        final JavaInfo info = await _javaInfoRepository.getSystemJava();
        emit(state.copyWith(status: NetworkStatus.success, info: info));
      } catch (_) {
        emit(state.copyWith(status: NetworkStatus.failure));
      }
    });
  }

  final JavaInfoRepository _javaInfoRepository;
}
