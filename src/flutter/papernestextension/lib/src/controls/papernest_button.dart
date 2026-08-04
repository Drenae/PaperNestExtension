import 'package:flutter/material.dart';

import 'package:flet/src/controls/base_controls.dart';
import 'package:flet/src/extensions/control.dart';
import 'package:flet/src/models/control.dart';
import 'package:flet/src/utils/colors.dart';
import 'package:flet/src/utils/launch_url.dart';
import 'package:flet/src/utils/misc.dart';
import 'package:flet/src/utils/numbers.dart';
import 'package:flet/src/utils/time.dart';
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
  late final WidgetStatesController _statesController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
    _statesController = WidgetStatesController()
      ..addListener(_onStatesChange);
    widget.control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _statesController.removeListener(_onStatesChange);
    _statesController.dispose();
    widget.control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }

  void _onFocusChange() {
    widget.control.triggerEvent(_focusNode.hasFocus ? "focus" : "blur");
  }

  void _onStatesChange() {
    if (mounted) setState(() {});
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    debugPrint("PaperNestButton.$name($args)");
    switch (name) {
      case "focus":
        _focusNode.requestFocus();
        return null;
      default:
        throw Exception("Unknown PaperNestButton method: $name");
    }
  }

  Set<WidgetState> _states(bool loading) {
    final states = Set<WidgetState>.from(_statesController.value);
    if (widget.control.disabled || loading) states.add(WidgetState.disabled);
    return states;
  }

  Curve _curve() {
    return switch (
        widget.control.getString("animation_curve", "easeOutCubic")) {
      "linear" => Curves.linear,
      "easeIn" => Curves.easeIn,
      "easeOut" => Curves.easeOut,
      "easeInOut" => Curves.easeInOut,
      "easeInCubic" => Curves.easeInCubic,
      "easeInOutCubic" => Curves.easeInOutCubic,
      _ => Curves.easeOutCubic,
    };
  }

  Duration _duration() =>
      widget.control.getDuration("animation_duration") ??
      const Duration(milliseconds: 160);

  double _scale(Set<WidgetState> states, bool enabled) {
    if (!enabled) return 1.0;
    if (states.contains(WidgetState.pressed)) {
      return widget.control.getDouble("click_scale", 1.0)!;
    }
    if (states.contains(WidgetState.hovered)) {
      return widget.control.getDouble("hover_scale", 1.0)!;
    }
    return 1.0;
  }

  double _offsetY(Set<WidgetState> states, bool enabled) {
    if (!enabled) return 0.0;
    if (states.contains(WidgetState.pressed)) {
      return widget.control.getDouble("click_offset_y", 0)!;
    }
    if (states.contains(WidgetState.hovered)) {
      return widget.control.getDouble("hover_offset_y", 0)!;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("PaperNestButton build: ${widget.control.id}");

    final isFilled = widget.control.type == "FilledButton";
    final isTonal = widget.control.type == "FilledTonalButton";
    final isText = widget.control.type == "TextButton";
    final isOutlined = widget.control.type == "OutlinedButton";
    final loading = widget.control.getBool("loading", false)!;
    final enabled = !widget.control.disabled && !loading;
    final states = _states(loading);
    final theme = Theme.of(context);
    final url = widget.control.getUrl("url");
    final autofocus = widget.control.getBool("autofocus", false)!;
    final clip = widget.control.getClipBehavior("clip_behavior", Clip.none)!;

    final parsed = parsePaperNestButtonStyle(
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

    final style = parsed?.style;
    final gradient = parsed?.gradient?.resolve(states);
    final shape = style?.shape?.resolve(states) ??
        (theme.useMaterial3
            ? const StadiumBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)));
    final foreground = style?.foregroundColor?.resolve(states) ??
        widget.control
            .getColor("color", context, theme.colorScheme.primary)!;
    final iconColor =
        widget.control.getColor("icon_color", context, foreground);

    final normalIcon =
        widget.control.buildIconOrWidget("icon", color: iconColor);
    final Widget? icon = loading
        ? SizedBox(
            width: widget.control.getDouble("loading_indicator_size", 16),
            height: widget.control.getDouble("loading_indicator_size", 16),
            child: CircularProgressIndicator(
              strokeWidth:
                  widget.control.getDouble("loading_indicator_stroke_width", 2)!,
              color: widget.control.getColor(
                "loading_indicator_color",
                context,
                foreground,
              ),
            ),
          )
        : normalIcon;

    final normalContent = widget.control.buildTextOrWidget("content");
    final loadingText = widget.control.getString("loading_text");
    final Widget? content = loading && loadingText != null
        ? Text(loadingText)
        : normalContent;

    final VoidCallback? onPressed = enabled
        ? () {
            if (url != null) openWebBrowser(url);
            widget.control.triggerEvent("click");
          }
        : null;
    final VoidCallback? onLongPress = enabled
        ? () => widget.control.triggerEvent("long_press")
        : null;
    final ValueChanged<bool>? onHover = enabled
        ? (value) => widget.control.triggerEvent("hover", value)
        : null;

    const error = ErrorControl(
      "Error displaying PaperNestButton",
      description: "\"icon\" must be specified together with \"content\"",
    );

    final Widget button;
    if (icon != null) {
      if (isFilled) {
        button = FilledButton.icon(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          statesController: _statesController,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          clipBehavior: clip,
          icon: icon,
          label: content ?? error,
        );
      } else if (isTonal) {
        button = FilledButton.tonalIcon(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          statesController: _statesController,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          clipBehavior: clip,
          icon: icon,
          label: content ?? error,
        );
      } else if (isText) {
        button = TextButton.icon(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          statesController: _statesController,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          clipBehavior: clip,
          icon: icon,
          label: content ?? error,
        );
      } else if (isOutlined) {
        button = OutlinedButton.icon(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          statesController: _statesController,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          clipBehavior: clip,
          icon: icon,
          label: content ?? error,
        );
      } else {
        button = ElevatedButton.icon(
          style: style,
          autofocus: autofocus,
          focusNode: _focusNode,
          statesController: _statesController,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          clipBehavior: clip,
          icon: icon,
          label: content ?? error,
        );
      }
    } else if (isFilled) {
      button = FilledButton(
        style: style,
        autofocus: autofocus,
        focusNode: _focusNode,
        statesController: _statesController,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        clipBehavior: clip,
        child: content,
      );
    } else if (isTonal) {
      button = FilledButton.tonal(
        style: style,
        autofocus: autofocus,
        focusNode: _focusNode,
        statesController: _statesController,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        clipBehavior: clip,
        child: content,
      );
    } else if (isText) {
      button = TextButton(
        style: style,
        autofocus: autofocus,
        focusNode: _focusNode,
        statesController: _statesController,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        clipBehavior: clip,
        child: content ?? const Text(""),
      );
    } else if (isOutlined) {
      button = OutlinedButton(
        style: style,
        autofocus: autofocus,
        focusNode: _focusNode,
        statesController: _statesController,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        clipBehavior: clip,
        child: content,
      );
    } else {
      button = ElevatedButton(
        style: style,
        autofocus: autofocus,
        focusNode: _focusNode,
        statesController: _statesController,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        clipBehavior: clip,
        child: content,
      );
    }

    final decorated = AnimatedContainer(
      duration: _duration(),
      curve: _curve(),
      decoration: ShapeDecoration(gradient: gradient, shape: shape),
      child: button,
    );

    final animated = AnimatedSlide(
      offset: Offset(0, _offsetY(states, enabled) / 40),
      duration: _duration(),
      curve: _curve(),
      child: AnimatedScale(
        scale: _scale(states, enabled),
        duration: _duration(),
        curve: _curve(),
        child: decorated,
      ),
    );

    return LayoutControl(control: widget.control, child: animated);
  }
}
