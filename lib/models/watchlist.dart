import 'package:flutter/foundation.dart';
import 'movie.dart';

class WatchlistModel extends ChangeNotifier {
  final Map<int, WatchStatus> _statuses = {};
  final Map<int, double> _userRatings = {};

  WatchStatus getStatus(int id) => _statuses[id] ?? WatchStatus.notWatched;
  double? getUserRating(int id) => _userRatings[id];

  int get watchedCount => _statuses.values.where((s) => s == WatchStatus.watched).length;
  int get watchingCount => _statuses.values.where((s) => s == WatchStatus.watching).length;
  int get wishlistCount => _statuses.values.where((s) => s == WatchStatus.wishlist).length;

  void setStatus(int id, WatchStatus status) {
    if (_statuses[id] == status) {
      _statuses.remove(id);
    } else {
      _statuses[id] = status;
    }
    notifyListeners();
  }

  void setUserRating(int id, double rating) {
    _userRatings[id] = rating;
    notifyListeners();
  }

  bool isInList(int id) => _statuses.containsKey(id);
}
