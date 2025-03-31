import 'dart:math';
import 'package:flame/components.dart';
import '/game/coin.dart';
import '/game/dino_run.dart';

class CoinManager extends Component with HasGameReference<DinoRun> {
  final Random _random = Random();
  final Timer _timer = Timer(2, repeat: true);

  CoinManager() {
    _timer.onTick = spawnRandomCoin;
  }

  void spawnRandomCoin() {
    // Lấy vị trí của "Bat" và "Rino" trong game.
    final batY = game.virtualSize.y - 24 - 60; // Vị trí cao nhất (Bat)
    final rinoY = game.virtualSize.y - 40;    // Vị trí thấp nhất (Rino)

    // Tạo vị trí y ngẫu nhiên trong khoảng từ rinoY đến batY.
    final yPosition = _random.nextBool() ? batY : rinoY;

    // Tốc độ của coin (tương tự enemy).
    final speed = 80 + (game.playerData.currentScore ~/ 5) * 0.1;

    // Tạo coin mới.
    final coin = Coin(
      spritePath: 'Coin/coin.png',
      size: Vector2(16, 16),
    );


    coin.position = Vector2(game.virtualSize.x + 32, yPosition);
    game.world.add(coin);
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllCoins() {
    final coins = game.world.children.whereType<Coin>();
    for (var coin in coins) {
      coin.removeFromParent();
    }
  }
}
