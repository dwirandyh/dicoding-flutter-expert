part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();
}

class OnFetchTvDetail extends TvDetailEvent {
  final int id;

  OnFetchTvDetail(this.id);

  @override
  List<Object?> get props => [];
}
