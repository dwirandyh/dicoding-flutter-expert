part of 'popular_movie_bloc.dart';

abstract class PopularMovieEvent extends Equatable {
  const PopularMovieEvent();
}

class OnFetchPopularMovie extends PopularMovieEvent {
  List<Object?> get props => [];
}
