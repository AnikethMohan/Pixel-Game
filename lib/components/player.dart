import 'dart:async';
import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:pixel_game/components/collisions_block.dart';
import 'package:pixel_game/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  Player({
    position,
    this.character = 'Pink Man',
  }) : super(position: position);
  PlayerState playerstate = PlayerState.idle;

  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  double movespeed = 100;

  Vector2 velocity = Vector2.zero();
  double horizontalmovement = 0.0;
  double verticalmovement = 0.0;
  List<CollisionBlock> collisionblocks = [];
  final double _gravity = 9.8;
  final double _jumpForce = 260;
  final double _terminalVelocity = 300;
  bool isOnground = false;
  bool hasJumped = false;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();

    return super.onLoad();
  }

  //Updated
  @override
  void update(double dt) {
    _playerMovement(dt);
    _checkhorizontalCollision();
    _applyGravity(dt);
    _checkverticalCollision();

    if (hasJumped && isOnground) _playerJump(dt);

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalmovement = 0;
    verticalmovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRighttKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalmovement += isLeftKeyPressed ? -1 : 0;

    horizontalmovement += isRighttKeyPressed ? 1 : 0;
    updatePlayerState(isLeftKeyPressed, isRighttKeyPressed);

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimation() {
    //Declaring Idle Animations
    idleAnimation = _spriteAnimations('Idle', 11);

    //Declaring runnig Animations
    runningAnimation = _spriteAnimations('Run', 12);
    //List of all Animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

    //set current animations
    current = playerstate;
  }

  SpriteAnimation _spriteAnimations(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  void _playerMovement(double dt) {
    velocity.x = horizontalmovement * movespeed;

    position.x += velocity.x * dt;
  }

  void updatePlayerState(bool isLeftKeyPressed, bool isRighttKeyPressed) {
    horizontalmovement == 0
        ? current = PlayerState.idle
        : current = PlayerState.running;
    if (isLeftKeyPressed) {
      if (!isFlippedHorizontally) {
        flipHorizontallyAroundCenter();
      }
    }
    if (isRighttKeyPressed) {
      if (isFlippedHorizontally) {
        flipHorizontallyAroundCenter();
      }
    }
  }

  void _checkhorizontalCollision() {
    final playerbounds = toRect();
    for (final block in collisionblocks) {
      if (playerbounds.overlaps(block.toRect())) {
        if (horizontalmovement < 0) {
          position.x = block.toRect().right + playerbounds.width;
          break;
        }
        if (horizontalmovement > 0) {
          position.x = block.toRect().left - playerbounds.width;
          break;
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkverticalCollision() {
    final playerbounds = toRect();
    for (final block in collisionblocks) {
      if (block.isPlatform) {
        //for platform
        if (playerbounds.overlaps(block.toRect())) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            isOnground = true;
            break;
          }
        }
      }
      if (playerbounds.overlaps(block.toRect())) {
        if (velocity.y > 0) {
          velocity.y = 0;
          position.y = block.y - height;
          isOnground = true;
          break;
        }
        if (velocity.y < 0) {
          velocity.y = 0;

          position.y = block.y + block.height;
          break;
        }
      }
    }
  }

  _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    hasJumped = false;
    isOnground = false;
  }
}
