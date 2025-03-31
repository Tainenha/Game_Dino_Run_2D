import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_data.g.dart';

// This class stores the player progress persistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  @HiveField(2) // Thêm HiveField để lưu số coin đã thu thập
  int coinsCollected = 0;

  @HiveField(3)
  int _lives = 5;

  int get lives => _lives;
  set lives(int value) {
    if (value <= 5 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  @HiveField(4) // Thêm HiveField để lưu điểm hiện tại
  int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;

    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    // Debug: In ra điểm số hiện tại và điểm cao nhất
    print('Current Score: $_currentScore');
    print('High Score: $highScore');

    notifyListeners();
    save();
  }

  // Phương thức để tăng số coin thu thập
  void addCoin() {
    coinsCollected += 1; // Tăng số coin thu thập được
    notifyListeners();
    save();
  }

  // Phương thức reset dữ liệu người chơi
  void reset() {
    _currentScore = 0;
    coinsCollected = 0; // Đặt lại số coin về 0
    _lives = 5;
    notifyListeners();
    save();
  }
}
