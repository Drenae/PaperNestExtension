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
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _statesController = WidgetStatesController();
    _statesController.addListener(_onStatesChange);
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
    if (mounted) {
      setState(() {});
    }
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

  Set<WidgetState> _resolvedStates({required bool loading}) {
    final states = Set<WidgetState>.from(_statesController.value);
    if (widget.control.disabled || loading) {
      states.add(WidgetState.disabled);
    }
    return states;
  }

  Curve _animationCurve() {
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

  Duration _animationDuration() {
    return widget.control.getDuration("animation_duration") ??
        const Duration(milliseconds: 160);
  }

  double _scaleForStates(Set<WidgetState> states, {required bool enabled}) {
    if (!enabled) return 1.0;
    if (states.contains(WidgetState.pressed)) {
      return widget.control.getDouble("click_scale", 1.0)!;
    }
    if (states.contains(WidgetState.hovered)) {
      return widget.control.getDouble("hover_scale", 1.0)!;
    }
    return 1.0;
  }

  double _offsetYForStates(Set<WidgetState> states, {required bool enabled}) {
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

    final isFilledButton = widget.control.type == "FilledButton";
    final isFilledTonalButton = widget.control.type == "FilledTonalButton";
    final isTextButton = widget.control.type == "TextButton";
    final isOutlinedButton = widget.control.type == "OutlinedButton";

    final loading = widget.control.getBool("loading", false)!;
    final enabled = !widget.control.disabled && !loading;
    final states = _resolvedStates(loading: loading);
    final url = widget.control.getUrl("url");
    final clipBehavior =
        widget.control.getClipBehavior("clip_behavior", Clip.none)!;
    final autofocus = widget.control.getBool("autofocus", false)!;
    final theme = Theme.of(context);

    final parsedStyle = parsePaperNestButtonStyle(
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

    final style = parsedStyle?.style;
    final gradient = parsedStyle?.gradient?.resolve(states);
    final resolvedShape = style?.shape?.resolve(states) ??
        (theme.useMaterial3
            ? const StadiumBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)));
    final resolvedForeground = style?.foregroundColor?.resolve(states) ??
        widget.control
            .getColor("color", context, theme.colorScheme.primary)!;

    final iconColor = widget.control.getColor(
      "icon_color",
      context,
      resolvedForeground,
    );
    final normalIcon = widget.control.buildIconOrWidget(
      "icon",
      color: iconColor,
    );
    final loadingIndicator = SizedBox(
      width: widget.control.getDouble("loading_indicator_size", 16),
      height: widget.control.getDouble("loading_indicator_size", 16),
      child: CircularProgressIndicator(
        strokeWidth:
            widget.control.getDouble("loading_indicator_stroke_width", 2)!,
        color: widget.control.getColor(
          "loading_indicator_color",
          context,
          resolvedForeground,
        ),
      ),
    );
    final icon = loading ? loadingIndicator : normalIcon;
    final normalContent = widget.control.buildTextOrWidget("content");
    final loadingText = widget.control.getString("loading_text");
    final content = loading && loadingText != null
        ? Text(loadingText)
        : normalContent;

    final Function()? onPressed = enabled
        ? () {
            if (url != null) {
              openWebBrowser(url);
            }
            widget.control.triggerEvent("click");
          }
        : null;

    final Function()? onLongPressHandler = enabled
        ? () {
            widget.control.triggerEvent("long_press");
          }
        : null;

    final Function(bool)? onHoverHandler = enabled
        ? (state) {
            widget.control.triggerEvent("hover", state);
          }
        : null;

    Widget? button;

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
          statesController: _statesController,
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
          statesController: _statesController,
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
          statesController: _statesController,
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
          statesController: _statesController,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
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
          statesController: _statesController,
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
          statesController: _statesController,
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
          statesController: _statesController,
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
          statesController: _statesController,
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
          statesController: _statesController,
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
          statesController: _statesController,
          onPressed: onPressed,
          onLongPress: onLongPressHandler,
          onHover: onHoverHandler,
          clipBehavior: clipBehavior,
          child: content,
        );
      }
    }

    Widget renderedButton = button;
    if (gradient != null) {
      renderedButton = AnimatedContainer(
        duration: _animationDuration(),
        curve: _animationCurve(),
        decoration: ShapeDecoration(
          gradient: gradient,
          shape: resolvedShape,
        ),
        child: button,
      );
    }

    renderedButton = AnimatedSlide(
      offset: Offset(
        0,
        _offsetYForStates(states, enabled: enabled) / 40,
      ),
      duration: _animationDuration(),
      curve: _animationCurve(),
      child: AnimatedScale(
        scale: _scaleForStates(states, enabled: enabled),
        duration: _animationDuration(),
        curve: _animationCurve(),
        child: renderedButton,
      ),
    );

    return LayoutControl(control: widget.control, child: renderedButton);
  }
}
