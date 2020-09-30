import 'package:flutter/material.dart';
import 'package:hello_flutter/unit.dart';
import 'package:meta/meta.dart';

class Caterory {
  final String name;
  final ColorSwatch color;
  final String iconLocation;
  final List<Unit> units;

  const Caterory(
      {@required this.name,
      @required this.color,
      @required this.iconLocation,
      @required this.units})
      : assert(name != null),
        assert(color != null),
        assert(iconLocation != null),
        assert(units != null);
}
