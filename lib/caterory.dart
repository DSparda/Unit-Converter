import 'package:flutter/material.dart';
import 'package:hello_flutter/unit.dart';
import 'package:meta/meta.dart';

import 'Converter Screen.dart';

final _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

class Caterory extends StatelessWidget {
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;
  final List<Unit> units;

  const Caterory(
      {Key key,
      @required this.name,
      @required this.color,
      @required this.iconLocation,
      @required this.units})
      : assert(name != null),
        assert(color != null),
        assert(iconLocation != null),
        assert(units != null),
        super(key: key);

  void _navigateToConverter(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          title: Text(
            name,
            style: Theme.of(context).textTheme.headline4,
          ),
          centerTitle: true,
          backgroundColor: color,
        ),
        body: ConverterScreen(color: color, units: units),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: color,
          splashColor: color,
          onTap: () => _navigateToConverter(context),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    iconLocation,
                    size: 60.0,
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
