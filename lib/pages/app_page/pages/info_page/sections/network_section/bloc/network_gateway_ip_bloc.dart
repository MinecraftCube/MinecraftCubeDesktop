import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:network_repository/network_repository.dart';

abstract class NetworkGatewayIpEvent extends Equatable {
  const NetworkGatewayIpEvent();
  @override
  List<Object?> get props => [];
}

class NetworkGatewayIpStarted extends NetworkGatewayIpEvent {
  const NetworkGatewayIpStarted();
}

class NetworkGatewayIpState extends Equatable {
  const NetworkGatewayIpState({
    this.ips = const [],
    this.status = NetworkStatus.uninit,
  });
  final Iterable<String> ips;
  final NetworkStatus status;

  NetworkGatewayIpState copyWith({
    Iterable<String>? ips,
    NetworkStatus? status,
  }) {
    return NetworkGatewayIpState(
      ips: ips ?? this.ips,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [ips, status];
}

class NetworkGatewayIpBloc
    extends Bloc<NetworkGatewayIpEvent, NetworkGatewayIpState> {
  NetworkGatewayIpBloc({required NetworkRepository networkRepository})
      : _networkRepository = networkRepository,
        super(const NetworkGatewayIpState()) {
    on<NetworkGatewayIpStarted>((event, emit) async {
      emit(state.copyWith(status: NetworkStatus.inProgress));
      try {
        final ips = await _networkRepository.getGatewayIps();
        emit(state.copyWith(status: NetworkStatus.success, ips: ips));
      } catch (err) {
        emit(state.copyWith(status: NetworkStatus.failure, ips: []));
      }
    });
  }

  final NetworkRepository _networkRepository;
}
