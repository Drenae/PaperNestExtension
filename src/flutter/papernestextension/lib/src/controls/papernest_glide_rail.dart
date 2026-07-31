import 'package:flet/flet.dart';
import 'package:flutter/material.dart';

class PaperNestGlideRailControl extends StatefulWidget {
  final Control control;

  PaperNestGlideRailControl({Key? key, required this.control})
      : super(key: key ?? ValueKey("control_${control.id}"));

  @override
  State<PaperNestGlideRailControl> createState() =>
      _PaperNestGlideRailControlState();
}

class _PaperNestGlideRailControlState extends State<PaperNestGlideRailControl> {
  bool _expanded = false;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    widget.control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void dispose() {
    widget.control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }

  int get _selectedIndex => widget.control.getInt("selected_index", 0) ?? 0;

  double get _collapsedWidth =>
      widget.control.getDouble("collapsed_width", 76) ?? 76;

  double get _expandedWidth =>
      widget.control.getDouble("expanded_width", 280) ?? 280;

  Duration get _duration => Duration(
        milliseconds:
            widget.control.getInt("animation_duration", 220) ?? 220,
      );

  Duration get _hoverDuration => Duration(
        milliseconds:
            widget.control.getInt("hover_animation_duration", 140) ?? 140,
      );

  EdgeInsets get _padding =>
      widget.control.getPadding("padding") ?? EdgeInsets.zero;

  double get _collapsedContentWidth =>
      (_collapsedWidth - _padding.horizontal).clamp(0, double.infinity).toDouble();

  Curve get _curve {
    switch (widget.control.getString("animation_curve", "easeOutCubic")) {
      case "linear":
        return Curves.linear;
      case "easeInOut":
        return Curves.easeInOut;
      case "easeOut":
        return Curves.easeOut;
      case "easeOutCubic":
      default:
        return Curves.easeOutCubic;
    }
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    switch (name) {
      case "expand":
        _setExpanded(true);
        return null;
      case "collapse":
        _setExpanded(false);
        return null;
      default:
        throw Exception("Unknown PaperNestGlideRail method: $name");
    }
  }

  void _setExpanded(bool value) {
    if (_expanded == value || widget.control.disabled) return;

    setState(() {
      _expanded = value;
      if (!value) _hoveredIndex = null;
    });
    widget.control.triggerEvent(value ? "expand" : "collapse");
  }

  void _setHoveredIndex(int? index) {
    if (_hoveredIndex == index) return;
    setState(() => _hoveredIndex = index);
  }

  void _select(int index) {
    if (widget.control.disabled || index == _selectedIndex) return;

    widget.control.updateProperties({"selected_index": index});
    widget.control.triggerEvent("change", index);
    setState(() {});
  }

  Widget _brand(BuildContext context) {
    final icon = widget.control.buildIconOrWidget("brand_icon") ??
        const Icon(Icons.folder_copy_rounded);
    final title = widget.control.getString("brand_title");
    final subtitle = widget.control.getString("brand_subtitle");
    final height = widget.control.getDouble("brand_height", 64) ?? 64;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          SizedBox(
            width: _collapsedContentWidth,
            child: Center(child: icon),
          ),
          Expanded(
            child: ClipRect(
              child: AnimatedOpacity(
                duration: _duration,
                opacity: _expanded ? 1 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null && title.isNotEmpty)
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    if (subtitle != null && subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _destination(BuildContext context, Control destination, int index) {
    final selected = index == _selectedIndex;
    final hovered = index == _hoveredIndex;
    final disabled = destination.disabled || widget.control.disabled;
    final label = destination.getString("label", "") ?? "";
    final tooltip = destination.getString("tooltip") ?? label;
    final icon = destination.buildIconOrWidget(
          selected ? "selected_icon" : "icon",
        ) ??
        destination.buildIconOrWidget("icon") ??
        const SizedBox.shrink();

    final itemHeight = widget.control.getDouble("item_height", 48) ?? 48;
    final itemPadding =
        widget.control.getPadding("item_padding") ?? EdgeInsets.zero;
    final iconAreaWidth = (_collapsedContentWidth - itemPadding.horizontal)
        .clamp(0, double.infinity)
        .toDouble();
    final radius = widget.control.getBorderRadius("item_border_radius") ??
        BorderRadius.circular(12);
    final selectedBg =
        widget.control.getColor("selected_bgcolor", context) ??
            Theme.of(context).colorScheme.primaryContainer;
    final selectedBorder =
        widget.control.getColor("selected_border_color", context);
    final foreground = selected
        ? widget.control.getColor("selected_color", context)
        : widget.control.getColor("color", context);
    final hoverScale =
        widget.control.getDouble("hover_scale", 1.025) ?? 1.025;

    final tile = MouseRegion(
      onEnter: disabled ? null : (_) => _setHoveredIndex(index),
      onExit: disabled ? null : (_) => _setHoveredIndex(null),
      child: AnimatedScale(
        duration: _hoverDuration,
        curve: Curves.easeOutCubic,
        scale: hovered && !disabled ? hoverScale : 1,
        child: AnimatedContainer(
          duration: _hoverDuration,
          curve: Curves.easeOutCubic,
          height: itemHeight,
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: radius,
            border: selected && selectedBorder != null
                ? Border.all(color: selectedBorder)
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: radius,
              hoverColor: widget.control.getColor("hover_color", context),
              onTap: disabled ? null : () => _select(index),
              child: Padding(
                padding: itemPadding,
                child: Row(
                  children: [
                    SizedBox(
                      width: iconAreaWidth,
                      child: IconTheme(
                        data: IconThemeData(
                          color: foreground,
                          size:
                              widget.control.getDouble("icon_size", 24) ?? 24,
                        ),
                        child: Center(child: icon),
                      ),
                    ),
                    Expanded(
                      child: ClipRect(
                        child: AnimatedOpacity(
                          duration: _duration,
                          opacity: _expanded ? 1 : 0,
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: foreground,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (_expanded || tooltip.isEmpty) return tile;
    return Tooltip(message: tooltip, child: tile);
  }

  List<Widget> _destinationGroup(
    BuildContext context,
    List<Control> destinations,
    int startIndex,
  ) {
    final spacing = widget.control.getDouble("item_spacing", 4) ?? 4;
    final widgets = <Widget>[];

    for (var i = 0; i < destinations.length; i++) {
      if (i > 0) widgets.add(SizedBox(height: spacing));
      widgets.add(_destination(context, destinations[i], startIndex + i));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final destinations = widget.control.children("destinations");
    final secondary = widget.control.children("secondary_destinations");
    final dividerColor = widget.control.getColor("divider_color", context) ??
        Theme.of(context).dividerColor;
    final radius = widget.control.getBorderRadius("border_radius") ??
        const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        );
    final elevation = widget.control.getDouble("elevation", 8) ?? 8;
    final background = widget.control.getColor("bgcolor", context) ??
        Theme.of(context).colorScheme.surface;

    return MouseRegion(
      onEnter: (_) => _setExpanded(true),
      onExit: (_) => _setExpanded(false),
      child: AnimatedContainer(
        duration: _duration,
        curve: _curve,
        width: _expanded ? _expandedWidth : _collapsedWidth,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: background,
          borderRadius: radius,
          boxShadow: elevation <= 0
              ? null
              : [
                  BoxShadow(
                    color: widget.control.getColor("shadow_color", context) ??
                        Colors.black26,
                    blurRadius: elevation * 2,
                    offset: const Offset(2, 0),
                  ),
                ],
        ),
        child: Padding(
          padding: _padding,
          child: Column(
            children: [
              _brand(context),
              Divider(height: 1, color: dividerColor),
              const SizedBox(height: 12),
              ..._destinationGroup(context, destinations, 0),
              const Spacer(),
              if (secondary.isNotEmpty) ...[
                Divider(height: 1, color: dividerColor),
                const SizedBox(height: 12),
                ..._destinationGroup(
                  context,
                  secondary,
                  destinations.length,
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
