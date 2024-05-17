import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PositionedTiles(3)));

class PositionedTiles extends StatefulWidget {
  final int defaultCount;

  const PositionedTiles(this.defaultCount, {super.key});

  @override
  State<StatefulWidget> createState() => _PositionedTilesState();
}

class _PositionedTilesState extends State<PositionedTiles> {
  final List<ColorfulTileData> _tileDataList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.defaultCount; i++) {
      _tileDataList.add(ColorfulTileData());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = _tileDataList
        .map((data) => ColorfulTile(
              data: data,
              changeColorCallback: changeTileColor,
              removeCallback: removeTile,
            ) as Widget)
        .toList();
    tiles.add(AddingTile(onTap: addTile));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: tiles),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: backward,
            tooltip: "Rotate left",
            child: const Icon(Icons.keyboard_double_arrow_left),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: forward,
            tooltip: "Rotate right",
            child: const Icon(Icons.keyboard_double_arrow_right),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: newColors,
            tooltip: "New colors",
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void backward() {
    setState(() {
      _tileDataList.add(_tileDataList.removeAt(0));
    });
  }

  void forward() {
    setState(() {
      _tileDataList.insert(0, _tileDataList.removeLast());
    });
  }

  void addTile() {
    setState(() {
      _tileDataList.add(ColorfulTileData());
    });
  }

  void newColors() {
    setState(() {
      for (var data in _tileDataList) {
        data.color = UniqueColorGenerator.getColor();
      }
    });
  }

  void changeTileColor(ColorfulTileData data) {
    setState(() {
      data.color = UniqueColorGenerator.getColor();
    });
  }

  void removeTile(ColorfulTileData data) {
    setState(() {
      _tileDataList.remove(data);
    });
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
  final void Function(ColorfulTileData data) changeColorCallback;
  final void Function(ColorfulTileData data) removeCallback;

  const ColorfulTile({
    super.key,
    required this.data,
    required this.changeColorCallback,
    required this.removeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () => changeColorCallback(data),
          child: Tooltip(
            message: "Change tile color",
            child: Container(
              color: data.color,
              height: 140.0,
              width: 140.0,
            ),
          ),
        ),
        IconButton(
          onPressed: () => removeCallback(data),
          icon: const Icon(Icons.close),
          iconSize: 15.0,
          color: getContrastingColor(data.color),
          tooltip: "Remove tile",
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
