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
  final List<ColorfulTile> _tiles = [];

  PositionedTilesState(this.count) {
    _tiles.addAll(
        List.generate(count, (index) => ColorfulTile(key: UniqueKey())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: _tiles),
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
            onPressed: newColors,
            tooltip: "New colors",
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void swapTiles() {
    setState(() {
      _tiles.insert(0, _tiles.removeLast());
    });
  }

  void _newColors() {
    for (var tile in _tiles) {
      tile.changeColor();
    }
  }

  void newColors() {
    setState(_newColors);
  }
}

class ColorfulTile extends StatefulWidget {
  ColorfulTile({super.key});

  late final VoidCallback changeColor;

  @override
  State<ColorfulTile> createState() => _ColorfulTileState();
}

class _ColorfulTileState extends State<ColorfulTile> {
  Color myColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    changeColor();
    widget.changeColor = changeColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: myColor,
      height: 140.0,
      width: 140.0,
    );
  }

  void changeColor() {
    setState(() {
      myColor = UniqueColorGenerator.getColor();
    });
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
