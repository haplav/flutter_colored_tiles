import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

bool isDesktop() {
  return (Platform.isMacOS || Platform.isLinux || Platform.isWindows);
}

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

    List<Widget> tiles = [
      ...state.tileDataList.map((data) => ColorfulTile(data) as Widget),
      const AddingTile(),
    ];

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
  const AddingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PositionedTilesState>();

    return GestureDetector(
      onTap: state.addTile,
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

class AlignedIconButton extends StatelessWidget {
  final AlignmentGeometry alignment;
  final Color color;
  final String description;
  final IconData icon;
  final void Function(PositionedTilesState) onTap;

  const AlignedIconButton({
    super.key,
    required this.alignment,
    required this.color,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PositionedTilesState>();
    return Align(
        alignment: alignment,
        child: IconButton(
          icon: Icon(icon, color: color),
          iconSize: 15.0,
          onPressed: () => onTap(state),
          tooltip: description,
        ));
  }
}

class ColorfulTile extends StatefulWidget {
  final ColorfulTileData data;
  final Color iconColor;

  ColorfulTile(this.data)
      : iconColor = getContrastingColor(data.color),
        super(key: ValueKey(data.id));

  @override
  State<ColorfulTile> createState() => _ColorfulTileState();
}

class _ColorfulTileState extends State<ColorfulTile> {
  bool _controlsVisible = false;
  bool _onExitActive = true;
  bool _inside = false;

  @override
  void initState() {
    super.initState();
    delayedHideControls();
  }

  List<AlignedIconButton> get _buttons {
    return List<AlignedIconButton>.unmodifiable([
      AlignedIconButton(
        alignment: Alignment.topLeft,
        color: widget.iconColor,
        description: "Change tile color",
        icon: Icons.refresh,
        onTap: (state) => state.changeTileColor(widget.data),
      ),
      AlignedIconButton(
        alignment: Alignment.topRight,
        color: widget.iconColor,
        description: "Remove tile",
        icon: Icons.close,
        onTap: (state) => state.removeTile(widget.data),
      ),
      AlignedIconButton(
        alignment: Alignment.bottomLeft,
        color: widget.iconColor,
        description: "Move tile left",
        icon: Icons.chevron_left,
        onTap: (state) {
          state.moveTileLeft(widget.data);
          _inside = false;
          delayedHideControls();
        },
      ),
      AlignedIconButton(
        alignment: Alignment.bottomRight,
        color: widget.iconColor,
        description: "Move tile right",
        icon: Icons.chevron_right,
        onTap: (state) {
          state.moveTileRight(widget.data);
          _inside = false;
          delayedHideControls();
        },
      ),
    ]);
  }

  void hideControls() {
    setState(() {
      _controlsVisible = false;
    });
  }

  void showControls() {
    setState(() {
      _controlsVisible = true;
    });
  }

  void delayedHideControls({int milliseconds = 1500}) {
    _onExitActive = false;
    showControls();
    Future<void>.delayed(
      Duration(milliseconds: milliseconds),
      () {
        if (!_inside) {
          hideControls();
        }
        _onExitActive = true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var container = Container(
      color: widget.data.color,
      height: 140.0,
      width: 140.0,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.data.id.toString(),
              style: TextStyle(color: widget.iconColor),
            ),
          ),
          if (_controlsVisible) ..._buttons,
        ],
      ),
    );

    if (isDesktop()) {
      return MouseRegion(
        onEnter: (_) {
          _inside = true;
          showControls();
        },
        onExit: (_) {
          _inside = false;
          if (_onExitActive) {
            hideControls();
          }
        },
        child: container,
      );
    } else {
      return TapRegion(
        onTapInside: (_) {
          _inside = true;
          showControls();
        },
        onTapOutside: (_) {
          _inside = false;
          hideControls();
        },
        child: container,
      );
    }
  }
}

class ColorfulTileData {
  static int _nextId = 0;

  final int id;
  Color color;

  ColorfulTileData({Color? color})
      : color = color ?? UniqueColorGenerator.getColor(),
        id = _nextId++;
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
