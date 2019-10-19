import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:brick_head/brick-game.dart';

class Ball {
  final BrickGame game;
  Body body;

  bool isStarted = false;

  Paint paint;
  CircleShape shape;

  Ball(this.game, Vector2 position) {
    shape = CircleShape();
    shape.p.setFrom(Vector2(0, 0));
    shape.radius = .25;

    paint = Paint();
    paint.color = Color(0xffffffff);

    BodyDef bd = BodyDef();
    bd.linearVelocity = Vector2.zero();
    bd.position = position;
    bd.fixedRotation = true;
    bd.bullet = true;
    bd.type = BodyType.DYNAMIC;
    body = game.world.createBody(bd);
    body.userData = this;

    FixtureDef fd = FixtureDef();
    fd.density = 10;
    fd.restitution = 1;
    fd.friction = 0;
    fd.shape = shape;
    Fixture ff = body.createFixtureFromFixtureDef(fd);
    ff.userData = 'ball';
  }

  void render(Canvas c) {
    c.save();
    c.translate(body.position.x, body.position.y);
    c.drawCircle(Offset(0, 0), .25, paint);
    c.restore();
  }

  void update(double t) {
    if (!isStarted) {
      isStarted = true;
      MassData data = MassData();
      body.getMassData(data);

      body.applyLinearImpulse(
        Vector2(
          data.mass * 15,
          data.mass * -15,
        ),
        body.position,
        true,
      );
    }
  }
}
