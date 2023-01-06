part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent {
  const MovieDetailEvent();
}

class OnFetchMovieDetail extends MovieDetailEvent {
  final int id;

  const OnFetchMovieDetail(this.id);
}
