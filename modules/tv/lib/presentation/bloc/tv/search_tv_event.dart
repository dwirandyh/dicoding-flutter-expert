part of 'search_tv_bloc.dart';

abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object> get props => [];
}

class OnSearchTvQueryChanged extends SearchTvEvent {
  final String query;

  const OnSearchTvQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class OnSearchTvInitState extends SearchTvEvent {
  const OnSearchTvInitState();

  @override
  List<Object> get props => [];
}
