import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:brick_head/brick-game.dart';

class Brick {
  final BrickGame game;
  Body body;

  Paint paint;
  PolygonShape shape; // for physics
  Path path; // for appearance

  Brick(this.game, Vector2 position) {
    List<Vector2> vectors = <Vector2>[
      Vector2(-.25, -.25),
      Vector2(.25, -.25),
      Vector2(.25, .25),
      Vector2(-.25, .25),
    ];
    shape = PolygonShape();
    shape.set(vectors, vectors.length);

    path = Path();
    path.addPolygon(<Offset>[
      Offset(vectors[0].x, vectors[0].y),
      Offset(vectors[1].x, vectors[1].y),
      Offset(vectors[2].x, vectors[2].y),
      Offset(vectors[3].x, vectors[3].y),
    ], true);

    paint = Paint();
    paint.color = Color(0xffffffff);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = .03;

    BodyDef bd = BodyDef();
    bd.linearVelocity = Vector2.zero();
    bd.position = position;
    bd.type = BodyType.STATIC;
    body = game.world.createBody(bd);
    body.userData = this;

    FixtureDef fd = FixtureDef();
    fd.density = 20;
    fd.restitution = 1;
    fd.friction = 1;
    fd.shape = shape;
    Fixture ff = body.createFixtureFromFixtureDef(fd);
    ff.userData = 'brick';
  }

  void render(Canvas c) {
    c.save();
    c.translate(body.position.x, body.position.y);
    c.drawPath(path, paint);
    c.restore();
  }

  void update(double t) {}
}
