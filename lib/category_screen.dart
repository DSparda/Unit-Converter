import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_flutter/backdrop.dart';
import 'package:hello_flutter/category_tile.dart';
import 'package:hello_flutter/caterory.dart';
import 'package:hello_flutter/unit.dart';
import 'package:hello_flutter/converter_screen.dart';
import 'package:hello_flutter/api.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen();

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  //Note here to CRUD Listview
  final _categories = <Caterory>[];

  Caterory _defaultCategory;
  Caterory _currentCategory;

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  static const _icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  Future<void> _retrieveLocalCategories() async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    var categoryIndex = 0;
    data.keys.forEach((key) {
      final List<Unit> units =
      data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();
      var category = Caterory(
          name: key,
          units: units,
          color: _baseColors[categoryIndex],
          iconLocation: _icons[categoryIndex]);
      setState(() {
        if (categoryIndex == 0) {
          _defaultCategory = category;
        }
        _categories.add(category);
      });
      categoryIndex += 1;
    });
  }

  Future<void> _retrieveApiCategory() async {
    setState(() {
      _categories.add(Caterory(
          name: apiCategory['name'],
          units: [],
          color: _baseColors.last,
          iconLocation: _icons.last));
    });
    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(Unit.fromJson(unit));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(Caterory(
            name: apiCategory['name'],
            iconLocation: _icons.last,
            color: _baseColors.last,
            units: units
        ));
      });
    }
  }

  void _onCategoryTap(Caterory caterory) {
    setState(() {
      _currentCategory = caterory;
    });
  }

  Widget _buildCategoryWidgets(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            var _category = _categories[index];
            return CategoryTile(
              caterory: _category,
              onTap: _category.name == apiCategory['name'] &&
                  _category.units.isEmpty ? null : _onCategoryTap,
            );
          },
          itemCount: _categories.length);
    } else {
      return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3.0,
          children: _categories.map((Caterory c) {
            return CategoryTile(
              caterory: c,
              onTap: _onCategoryTap,
            );
          }).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    assert(debugCheckHasMediaQuery(context));
    final listView = Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 48.0),
      child: _buildCategoryWidgets(MediaQuery
          .of(context)
          .orientation),
    );

    return Backdrop(
      currentCategory:
      _currentCategory == null ? _defaultCategory : _currentCategory,
      frontPanel: _currentCategory == null
          ? ConverterScreen(caterory: _defaultCategory)
          : ConverterScreen(caterory: _currentCategory),
      backPanel: listView,
      frontTile: Text('Unit Converter'),
      backTile: Text('Select a Category'),
    );
  }
}
