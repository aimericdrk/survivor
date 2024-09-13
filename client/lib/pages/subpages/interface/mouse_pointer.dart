import 'package:flutter/widgets.dart';
import 'package:soul_connection/constants/constants.dart';

mixin HoverMixin<T extends StatefulWidget> on State<T> {
  int? hoveredIndex;
  double rotationX = 0;
  double rotationY = 0;

  void onHoverCard(PointerEvent event, int index, RenderBox renderBox) {
    if (!isWearOs(context)) {
      final size = renderBox.size;
      final position = event.localPosition;

      final middleX = size.width / 2;
      final middleY = size.height / 2;

      setState(() {
        hoveredIndex = index;
        rotationY = ((position.dx - middleX) / middleX) * 0.1;
        rotationX = -((position.dy - middleY) / middleY) * 0.1;
      });
    }
  }

  void onExit(PointerEvent event) {
    setState(() {
      hoveredIndex = null;
      rotationX = 0;
      rotationY = 0;
    });
  }

  Matrix4 getTransformMatrix() {
    return (Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(rotationX)
      ..rotateY(rotationY));
  }

  bool isHovered(int index) {
    return hoveredIndex == index;
  }

  void setHoveredIndex(int? index) {
    setState(() {
      hoveredIndex = index;
    });
  }
}
