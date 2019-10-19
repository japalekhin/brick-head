import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:brick_head/brick-game.dart';
import 'package:flutter/widgets.dart';

class Brick {
  final BrickGame game;
  Body body;

  TextPainter tp;
  Offset to;

  Paint paint;
  PolygonShape shape; // for physics
  Path path; // for appearance

  int _hp;
  int get hp {
    return _hp;
  }

  set hp(int value) {
    _hp = value;
    tp.text = TextSpan(
      text: _hp.toString(),
      style: game.textStyle,
    );
    tp.layout();
    to = Offset(tp.width / -2, .0625);
  }

  Brick(this.game, Vector2 position, {int hp}) {
    hp ??= 300;
    tp = TextPainter();
    tp.textAlign = TextAlign.center;
    tp.textDirection = TextDirection.ltr;
    this.hp = hp;

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
    fd.friction = 0;
    fd.shape = shape;
    Fixture ff = body.createFixtureFromFixtureDef(fd);
    ff.userData = 'brick';
  }

  void render(Canvas c) {
    c.save();
    c.translate(body.position.x, body.position.y);
    c.drawPath(path, paint);
    tp.paint(c, to);
    c.restore();
  }

  void update(double t) {}
}
