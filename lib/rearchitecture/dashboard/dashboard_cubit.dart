import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:zenon_syrius_wallet_flutter/utils/constants.dart';
import 'package:znn_sdk_dart/znn_sdk_dart.dart';

part 'dashboard_state.dart';

/// An abstract `DashboardCubit` class that manages periodic data fetching for a
/// dashboard feature. The cubit emits different states based on data loading,
/// success, or failure, and it periodically refreshes the data automatically.
///
/// The generic type [T] represents the type of data managed by this cubit.
abstract class DashboardCubit<T> extends Cubit<DashboardState<T>> {
  /// A timer that handles the auto-refreshing of data.
  Timer? _autoRefresher;

  /// The Zenon client used to fetch data from the Zenon ledger.
  final Zenon zenon;
  final Duration refreshInterval;

  /// Constructs a `DashboardCubit` with the provided [zenon] client and initial state.
  ///
  /// The auto-refresh functionality is initialized upon the cubit's creation.
  DashboardCubit(this.zenon, super.initialState, {this.refreshInterval = kDashboardRefreshInterval}) {
    _startAutoRefresh();
  }

  /// Fetches data of type [T] that is managed by the cubit.
  ///
  /// This method needs to be implemented by subclasses, and it should define
  /// the specific data-fetching logic (e.g., fetching account information).
  Future<T> fetch();

  /// Returns a [Timer] that triggers the auto-refresh functionality after
  /// the predefined [kDashboardRefreshInterval].
  ///
  /// This method cancels any existing timers and initiates a new periodic
  /// fetch cycle by calling [_fetchDataPeriodically].
  Timer _getAutoRefreshTimer() => Timer(
    refreshInterval,
        () {
      _autoRefresher!.cancel();
      _fetchDataPeriodically();
    },
  );

  /// Periodically fetches data and updates the state with either success or failure.
  ///
  /// This method fetches new data by calling [fetch], emits a loading state while
  /// fetching, and updates the state with success or failure based on the outcome.
  /// If the WebSocket client is closed, it throws a [noConnectionException].
  Future<void> _fetchDataPeriodically() async {
    try {
      emit(state.copyWith(status: CubitStatus.loading));
      if (!zenon.wsClient.isClosed()) {
        final T? data = await fetch();
        emit(state.copyWith(data: data, status: CubitStatus.success));
      } else {
        throw noConnectionException;
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.failure, error: e));
    } finally {
      /// Ensure that the auto-refresher is restarted if it's not active.
      if (_autoRefresher == null) {
        _autoRefresher = _getAutoRefreshTimer();
      } else if (!_autoRefresher!.isActive) {
        _autoRefresher = _getAutoRefreshTimer();
      }
    }
  }

  /// Starts the auto-refresh cycle by initializing the [_autoRefresher] timer.
  void _startAutoRefresh() {
    _autoRefresher = _getAutoRefreshTimer();
  }

  /// Cancels the auto-refresh timer and closes the cubit.
  ///
  /// This method is called when the cubit is closed, ensuring that no background
  /// tasks remain active after the cubit is disposed.
  @override
  Future<void> close() {
    _autoRefresher?.cancel();
    return super.close();
  }
}
