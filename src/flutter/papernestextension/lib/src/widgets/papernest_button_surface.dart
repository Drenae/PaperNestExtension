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
  bool _focused = false;

  Control get control => widget.control;

  Color _variantBackground(BuildContext context) {
    return switch (control.getString("variant", "primary")) {
      "secondary" => const Color(0xFFE0E0E0),
      "ghost" => Colors.transparent,
      "outline" => Colors.white,
      "danger" => Colors.red.shade600,
      "success" => Colors.green.shade600,
      _ => const Color(0xFFF9A825),
    };
  }

  Color _variantForeground(BuildContext context) {
    return switch (control.getString("variant", "primary")) {
      "danger" || "success" => Colors.white,
      _ => Colors.grey.shade900,
    };
  }

  BorderSide _variantSide(BuildContext context) {
    return control.getString("variant", "primary") == "outline"
        ? BorderSide(color: Colors.grey.shade400)
        : BorderSide.none;
  }

  Gradient? _gradientForState(BuildContext context) {
    final theme = Theme.of(context);

    if (control.disabled || control.getBool("loading", false)!) {
      return control.getGradient("disabled_gradient", theme) ??
          control.getGradient("gradient", theme);
    }
    if (_pressed) {
      return control.getGradient("pressed_gradient", theme) ??
          control.getGradient("hover_gradient", theme) ??
          control.getGradient("gradient", theme);
    }
    if (_focused) {
      return control.getGradient("focused_gradient", theme) ??
          control.getGradient("hover_gradient", theme) ??
          control.getGradient("gradient", theme);
    }
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

  double _scale() {
    if (_pressed) return control.getDouble("pressed_scale", 0.98)!;
    if (_focused) return control.getDouble("focused_scale", 1.0)!;
    if (_hovered) return control.getDouble("hover_scale", 1.02)!;
    return 1.0;
  }

  double _offsetY() {
    if (_pressed) return control.getDouble("pressed_offset_y", 0)!;
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
    final gradient = _gradientForState(context);
    final foreground = control.getColor(
      "color",
      context,
      _variantForeground(context),
    )!;
    final background = gradient == null
        ? control.getColor(
            "bgcolor",
            context,
            _variantBackground(context),
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
      defaultBorderSide: _variantSide(context),
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
      duration: control.getDuration("animation_duration") ??
          const Duration(milliseconds: 160),
      curve: _curve(),
      decoration: gradient == null
          ? null
          : BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
      child: button,
    );

    return Focus(
      onFocusChange: (value) {
        if (mounted) setState(() => _focused = value);
      },
      child: Listener(
        onPointerDown: enabled ? (_) => _setPressed(true) : null,
        onPointerUp: enabled ? (_) => _setPressed(false) : null,
        onPointerCancel: enabled ? (_) => _setPressed(false) : null,
        child: AnimatedSlide(
          offset: Offset(0, _offsetY() / 40),
          duration: control.getDuration("animation_duration") ??
              const Duration(milliseconds: 160),
          curve: _curve(),
          child: AnimatedScale(
            scale: _scale(),
            duration: control.getDuration("animation_duration") ??
                const Duration(milliseconds: 160),
            curve: _curve(),
            child: decorated,
          ),
        ),
      ),
    );
  }
}
