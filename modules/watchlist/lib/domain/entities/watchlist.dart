import 'package:equatable/equatable.dart';

enum WatchListType { movie, tv }

class Watchlist extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final WatchListType type;

  const Watchlist(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.overview,
      required this.type});

  @override
  List<Object?> get props => [id, title, posterPath, overview, type];
}
