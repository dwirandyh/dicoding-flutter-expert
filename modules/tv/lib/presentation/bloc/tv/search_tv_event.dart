part of 'search_tv_bloc.dart';

abstract class SearchTvEvent {
  const SearchTvEvent();
}

class OnSearchTvQueryChanged extends SearchTvEvent {
  final String query;

  const OnSearchTvQueryChanged(this.query);
}

class OnSearchTvInitState extends SearchTvEvent {
  const OnSearchTvInitState();
}
