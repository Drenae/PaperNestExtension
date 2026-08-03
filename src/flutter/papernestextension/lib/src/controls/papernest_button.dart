import 'package:flutter/material.dart';

import 'package:flet/src/controls/base_controls.dart';
import 'package:flet/src/extensions/control.dart';
import 'package:flet/src/models/control.dart';
import 'package:flet/src/utils/colors.dart';
import 'package:flet/src/utils/launch_url.dart';
import 'package:flet/src/utils/misc.dart';
import 'package:flet/src/utils/numbers.dart';
import 'package:flet/src/widgets/error.dart';
import 'package:flet/src/widgets/flet_store_mixin.dart';

import '../utils/papernest_button_style.dart';

class PaperNestButtonControl extends StatefulWidget {
  final Control control;

  PaperNestButtonControl({Key? key, required this.control})
      : super(key: key ?? ValueKey("control_${control.id}"));

  @override
  State<PaperNestButtonControl> createState() =>
      _PaperNestButtonControlState();
}

class _PaperNestButtonControlState extends State<PaperNestButtonControl>
    with FletStoreMixin {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }

  void _onFocusChange() {
    widget.control.triggerEvent(_focusNode.hasFocus ? "focus" : "blur");
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    debugPrint("PaperNestButton.$name($args)");
    switch (name) {
      case "focus":
        _focusNode.requestFocus();
      default:
        throw Exception("Unknown PaperNestButton method: $name");
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("PaperNestButton build: ${widget.control.id}");

    final isFilledButton = widget.control.type == "FilledButton";
    final isFilledTonalButton = widget.control.type == "FilledTonalButton";
    final isTextButton = widget.control.type == "TextButton";
    final isOutlinedButton = widget.control.type == "OutlinedButton";

    final url = widget.control.getUrl("url");
    final iconColor = widget.control.getColor("icon_color", context);
    final clipBehavior =
        widget.control.getClipBehavior("clip_behavior", Clip.none)!;
    final autofocus = widget.control.getBool("autofocus", false)!;

    final icon = widget.control.buildIconOrWidget("icon", color: iconColor);
    final content = widget.control.buildTextOrWidget("content");

    final Function()? onPressed = !widget.control.disabled
        ? () {
            if (url != null) {
              openWebBrowser(url);
            }
            widget.control.triggerEvent("click");
          }
        : null;

    final Function()? onLongPressHandler = !widget.control.disabled
        ? () {
            widget.control.triggerEvent("long_press");
          }
        : null;

    final Function(bool)? onHoverHandler = !widget.control.disabled
        ? (state) {
            widget.control.triggerEvent("hover", state);
          }
        : null;

    Widget? button;
    final theme = Theme.of(context);

    final style = parsePaperNestButtonStyle(
      widget.control.internals?["style"] ?? widget.control.get("style"),
      theme,
      defaultForegroundColor: widget.control
          .getColor("color", context, theme.colorScheme.primary)!,
      defaultBackgroundColor: widget.control
          .getColor("bgcolor", context, theme.colorScheme.surface)!,
      defaultOverlayColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      defaultShadowColor: theme.colorScheme.shadow,
      defaultSurfaceTintColor: theme.colorScheme.surfaceTint,
      defaultElevation: widget.control.getDouble("elevation", 1)!,
      defaultPadding: const EdgeInsets.symmetric(horizontal: 8),
      defaultBorderSide: BorderSide.none,
      defaultShape: theme.useMaterial3
          ? const StadiumBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );

    const error = ErrorControl(
      "Error displaying PaperNestButton",
      description: "\"icon\" must be specified together with \"content\"",
    );

    if (icon != null) {
      if (isFilledButton) {
        button = FilledButton.icon(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          clipBehavior: clipBehavior,
          icon: icon,
          label: content ?? error,
        );
      } else if (isFilledTonalButton) {
        button = FilledButton.tonalIcon(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          clipBehavior: clipBehavior,
          icon: icon,
          label: content ?? error,
        );
      } else if (isTextButton) {
        button = TextButton.icon(
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          style: style,
          clipBehavior: clipBehavior,
          icon: icon,
          label: content ?? error,
        );
      } else if (isOutlinedButton) {
        button = OutlinedButton.icon(
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          clipBehavior: clipBehavior,
          style: style,
          icon: icon,
          label: content ?? error,
        );
      } else {
        button = ElevatedButton.icon(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          clipBehavior: clipBehavior,
          icon: icon,
          label: content ?? error,
        );
      }
    } else {
      if (isFilledButton) {
        button = FilledButton(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          clipBehavior: clipBehavior,
          child: content,
        );
      } else if (isFilledTonalButton) {
        button = FilledButton.tonal(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          clipBehavior: clipBehavior,
          child: content,
        );
      } else if (isTextButton) {
        button = TextButton(
          autofocus: autofocus,
          focusNode: _focusNode,
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          clipBehavior: clipBehavior,
          child: content ?? const Text(""),
        );
      } else if (isOutlinedButton) {
        button = OutlinedButton(
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          clipBehavior: clipBehavior,
          onHover: onHoverHandler,
          style: style,
          child: content,
        );
      } else {
        button = ElevatedButton(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          clipBehavior: clipBehavior,
          child: content,
        );
      }
    }

    return LayoutControl(control: widget.control, child: button);
  }
}
