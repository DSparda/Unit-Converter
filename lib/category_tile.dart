import 'package:flutter/material.dart';
import 'package:hello_flutter/caterory.dart';

const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

class CategoryTile extends StatelessWidget {
  final Caterory caterory;
  final ValueChanged<Caterory> onTap;

  const CategoryTile({Key key, @required this.caterory, @required this.onTap})
      : assert(caterory != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: (Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: caterory.color['highlight'],
          splashColor: caterory.color['splash'],
          onTap: () => onTap(caterory),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.asset(caterory.iconLocation),
                ),
                Center(
                  child: Text(
                    caterory.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
