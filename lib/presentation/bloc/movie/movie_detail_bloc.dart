import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;

  MovieDetailBloc({required this.getMovieDetail})
      : super(MovieDetailLoading()) {
    on<OnFetchMovieDetail>(onFetchMovieDetail);
  }

  Future<void> onFetchMovieDetail(
      OnFetchMovieDetail event, Emitter<MovieDetailState> emit) async {
    emit(MovieDetailLoading());
    final detailResult = await getMovieDetail.execute(event.id);
    detailResult.fold((failure) {
      emit(MovieDetailError(failure.message));
    }, (result) {
      final movieDetail = result;
      emit(MovieDetailHasData(movieDetail));
    });
  }
}
