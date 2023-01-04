import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_recommendation_event.dart';
part 'movie_recommendation_state.dart';

class MovieRecommendationBloc
    extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationBloc({required this.getMovieRecommendations})
      : super(MovieRecommendationLoading()) {
    on<OnFetchMovieRecommendation>(onFetchMovieRecommendation);
  }

  Future<void> onFetchMovieRecommendation(OnFetchMovieRecommendation event,
      Emitter<MovieRecommendationState> emit) async {
    emit(MovieRecommendationLoading());

    final result = await getMovieRecommendations.execute(event.id);

    result.fold((failure) {
      emit(MovieRecommendationError(failure.message));
    }, (movies) {
      emit(MovieRecommendationHasData(movies));
    });
  }
}
