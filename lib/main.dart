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
  final List<Widget> _tiles = [];

  Iterable<GlobalKey<_ColorfulTileState>> get _keys =>
      _tiles.map((e) => e.key as GlobalKey<_ColorfulTileState>);

  ColorfulTile _newTile() {
    return ColorfulTile(
      key: GlobalKey<_ColorfulTileState>(),
    );
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.defaultCount; i++) {
      _tiles.add(_newTile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: _tiles + [AddingTile(onTap: addTile)]),
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

  void addTile() {
    setState(() {
      _tiles.add(_newTile());
    });
  }

  void newColors() {
    for (var k in _keys) {
      k.currentState?.changeColor();
    }
  }
}

class AddingTile extends StatelessWidget {
  final VoidCallback onTap;

  const AddingTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
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
    return GestureDetector(
      onTap: changeColor,
      child: Container(
        color: myColor,
        height: 140.0,
        width: 140.0,
      ),
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
