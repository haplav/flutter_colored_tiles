import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PositionedTiles()));

class PositionedTiles extends StatefulWidget {
  const PositionedTiles();

  @override
  State<StatefulWidget> createState() => PositionedTilesState(3);
}

class PositionedTilesState extends State<PositionedTiles> {
  int count;
  List<Widget> tiles = [];

  PositionedTilesState(this.count) {
    newTiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: tiles),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => setState(swapTiles),
            tooltip: "Swap tiles",
            child: const Icon(Icons.swap_horiz),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: () => setState(newTiles),
            tooltip: "New colors",
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void swapTiles() {
    tiles.insert(0, tiles.removeLast());
  }

  void newTiles() {
    Set<Color> colorSet = {};
    while (colorSet.length < count) {
      var newColor = UniqueColorGenerator.getColor();
      if (!colorSet.contains(newColor)) {
        colorSet.add(newColor);
      }
    }
    tiles = colorSet.map((e) => ColorfulTile(e)).toList();
  }
}

class ColorfulTile extends StatelessWidget {
  final Color myColor;

  ColorfulTile(this.myColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: myColor,
      height: 140.0,
      width: 140.0,
    );
  }
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
