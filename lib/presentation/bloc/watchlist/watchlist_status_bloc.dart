import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_status_event.dart';
part 'watchlist_status_state.dart';

class WatchlistStatusBloc
    extends Bloc<WatchlistStatusEvent, WatchlistStatusState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistStatusBloc(
      {required this.getWatchListStatus,
      required this.saveWatchlist,
      required this.removeWatchlist})
      : super(WatchlistStatusState(isExists: false, isSuccess: true)) {
    on<OnGetWatchlistStatus>(onGetWatchlistStatus);
    on<OnAddToWatchlist>(onAddToWatchlist);
    on<OnRemoveFromWatchlist>(onRemoveFromWatchlist);
  }

  Future<void> onGetWatchlistStatus(
      OnGetWatchlistStatus event, Emitter<WatchlistStatusState> emit) async {
    final isExists = await getWatchListStatus.execute(event.id);
    emit(WatchlistStatusState(isExists: isExists, isSuccess: true));
  }

  Future<void> onAddToWatchlist(
      OnAddToWatchlist event, Emitter<WatchlistStatusState> emit) async {
    final state = WatchlistStatusState(isExists: true, isSuccess: true);

    final result = await saveWatchlist.execute(event.watchlist);
    result.fold(
      (failure) {
        state.isExists = false;
        state.isSuccess = false;
        state.additionalMessage = failure.message;
      },
      (successMessage) {
        state.isExists = true;
        state.isSuccess = true;
        state.additionalMessage = watchlistAddSuccessMessage;
      },
    );
    emit(state);
  }

  Future<void> onRemoveFromWatchlist(
      OnRemoveFromWatchlist event, Emitter<WatchlistStatusState> emit) async {
    final state = WatchlistStatusState(isExists: false, isSuccess: true);

    final result = await removeWatchlist.execute(event.watchlist);
    result.fold(
      (failure) {
        state.isExists = true;
        state.isSuccess = false;
        state.additionalMessage = failure.message;
      },
      (successMessage) {
        state.isExists = false;
        state.isSuccess = true;
        state.additionalMessage = watchlistRemoveSuccessMessage;
      },
    );
    emit(state);
  }
}
