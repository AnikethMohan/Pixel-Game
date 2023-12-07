import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pixel_game/components/player.dart';
import 'package:pixel_game/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xff211F30);
  late final CameraComponent cam;
  // late JoystickComponent joystick;
  Player player = Player();
  bool showjoystick = false;
  @override
  FutureOr<void> onLoad() async {
    final world = Level(
      levelnumber: 'Level-01',
      player: player,
    );
    //loading images to cache
    await images.loadAllImages();
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world)
      ..priority = 0;
    // TODO: implement onLoad

    cam.viewfinder.anchor = Anchor.topLeft;
    // @override
    // void update(double dt) {
    //  // updateJoystick(joystick);
    //   super.update(dt);
    // }

    // addjoystick();

    addAll([cam, world]);

    return super.onLoad();
  }

  // void addjoystick() {
  //   final joystick = JoystickComponent(
  //       knobRadius: 30,
  //       priority: 1,
  //       knob: SpriteComponent(
  //         sprite: Sprite(
  //           images.fromCache('HUD/Knob.png'),
  //         ),
  //       ),
  //       background: SpriteComponent(
  //         sprite: Sprite(
  //           images.fromCache('HUD/Joystick.png'),
  //         ),
  //       ),
  //       margin: EdgeInsets.only(bottom: 30, left: 10));
  //   add(joystick);
  // }

  void updateJoystick(JoystickComponent joystick) {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.downLeft:
      case JoystickDirection.upLeft:
        // player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        // player.playerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.idle:
        // player.playerDirection = PlayerDirection.none;
        break;
      default:
    }
  }
}
