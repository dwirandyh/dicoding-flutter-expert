part of 'movie_recommendation_bloc.dart';

abstract class MovieRecommendationEvent {}

class OnFetchMovieRecommendation extends MovieRecommendationEvent {
  final int id;

  OnFetchMovieRecommendation(this.id);
}
