part of 'watchlist_status_bloc.dart';

class WatchlistStatusState extends Equatable {
  bool isExists;
  bool isSuccess;
  String? additionalMessage;

  WatchlistStatusState({
    required this.isExists,
    required this.isSuccess,
    this.additionalMessage,
  });

  @override
  List<Object?> get props => [isExists, isSuccess, additionalMessage];
}
