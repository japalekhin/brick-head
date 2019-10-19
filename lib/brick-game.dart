import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:brick_head/components/ball.dart';
import 'package:brick_head/components/brick.dart';
import 'package:flame/game.dart';

class BrickGame extends Game implements ContactListener {
  World world;
  Size screenSize;
  Size tileGrid;

  List<Brick> bricks;
  List<Ball> balls;

  BrickGame() {
    world = World.withPool(
      Vector2(0, 0),
      DefaultWorldPool(100, 10),
    );
    world.setContactListener(this);
  }

  @override
  void render(Canvas c) {
    if (screenSize == null) {
      return;
    }

    c.save();
    c.scale(screenSize.width / 9);
    c.translate(4.5, tileGrid.height * .5);

    bricks.forEach((Brick b) => b.render(c));
    balls.forEach((Ball b) => b.render(c));

    c.restore();
  }

  @override
  void update(double t) {
    if (screenSize == null) {
      return;
    }

    bricks.forEach((Brick b) => b.update(t));
    balls.forEach((Ball b) => b.update(t));
  }

  @override
  void resize(Size size) {
    screenSize = size;
    tileGrid = Size(9, size.height / (size.width / 9));

    // bricks
    if (bricks == null) {
      bricks = List<Brick>();
      for (double y = -7.5; y <= -2.5; y += .5) {
        for (double x = -4; x <= 4; x += .5) {
          bricks.add(Brick(this, Vector2(x, y)));
        }
      }
    }

    // balls
    if (balls == null) {
      balls = List<Ball>();
    }
  }

  @override
  void beginContact(Contact contact) {}

  @override
  void endContact(Contact contact) {}

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {}

  @override
  void preSolve(Contact contact, Manifold oldManifold) {}
}
