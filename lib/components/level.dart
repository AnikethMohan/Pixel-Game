import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_game/components/collisions_block.dart';
import 'package:pixel_game/components/player.dart';

class Level extends World {
  late TiledComponent level;
  Level({required this.levelnumber, required this.player});
  Player player = Player();
  String levelnumber;
  List<CollisionBlock> collisionblocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelnumber.tmx', Vector2.all(16));

    add(level);
    final spawnPointslayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointslayer != null) {
      for (final spwanpoints in spawnPointslayer.objects) {
        switch (spwanpoints.class_) {
          case 'Player':
            player.position = Vector2(spwanpoints.x, spwanpoints.y);
            add(player);
            break;
          default:
        }
      }
      final collisionslayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

      if (collisionslayer != null) {
        for (final collision in collisionslayer.objects) {
          switch (collision.class_) {
            case 'Platform':
              final platform = CollisionBlock(
                  position: Vector2(collision.x, collision.y),
                  size: Vector2(
                    collision.width,
                    collision.height,
                  ),
                  isPlatform: true);
              collisionblocks.add(platform);
              add(platform);
              break;
            default:
              final block = CollisionBlock(
                  position: Vector2(collision.x, collision.y),
                  size: Vector2(collision.width, collision.height));
              collisionblocks.add(block);
              add(block);
          }
        }
        player.collisionblocks = collisionblocks;
      }
    }

    // TODO: implement onLoad
    return super.onLoad();
  }
}
