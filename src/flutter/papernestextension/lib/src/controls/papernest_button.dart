import 'package:flet/flet.dart';
import 'package:flet/src/utils/launch_url.dart';
import 'package:flutter/material.dart';

import '../widgets/papernest_button_surface.dart';

class PaperNestButtonControl extends StatefulWidget {
  final Control control;

  const PaperNestButtonControl({
    super.key,
    required this.control,
  });

  @override
  State<PaperNestButtonControl> createState() => _PaperNestButtonControlState();
}

class _PaperNestButtonControlState extends State<PaperNestButtonControl> {
  late final FocusNode _focusNode;

  Control get control => widget.control;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }

  void _handleFocusChange() {
    control.triggerEvent(_focusNode.hasFocus ? "focus" : "blur");
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    switch (name) {
      case "focus":
        _focusNode.requestFocus();
        return null;
      default:
        throw Exception("Unknown PaperNestButton method: $name");
    }
  }

  void _handlePressed() {
    final url = control.getUrl("url");
    if (url != null) {
      openWebBrowser(url);
    }
    control.triggerEvent("click");
  }

  void _handleLongPress() {
    control.triggerEvent("long_press");
  }

  void _handleHover(bool hovered) {
    control.triggerEvent("hover", hovered);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutControl(
      control: control,
      child: PaperNestButtonSurface(
        control: control,
        focusNode: _focusNode,
        onPressed: _handlePressed,
        onLongPress: _handleLongPress,
        onHover: _handleHover,
      ),
    );
  }
}
