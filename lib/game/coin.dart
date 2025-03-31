import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '/models/enemy_data.dart';
import '/game/dino_run.dart';
import '/game/dino.dart';


class Coin extends SpriteComponent with CollisionCallbacks, HasGameReference<DinoRun> {
  late final SpriteComponent spriteComponent;
  Coin({
    required String spritePath,
    required Vector2 size,
  }) {
    _initialize(spritePath, size);
    // Thêm hitbox để kiểm tra va chạm
    add(RectangleHitbox());
  }

  Future<void> _initialize(String path, Vector2 size) async {
    // Tạo SpriteComponent và thêm vào Coin
    sprite = await Sprite.load(path);
  }


  @override
  void update(double dt) {
    super.update(dt);
    
    // Di chuyển coin từ phải sang trái với tốc độ linh hoạt
    position.x -= (100 + game.playerData.currentScore ~/ 10) * dt;

    // Nếu coin di chuyển ra ngoài màn hình bên trái, xóa nó
    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Kiểm tra nếu nhân vật (Dino) nhặt coin
    if (other is Dino) {
      // Cộng điểm cho người chơi
      game.playerData.currentScore += 10;
      game.playerData.addCoin;
      // Xóa coin khỏi game
      removeFromParent();
    }
  }
}