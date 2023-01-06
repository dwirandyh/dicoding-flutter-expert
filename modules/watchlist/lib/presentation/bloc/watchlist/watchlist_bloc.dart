import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/domain/entities/watchlist.dart';
import 'package:watchlist/domain/usecases/get_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistBloc({required this.getWatchlistMovies})
      : super(WatchlistLoading()) {
    on<OnFetchWatchlist>(_onFetchWatchlist);
  }

  Future<void> _onFetchWatchlist(
      OnFetchWatchlist event, Emitter<WatchlistState> emit) async {
    emit(WatchlistLoading());

    final result = await getWatchlistMovies.execute();

    result.fold((failure) {
      emit(WatchlistError(failure.message));
    }, (watchlist) {
      emit(WatchlistHasData(watchlist));
    });
  }
}
