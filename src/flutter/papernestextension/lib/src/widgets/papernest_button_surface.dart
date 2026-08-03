import 'package:flet/flet.dart';
import 'package:flet/src/utils/buttons.dart';
import 'package:flutter/material.dart';

class PaperNestButtonSurface extends StatefulWidget {
  final Control control;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final FocusNode focusNode;

  const PaperNestButtonSurface({
    super.key,
    required this.control,
    required this.focusNode,
    this.onPressed,
    this.onLongPress,
    this.onHover,
  });

  @override
  State<PaperNestButtonSurface> createState() => _PaperNestButtonSurfaceState();
}

class _PaperNestButtonSurfaceState extends State<PaperNestButtonSurface> {
  bool _hovered = false;
  bool _pressed = false;

  Control get control => widget.control;

  Gradient? _gradient(BuildContext context) {
    final theme = Theme.of(context);
    if (_hovered) {
      return control.getGradient("hover_gradient", theme) ??
          control.getGradient("gradient", theme);
    }
    return control.getGradient("gradient", theme);
  }

  Curve _curve() {
    return switch (control.getString("animation_curve", "easeOutCubic")) {
      "linear" => Curves.linear,
      "easeIn" => Curves.easeIn,
      "easeOut" => Curves.easeOut,
      "easeInOut" => Curves.easeInOut,
      "easeInCubic" => Curves.easeInCubic,
      "easeInOutCubic" => Curves.easeInOutCubic,
      _ => Curves.easeOutCubic,
    };
  }

  Duration _duration() {
    return control.getDuration("animation_duration") ??
        const Duration(milliseconds: 160);
  }

  double _scale() {
    if (_pressed) return control.getDouble("click_scale", 0.98)!;
    if (_hovered) return control.getDouble("hover_scale", 1.02)!;
    return 1.0;
  }

  double _offsetY() {
    if (_pressed) return control.getDouble("click_offset_y", 0)!;
    if (_hovered) return control.getDouble("hover_offset_y", -1)!;
    return 0;
  }

  void _setHovered(bool value) {
    if (!mounted) return;
    setState(() => _hovered = value);
    widget.onHover?.call(value);
  }

  void _setPressed(bool value) {
    if (!mounted) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loading = control.getBool("loading", false)!;
    final enabled = !control.disabled && !loading;
    final gradient = _gradient(context);

    final foreground = control.getColor(
      "color",
      context,
      theme.colorScheme.onPrimary,
    )!;
    final background = gradient == null
        ? control.getColor(
            "bgcolor",
            context,
            theme.colorScheme.primary,
          )!
        : Colors.transparent;

    final style = parseButtonStyle(
      control.get("style"),
      theme,
      defaultForegroundColor: foreground,
      defaultBackgroundColor: background,
      defaultOverlayColor: foreground.withValues(alpha: 0.10),
      defaultShadowColor: theme.colorScheme.shadow,
      defaultElevation: control.getDouble("elevation", 0),
      defaultPadding: const EdgeInsets.symmetric(horizontal: 18),
      defaultBorderSide: BorderSide.none,
      defaultShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final iconColor = control.getColor("icon_color", context, foreground);
    final leading = loading
        ? SizedBox(
            width: control.getDouble("loading_indicator_size", 16),
            height: control.getDouble("loading_indicator_size", 16),
            child: CircularProgressIndicator(
              strokeWidth:
                  control.getDouble("loading_indicator_stroke_width", 2)!,
              color: control.getColor(
                "loading_indicator_color",
                context,
                foreground,
              ),
            ),
          )
        : control.buildIconOrWidget("icon", color: iconColor);
    final trailing = loading
        ? null
        : control.buildIconOrWidget("trailing_icon", color: iconColor);
    final originalContent = control.buildTextOrWidget("content");
    final loadingText = control.getString("loading_text");
    final content = loading && loadingText != null
        ? Text(loadingText)
        : originalContent;

    Widget child;
    if (leading != null || trailing != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[leading, const SizedBox(width: 8)],
          if (content != null) content,
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      );
    } else {
      child = content ?? const SizedBox.shrink();
    }

    final button = ElevatedButton(
      focusNode: widget.focusNode,
      autofocus: control.getBool("autofocus", false)!,
      onPressed: enabled ? widget.onPressed : null,
      onLongPress: enabled ? widget.onLongPress : null,
      onHover: enabled ? _setHovered : null,
      style: style,
      clipBehavior: control.getClipBehavior("clip_behavior", Clip.antiAlias)!,
      child: child,
    );

    final decorated = AnimatedContainer(
      duration: _duration(),
      curve: _curve(),
      decoration: gradient == null
          ? null
          : BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
      child: button,
    );

    return Listener(
      onPointerDown: enabled ? (_) => _setPressed(true) : null,
      onPointerUp: enabled ? (_) => _setPressed(false) : null,
      onPointerCancel: enabled ? (_) => _setPressed(false) : null,
      child: AnimatedSlide(
        offset: Offset(0, _offsetY() / 40),
        duration: _duration(),
        curve: _curve(),
        child: AnimatedScale(
          scale: _scale(),
          duration: _duration(),
          curve: _curve(),
          child: decorated,
        ),
      ),
    );
  }
}
