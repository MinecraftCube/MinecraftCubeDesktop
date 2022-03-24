import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:network_repository/network_repository.dart';

abstract class NetworkPublicIpEvent extends Equatable {
  const NetworkPublicIpEvent();
  @override
  List<Object?> get props => [];
}

class NetworkPublicIpStarted extends NetworkPublicIpEvent {
  const NetworkPublicIpStarted();
}

class NetworkPublicIpState extends Equatable {
  const NetworkPublicIpState({
    this.ip = '',
    this.status = NetworkStatus.uninit,
  });
  final String ip;
  final NetworkStatus status;

  NetworkPublicIpState copyWith({
    String? ip,
    NetworkStatus? status,
  }) {
    return NetworkPublicIpState(
      ip: ip ?? this.ip,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [ip, status];
}

class NetworkPublicIpBloc
    extends Bloc<NetworkPublicIpEvent, NetworkPublicIpState> {
  NetworkPublicIpBloc({required NetworkRepository networkRepository})
      : _networkRepository = networkRepository,
        super(const NetworkPublicIpState()) {
    on<NetworkPublicIpStarted>((event, emit) async {
      emit(state.copyWith(status: NetworkStatus.inProgress));
      try {
        final ip = await _networkRepository.getPublicIp();
        emit(state.copyWith(status: NetworkStatus.success, ip: ip));
      } catch (err) {
        emit(state.copyWith(status: NetworkStatus.failure, ip: 'Unavailable'));
      }
    });
  }

  final NetworkRepository _networkRepository;
}
