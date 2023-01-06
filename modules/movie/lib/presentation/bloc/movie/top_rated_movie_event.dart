part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieEvent {
  const TopRatedMovieEvent();
}

class OnFetchTopRatedMovie extends TopRatedMovieEvent {}
