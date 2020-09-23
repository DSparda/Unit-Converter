import 'package:flutter/material.dart';
import 'package:hello_flutter/unit.dart';

class ConverterScreen extends StatefulWidget {
  final Color color;
  final List<Unit> units;

  const ConverterScreen({@required this.color, @required this.units})
      : assert(color != null),
        assert(units != null);

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  @override
  Widget build(BuildContext context) {
    final unitWidgets = widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text('Conversion: ${unit.conversion}',
                style: Theme.of(context).textTheme.headline5),
          ],
        ),
      );
    }).toList();

    /*return OrientationBuilder(builder: (context, orientation) {
      return GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
        childAspectRatio: 3.0,
        children: unitWidgets,
      );
    }); */

    return ListView(
      children: unitWidgets,
    );
  }
}
