import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/domain/entities/watchlist.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

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
      : super(const WatchlistStatusState(isExists: false, isSuccess: true)) {
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
    bool isExists = false;
    bool isSuccess = false;
    String? additionalMessage;

    final result = await saveWatchlist.execute(event.watchlist);
    result.fold(
      (failure) {
        isExists = false;
        isSuccess = false;
        additionalMessage = failure.message;
      },
      (successMessage) {
        isExists = true;
        isSuccess = true;
        additionalMessage = watchlistAddSuccessMessage;
      },
    );
    emit(WatchlistStatusState(
      isExists: isExists,
      isSuccess: isSuccess,
      additionalMessage: additionalMessage,
    ));
  }

  Future<void> onRemoveFromWatchlist(
      OnRemoveFromWatchlist event, Emitter<WatchlistStatusState> emit) async {
    bool isExists = false;
    bool isSuccess = false;
    String? additionalMessage;

    final result = await removeWatchlist.execute(event.watchlist);
    result.fold(
      (failure) {
        isExists = true;
        isSuccess = false;
        additionalMessage = failure.message;
      },
      (successMessage) {
        isExists = false;
        isSuccess = true;
        additionalMessage = watchlistRemoveSuccessMessage;
      },
    );
    emit(WatchlistStatusState(
      isExists: isExists,
      isSuccess: isSuccess,
      additionalMessage: additionalMessage,
    ));
  }
}
