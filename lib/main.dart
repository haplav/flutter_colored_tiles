import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => PositionedTilesState(3),
      child: const MaterialApp(
        home: PositionedTiles(),
      ),
    ));

class PositionedTiles extends StatelessWidget {
  const PositionedTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PositionedTilesState>();

    List<Widget> tiles = state.tileDataList
        .map((data) => ColorfulTile(data: data) as Widget)
        .toList();
    tiles.add(AddingTile(onTap: state.addTile));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: tiles),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: state.backward,
            tooltip: "Rotate left",
            child: const Icon(Icons.keyboard_double_arrow_left),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: state.forward,
            tooltip: "Rotate right",
            child: const Icon(Icons.keyboard_double_arrow_right),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: state.newColors,
            tooltip: "New colors",
            child: const Icon(Icons.refresh),
          ),
        ],
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

class ColorfulTile extends StatelessWidget {
  final ColorfulTileData data;

  const ColorfulTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PositionedTilesState>();
    final iconColor = getContrastingColor(data.color);
    return Stack(
      children: [
        GestureDetector(
          onTap: () => state.changeTileColor(data),
          child: Tooltip(
            message: "Change tile color",
            child: Container(
              color: data.color,
              height: 140.0,
              width: 140.0,
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: IconButton(
            onPressed: () => state.removeTile(data),
            icon: const Icon(Icons.close),
            iconSize: 15.0,
            color: iconColor,
            tooltip: "Remove tile",
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          child: IconButton(
            onPressed: () => state.moveTileLeft(data),
            icon: const Icon(Icons.keyboard_arrow_left),
            iconSize: 18.0,
            color: iconColor,
            tooltip: "Move tile left",
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: IconButton(
            onPressed: () => state.moveTileRight(data),
            icon: const Icon(Icons.keyboard_arrow_right),
            iconSize: 18.0,
            color: iconColor,
            tooltip: "Move tile right",
          ),
        ),
      ],
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
