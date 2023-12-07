import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  CollisionBlock({position, size, this.isPlatform = false})
      : super(position: position, size: size) {
    debugMode = true;
  }
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }
}
