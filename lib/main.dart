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
  final List<ColorfulTile> _colorfulTiles = [];

  Iterable<GlobalKey<_ColorfulTileState>> get _keys =>
      _colorfulTiles.map((e) => e.key as GlobalKey<_ColorfulTileState>);

  ColorfulTile _newTile() {
    return ColorfulTile(
      key: GlobalKey<_ColorfulTileState>(),
      removeCallback: removeTile,
    );
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.defaultCount; i++) {
      _colorfulTiles.add(_newTile());
    }
  }

  @override
  Widget build(BuildContext context) {
    var tiles = (_colorfulTiles as List<Widget>) + [AddingTile(onTap: addTile)];
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
            tooltip: "Rotate backward",
            child: const Icon(Icons.skip_previous),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: forward,
            tooltip: "Rotate forward",
            child: const Icon(Icons.skip_next),
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
      _colorfulTiles.add(_colorfulTiles.removeAt(0));
    });
  }

  void forward() {
    setState(() {
      _colorfulTiles.insert(0, _colorfulTiles.removeLast());
    });
  }

  void addTile() {
    setState(() {
      _colorfulTiles.add(_newTile());
    });
  }

  void newColors() {
    for (var k in _keys) {
      k.currentState?.changeColor();
    }
  }

  void removeTile(Key? key) {
    setState(() {
      _colorfulTiles.removeWhere((e) => e.key == key);
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
  final void Function(Key? key) removeCallback;

  const ColorfulTile({super.key, required this.removeCallback});

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
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            color: myColor,
            height: 140.0,
            width: 140.0,
          ),
          IconButton(
            onPressed: () => widget.removeCallback(widget.key),
            icon: const Icon(Icons.close),
            iconSize: 15.0,
          ),
        ],
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
