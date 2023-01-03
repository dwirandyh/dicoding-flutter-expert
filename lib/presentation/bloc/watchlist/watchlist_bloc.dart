import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/usecases/get_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistBloc({required this.getWatchlistMovies})
      : super(WatchlistInitial()) {
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
