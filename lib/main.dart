import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PositionedTiles()));

class PositionedTiles extends StatefulWidget {
  const PositionedTiles();

  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  List<Widget> tiles = [
    ColorfulTile(),
    ColorfulTile(),
  ];

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

  swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }

  newTiles() {
    setState(() {
      tiles = [
        ColorfulTile(),
        ColorfulTile(),
      ];
    });
  }
}

class ColorfulTile extends StatelessWidget {
  final Color myColor;

  ColorfulTile() : myColor = UniqueColorGenerator.getColor();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: myColor,
      child: const Padding(padding: EdgeInsets.all(70.0)),
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
