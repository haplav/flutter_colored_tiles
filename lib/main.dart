import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PositionedTiles()));

class PositionedTiles extends StatefulWidget {
  const PositionedTiles({super.key});

  @override
  State<StatefulWidget> createState() => PositionedTilesState(3);
}

class PositionedTilesState extends State<PositionedTiles> {
  int count;
  final List<ColorfulTile> _tiles = [];

  PositionedTilesState(this.count) {
    for (int i = 0; i < count; i++) {
      _tiles.add(ColorfulTile(key: GlobalKey<_ColorfulTileState>()));
    }
  }

  Iterable<GlobalKey<_ColorfulTileState>> get _keys =>
      _tiles.map((e) => e.key as GlobalKey<_ColorfulTileState>);

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

  void newColors() {
    for (var k in _keys) {
      k.currentState?.changeColor();
    }
  }
}

class ColorfulTile extends StatefulWidget {
  const ColorfulTile({super.key});

  @override
  State<ColorfulTile> createState() => _ColorfulTileState();
}

class _ColorfulTileState extends State<ColorfulTile> {
  Color myColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    changeColor();
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
