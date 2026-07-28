import 'package:flutter/material.dart';

class PaperNestDropdownMenuItem extends StatefulWidget {
  const PaperNestDropdownMenuItem({
    super.key,
    required this.child,
    required this.enabled,
    required this.selected,
    required this.hoverColor,
    required this.selectedColor,
    required this.padding,
    required this.borderRadius,
    required this.onTap,
  });

  final Widget child;
  final bool enabled;
  final bool selected;
  final Color hoverColor;
  final Color selectedColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  @override
  State<PaperNestDropdownMenuItem> createState() =>
      _PaperNestDropdownMenuItemState();
}

class _PaperNestDropdownMenuItemState
    extends State<PaperNestDropdownMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.selected
        ? widget.selectedColor
        : (_hovered && widget.enabled ? widget.hoverColor : Colors.transparent);

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
      child: Semantics(
        button: true,
        enabled: widget.enabled,
        selected: widget.selected,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? widget.onTap : null,
          child: Container(
            decoration: BoxDecoration(
              color: background,
              borderRadius: widget.borderRadius,
            ),
            padding: widget.padding,
            child: Opacity(
              opacity: widget.enabled ? 1 : 0.5,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
