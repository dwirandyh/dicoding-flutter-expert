import 'package:watchlist/domain/entities/watchlist.dart';
import 'package:equatable/equatable.dart';

class WatchListTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String type;

  WatchListTable(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.overview,
      required this.type});

  factory WatchListTable.fromEntity(Watchlist watchlist) => WatchListTable(
      id: watchlist.id,
      title: watchlist.title,
      posterPath: watchlist.posterPath,
      overview: watchlist.overview,
      type: watchlist.type == WatchListType.tv ? "tv" : "movie");

  factory WatchListTable.fromMap(Map<String, dynamic> map) => WatchListTable(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      overview: map['overview'],
      type: map['type']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'type': type
      };

  Watchlist toEntity() => Watchlist(
      id: id,
      overview: overview,
      posterPath: posterPath,
      title: title,
      type: type == "tv" ? WatchListType.tv : WatchListType.movie);

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview, type];
}
