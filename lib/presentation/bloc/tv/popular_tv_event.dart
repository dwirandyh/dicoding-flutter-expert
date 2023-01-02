part of 'popular_tv_bloc.dart';

abstract class PopularTvEvent extends Equatable {
  const PopularTvEvent();
}

class OnFetchPopularTv extends PopularTvEvent {
  List<Object?> get props => [];
}
