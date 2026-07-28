import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'papernest_dropdown/papernest_dropdown_menu.dart';
import 'papernest_dropdown/papernest_dropdown_menu_item.dart';
import 'papernest_dropdown/papernest_dropdown_menu_route.dart';
import '../utils/papernest_form_field.dart';

class PaperNestDropdownControl extends StatefulWidget {
  final Control control;

  PaperNestDropdownControl({Key? key, required this.control})
      : super(key: key ?? ValueKey("control_${control.id}"));

  @override
  State<PaperNestDropdownControl> createState() => _PaperNestDropdownControlState();
}

class _PaperNestDropdownEntry {
  const _PaperNestDropdownEntry({
    required this.value,
    required this.content,
    required this.enabled,
    required this.onTap,
  });

  final String value;
  final Widget content;
  final bool enabled;
  final VoidCallback? onTap;
}

class _PaperNestDropdownControlState extends State<PaperNestDropdownControl>
    with SingleTickerProviderStateMixin {
  String? _value;
  bool _focused = false;
  bool _menuOpen = false;
  late final FocusNode _focusNode;
  late final LayerLink _layerLink;
  late final AnimationController _menuAnimationController;
  late final Animation<double> _menuOpacity;
  late final Animation<double> _menuScale;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _layerLink = LayerLink();
    _menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      reverseDuration: const Duration(milliseconds: 110),
    );
    _menuOpacity = CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _menuScale = Tween<double>(begin: 0.97, end: 1).animate(
      CurvedAnimation(
        parent: _menuAnimationController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
    widget.control.addInvokeMethodListener(_invokeMethod);
  }

  void _onFocusChange() {
    final focused = _focusNode.hasFocus;
    if (_focused == focused) {
      return;
    }

    if (mounted) {
      setState(() {
        _focused = focused;
      });
    } else {
      _focused = focused;
    }

    widget.control.triggerEvent(focused ? "focus" : "blur");
  }

  void _requestFocus() {
    if (!_focusNode.hasFocus && _focusNode.canRequestFocus) {
      _focusNode.requestFocus();
    }
  }

  void _clearSelection() {
    if (_value == null) {
      return;
    }

    _closeMenu();
    setState(() {
      _value = null;
    });
    widget.control.updateProperties({"value": null});
    widget.control.triggerEvent("clear");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.control.disabled) {
        _requestFocus();
      }
    });
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    debugPrint("PaperNestDropdown.$name($args)");
    switch (name) {
      case "focus":
        _requestFocus();
        return null;
      default:
        throw Exception("Unknown PaperNestDropdown method: $name");
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _menuAnimationController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }

  Future<void> _closeMenu() async {
    if (!_menuOpen || _overlayEntry == null) {
      return;
    }
    _menuOpen = false;
    if (mounted) {
      setState(() {});
    }
    await _menuAnimationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectEntry(_PaperNestDropdownEntry entry) {
    if (!entry.enabled) {
      return;
    }
    entry.onTap?.call();
    if (_value != entry.value) {
      setState(() {
        _value = entry.value;
      });
      widget.control.updateProperties({"value": entry.value});
      widget.control.triggerEvent("change", entry.value);
    }
    _closeMenu();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.control.disabled) {
        _requestFocus();
      }
    });
  }

  void _openMenu(
    BuildContext context,
    List<_PaperNestDropdownEntry> entries,
    Widget loadingEntry,
    Widget emptyEntry,
  ) {
    if (_menuOpen || widget.control.disabled) {
      return;
    }

    _requestFocus();
    widget.control.triggerEvent("click");
    _menuOpen = true;
    setState(() {});

    final loading = widget.control.getBool("loading", false)!;
    final menuWidth = widget.control.getDouble("menu_width") ??
        widget.control.getDouble("width") ??
        300;
    final maxHeight = widget.control.getDouble("menu_max_height") ??
        widget.control.getDouble("max_menu_height") ??
        320;
    final menuBackground = widget.control.getColor(
          "menu_background_color",
          context,
        ) ??
        Theme.of(context).colorScheme.surface;
    final menuBorderColor = widget.control.getColor(
          "menu_border_color",
          context,
        ) ??
        Theme.of(context).dividerColor;
    final menuBorderWidth = widget.control.getDouble("menu_border_width", 1)!;
    final menuBorderRadius = widget.control.getBorderRadius(
          "menu_border_radius",
        ) ??
        const BorderRadius.all(Radius.circular(10));
    final menuPadding =
        widget.control.getPadding("menu_padding") ?? EdgeInsets.zero;
    final itemPadding = widget.control.getPadding("menu_item_padding") ??
        const EdgeInsets.symmetric(horizontal: 14, vertical: 11);
    final hoverColor = widget.control.getColor("menu_hover_color", context) ??
        Theme.of(context).hoverColor;
    final selectedColor =
        widget.control.getColor("menu_selected_color", context) ??
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.10);
    final separatorColor =
        widget.control.getColor("menu_separator_color", context);
    final menuShadows = parseBoxShadows(
      widget.control.get("menu_shadow"),
      Theme.of(context),
    );

    final menuChildren = <Widget>[];
    if (loading) {
      menuChildren.add(Padding(padding: itemPadding, child: loadingEntry));
    } else if (entries.isEmpty) {
      menuChildren.add(Padding(padding: itemPadding, child: emptyEntry));
    } else {
      for (var index = 0; index < entries.length; index++) {
        final entry = entries[index];
        menuChildren.add(
          PaperNestDropdownMenuItem(
            enabled: entry.enabled,
            selected: entry.value == _value,
            hoverColor: hoverColor,
            selectedColor: selectedColor,
            padding: itemPadding,
            borderRadius: BorderRadius.only(
              topLeft: index == 0 ? menuBorderRadius.topLeft : Radius.zero,
              topRight: index == 0 ? menuBorderRadius.topRight : Radius.zero,
              bottomLeft: index == entries.length - 1
                  ? menuBorderRadius.bottomLeft
                  : Radius.zero,
              bottomRight: index == entries.length - 1
                  ? menuBorderRadius.bottomRight
                  : Radius.zero,
            ),
            onTap: () => _selectEntry(entry),
            child: entry.content,
          ),
        );
        if (separatorColor != null && index < entries.length - 1) {
          menuChildren.add(Divider(
            height: 1,
            thickness: 1,
            color: separatorColor,
          ));
        }
      }
    }

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return PaperNestDropdownMenuRoute(
          layerLink: _layerLink,
          opacity: _menuOpacity,
          scale: _menuScale,
          onDismiss: _closeMenu,
          child: PaperNestDropdownMenu(
            width: menuWidth,
            maxHeight: maxHeight,
            backgroundColor: menuBackground,
            borderColor: menuBorderColor,
            borderWidth: menuBorderWidth,
            borderRadius: menuBorderRadius,
            padding: menuPadding,
            boxShadows: menuShadows,
            children: menuChildren,
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _menuAnimationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("PaperNestDropdown build: ${widget.control.id}");

    var textSize = widget.control.getDouble("text_size");
    var color = widget.control.getColor("color", context);
    var focusedColor = widget.control.getColor("focused_color", context);

    var textStyle = widget.control
        .getTextStyle("text_style", Theme.of(context), const TextStyle())!;

    if (textSize != null) {
      textStyle = textStyle.copyWith(fontSize: textSize);
    }

    if (focusedColor != null) {
      textStyle = textStyle.copyWith(
        color: _focused ? focusedColor : (color ?? textStyle.color),
      );
    }

    if (color != null) {
      textStyle = textStyle.copyWith(color: color);
    }

    if (textStyle.color == null) {
      textStyle =
          textStyle.copyWith(color: Theme.of(context).colorScheme.onSurface);
    }

    final fieldState =
        widget.control.getString("state", "normal")!.toLowerCase();
    final stateMessage = widget.control.getString("state_message");
    final showStateIcon = widget.control.getBool("show_state_icon", true)!;
    final clearButton = widget.control.getBool("clear_button", false)!;
    final loading = widget.control.getBool("loading", false)!;
    final loadingText =
        widget.control.getString("loading_text", "Chargement…")!;
    final emptyText = widget.control
        .getString("empty_text", "Aucune option disponible")!;

    final controlValue = widget.control.getString("value");
    if (_value != controlValue) {
      _value = controlValue;
    }

    final stateColor = switch (fieldState) {
      "success" => Colors.green,
      "warning" => Colors.orange,
      "error" => Theme.of(context).colorScheme.error,
      _ => null,
    };
    final stateIcon = switch (fieldState) {
      "success" => Icons.check_circle_outline,
      "warning" => Icons.warning_amber_rounded,
      "error" => Icons.error_outline,
      _ => null,
    };

    Widget? stateSuffix;
    if (loading ||
        (showStateIcon && stateIcon != null && stateColor != null) ||
        (clearButton && _value != null && !loading)) {
      stateSuffix = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          if (!loading &&
              showStateIcon &&
              stateIcon != null &&
              stateColor != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(stateIcon, color: stateColor, size: 20),
            ),
          if (clearButton && _value != null && !loading)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: widget.control
                  .getString("clear_button_tooltip", "Effacer"),
              onPressed: widget.control.disabled ? null : _clearSelection,
            ),
        ],
      );
    }

    final optionControls = widget.control.children("options").toList();
    final hasLeadingIcons = optionControls.any(
      (item) => item.get("leading_icon") != null,
    );
    final hasTrailingIcons = optionControls.any(
      (item) => item.get("trailing_icon") != null,
    );

    final entries = optionControls.map<_PaperNestDropdownEntry>((Control item) {
      item.notifyParent = true;
      var optionTextStyle =
          item.getTextStyle("text_style", Theme.of(context));
      if (item.disabled && optionTextStyle != null) {
        optionTextStyle =
            optionTextStyle.apply(color: Theme.of(context).disabledColor);
      }

      final value =
          item.getString("key") ?? item.getString("text") ?? item.id.toString();
      final displayText = item.getString("text") ?? value;
      Widget content = item.buildWidget("content") ??
          Text(displayText, style: optionTextStyle);
      final alignment = item.getAlignment("alignment");
      if (alignment != null) {
        content = Container(alignment: alignment, child: content);
      }

      final leadingIcon = item.buildIconOrWidget("leading_icon");
      final trailingIcon = item.buildIconOrWidget("trailing_icon");
      final iconColor = item.disabled ? Theme.of(context).disabledColor : null;

      Widget optionContent = Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (hasLeadingIcons) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: leadingIcon == null
                  ? null
                  : IconTheme.merge(
                      data: IconThemeData(color: iconColor),
                      child: Center(child: leadingIcon),
                    ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(child: content),
          if (hasTrailingIcons) ...[
            const SizedBox(width: 10),
            SizedBox(
              width: 24,
              height: 24,
              child: trailingIcon == null
                  ? null
                  : IconTheme.merge(
                      data: IconThemeData(color: iconColor),
                      child: Center(child: trailingIcon),
                    ),
            ),
          ],
        ],
      );

      return _PaperNestDropdownEntry(
        value: value,
        content: optionContent,
        enabled: !item.disabled && !loading,
        onTap: !item.disabled && !loading
            ? () => item.triggerEvent("click")
            : null,
      );
    }).toList();

    if (_value != null && !entries.any((entry) => entry.value == _value)) {
      _value = null;
    }

    _PaperNestDropdownEntry? selectedEntry;
    if (_value != null) {
      for (final entry in entries) {
        if (entry.value == _value) {
          selectedEntry = entry;
          break;
        }
      }
    }

    final loadingEntry = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 10),
        Text(loadingText),
      ],
    );
    final emptyEntry = Text(
      emptyText,
      style: TextStyle(color: Theme.of(context).disabledColor),
    );

    var decoration = buildPaperNestInputDecoration(
      context,
      widget.control,
      customSuffix: stateSuffix,
      focused: _focused,
      fieldState: fieldState,
      stateMessage: stateMessage,
      stateColor: stateColor,
    );

    final hintWidget = widget.control.buildWidget("hint");
    final hintText = widget.control.getString("hint_text");
    final hasHint = hintWidget != null || hintText != null;
    final hasLabel = decoration.label != null || decoration.labelText != null;

    // The selected value / custom hint is rendered by the decorator child below.
    // buildPaperNestInputDecoration() also forwards hint_text to InputDecoration, which
    // would paint a second hint over that child. Keep the decoration hint empty
    // so there is a single source of truth for the field content.
    decoration = decoration.copyWith(
      hintText: "",
      floatingLabelBehavior: hasHint && hasLabel
          ? FloatingLabelBehavior.always
          : decoration.floatingLabelBehavior,
    );

    final hint = hintWidget ??
        (hintText != null
            ? Text(
                hintText,
                style: textStyle.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              )
            : null);

    final enabled = !widget.control.disabled;
    final arrowColor = enabled
        ? widget.control.getColor("select_icon_enabled_color", context)
        : widget.control.getColor("select_icon_disabled_color", context);
    final customIcon = widget.control.buildIconOrWidget("select_icon");

    final field = CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.control.getBool("autofocus", false)!,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape &&
              _menuOpen) {
            _closeMenu();
            return KeyEventResult.handled;
          }
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space ||
                  event.logicalKey == LogicalKeyboardKey.arrowDown)) {
            if (!_menuOpen) {
              _openMenu(context, entries, loadingEntry, emptyEntry);
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          cursor: enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled
                ? () {
                    if (_menuOpen) {
                      _closeMenu();
                    } else {
                      _openMenu(context, entries, loadingEntry, emptyEntry);
                    }
                  }
                : null,
            child: InputDecorator(
              decoration: decoration,
              isFocused: _focused,
              isEmpty: selectedEntry == null,
              child: Padding(
                padding:
                    widget.control.getPadding("padding") ?? EdgeInsets.zero,
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                        child: selectedEntry?.content ??
                            (widget.control.disabled
                                ? widget.control.buildWidget("disabled_hint") ??
                                    hint ??
                                    const SizedBox.shrink()
                                : hint ?? const SizedBox.shrink()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    customIcon ??
                        Icon(
                          _menuOpen
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: widget.control
                              .getDouble("select_icon_size", 24.0)!,
                          color: arrowColor,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Widget dropDown = field;
    if (widget.control.getExpand("expand", 0)! > 0) {
      return LayoutControl(control: widget.control, child: dropDown);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth == double.infinity &&
            widget.control.getDouble("width") == null) {
          dropDown = ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 300),
            child: dropDown,
          );
        }
        return LayoutControl(control: widget.control, child: dropDown);
      },
    );
  }
}
