part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent {
  const TvDetailEvent();
}

class OnFetchTvDetail extends TvDetailEvent {
  final int id;

  const OnFetchTvDetail(this.id);
}
