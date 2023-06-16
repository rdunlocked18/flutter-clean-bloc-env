import 'dart:async';

import 'package:clean_architecture_tdd_course/global/shared/bloc/network_event.dart';
import 'package:clean_architecture_tdd_course/global/shared/bloc/network_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  InternetConnectionChecker _checker = InternetConnectionChecker();
  StreamSubscription? _connectivitySubscription;

  NetworkBloc() : super(NetworkInitialState()) {
    on<NetworkLostEvent>((event, emit) => emit(NetworkLostState()));
    on<NetworkGainedEvent>((event, emit) => emit(NetworkGainedState()));

    _connectivitySubscription = _checker.onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');
          add(NetworkGainedEvent());
          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          add(NetworkLostEvent());
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
