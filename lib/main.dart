import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PositionedTilesState(3),
      child: const MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.centerLeft,
            child: PositionedTiles(),
          ),
          floatingActionButton: FloatingButtons(),
        ),
      ),
    );
  }
}

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PositionedTilesState>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: state.backward,
          tooltip: "Shift left",
          child: const Icon(Icons.keyboard_double_arrow_left),
        ),
        const SizedBox(width: 10.0),
        FloatingActionButton(
          onPressed: state.forward,
          tooltip: "Shift right",
          child: const Icon(Icons.keyboard_double_arrow_right),
        ),
        const SizedBox(width: 10.0),
        FloatingActionButton(
          onPressed: state.newColors,
          tooltip: "New colors",
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}

class PositionedTiles extends StatelessWidget {
  const PositionedTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PositionedTilesState>();

    List<Widget> tiles =
        state.tileDataList.map((data) => ColorfulTile(data) as Widget).toList();
    tiles.add(AddingTile(onTap: state.addTile));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: tiles),
      ),
    );
  }
}

class PositionedTilesState extends ChangeNotifier {
  final List<ColorfulTileData> _tileDataList = [];

  List<ColorfulTileData> get tileDataList => _tileDataList;
  int get count => _tileDataList.length;

  PositionedTilesState(int defaultCount) {
    for (int i = 0; i < defaultCount; i++) {
      _tileDataList.add(ColorfulTileData());
    }
  }

  void backward() {
    _tileDataList.add(_tileDataList.removeAt(0));
    notifyListeners();
  }

  void forward() {
    _tileDataList.insert(0, _tileDataList.removeLast());
    notifyListeners();
  }

  void addTile() {
    _tileDataList.add(ColorfulTileData());
    notifyListeners();
  }

  void newColors() {
    for (var data in _tileDataList) {
      data.color = UniqueColorGenerator.getColor();
    }
    notifyListeners();
  }

  void changeTileColor(ColorfulTileData data) {
    data.color = UniqueColorGenerator.getColor();
    notifyListeners();
  }

  void moveTileLeft(ColorfulTileData data) {
    int origPosition = _tileDataList.indexOf(data);
    int newPosition = (origPosition - 1) % _tileDataList.length;
    _tileDataList.removeAt(origPosition);
    _tileDataList.insert(newPosition, data);
    notifyListeners();
  }

  void moveTileRight(ColorfulTileData data) {
    int origPosition = _tileDataList.indexOf(data);
    int newPosition = (origPosition + 1) % _tileDataList.length;
    _tileDataList.removeAt(origPosition);
    _tileDataList.insert(newPosition, data);
    notifyListeners();
  }

  void removeTile(ColorfulTileData data) {
    _tileDataList.remove(data);
    notifyListeners();
  }
}

class AddingTile extends StatelessWidget {
  final VoidCallback onTap;

  const AddingTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: "Add a new tile",
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          child: const SizedBox(
            height: 140.0,
            width: 140.0,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

Color getContrastingColor(Color color) {
  Brightness brightness = ThemeData.estimateBrightnessForColor(color);
  return brightness == Brightness.light ? Colors.black : Colors.white;
}

typedef AlignedIconConfig = ({
  AlignmentGeometry alignment,
  String description,
  IconData icon,
  Function(PositionedTilesState, ColorfulTileData) onTap,
});

class AlignedIconButton extends StatelessWidget {
  final AlignedIconConfig cfg;
  final Color color;
  final ColorfulTileData data;

  const AlignedIconButton(
    this.cfg, {
    super.key,
    required this.color,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PositionedTilesState>();
    return Align(
        alignment: cfg.alignment,
        child: IconButton(
          icon: Icon(cfg.icon, color: color),
          iconSize: 15.0,
          onPressed: () => cfg.onTap(state, data),
          tooltip: cfg.description,
        ));
  }
}

class ColorfulTile extends StatelessWidget {
  final ColorfulTileData data;
  final Color iconColor;

  ColorfulTile(
    this.data, {
    super.key,
  }) : iconColor = getContrastingColor(data.color);

  static List<AlignedIconConfig> get controls {
    return [
      (
        alignment: Alignment.topLeft,
        description: "Change tile color",
        icon: Icons.refresh,
        onTap: (state, data) => state.changeTileColor(data),
      ),
      (
        alignment: Alignment.topRight,
        description: "Remove tile",
        icon: Icons.close,
        onTap: (state, data) => state.removeTile(data),
      ),
      (
        alignment: Alignment.bottomLeft,
        description: "Move tile left",
        icon: Icons.chevron_left,
        onTap: (state, data) => state.moveTileLeft(data),
      ),
      (
        alignment: Alignment.bottomRight,
        description: "Move tile right",
        icon: Icons.chevron_right,
        onTap: (state, data) => state.moveTileRight(data),
      ),
    ];
  }

  List<AlignedIconButton> get _buttons => controls
      .map((e) => AlignedIconButton(
            e,
            color: iconColor,
            data: data,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Container(
              color: data.color,
              height: 140.0,
              width: 140.0,
            ),
            ..._buttons,
          ],
        ),
      ),
    );
  }
}

class ColorfulTileData {
  Color color;

  ColorfulTileData({Color? color})
      : color = color ?? UniqueColorGenerator.getColor();
}

class UniqueColorGenerator {
  static Random random = Random();

  static Color getColor() {
    return Color.fromARGB(
      0xFF,
      random.nextInt(0x100),
      random.nextInt(0x100),
      random.nextInt(0x100),
    );
  }
}
