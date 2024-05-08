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
    _newTiles();
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
            onPressed: swapTiles,
            tooltip: "Swap tiles",
            child: const Icon(Icons.swap_horiz),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: newTiles,
            tooltip: "New colors",
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void swapTiles() {
    setState(() {
      tiles.insert(0, tiles.removeLast());
    });
  }

  void _newTiles() {
    tiles = List.generate(count, (index) => ColorfulTile());
  }

  void newTiles() {
    setState(_newTiles);
  }
}

class ColorfulTile extends StatefulWidget {
  @override
  State<ColorfulTile> createState() => _ColorfulTileState();
}

class _ColorfulTileState extends State<ColorfulTile> {
  late Color myColor;

  @override
  void initState() {
    super.initState();
    myColor = UniqueColorGenerator.getColor();
  }

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
