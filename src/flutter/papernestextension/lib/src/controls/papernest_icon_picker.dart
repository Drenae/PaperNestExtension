import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaperNestIconPickerControl extends StatefulWidget {
  final Control control;

  PaperNestIconPickerControl({Key? key, required this.control})
      : super(key: key ?? ValueKey("control_${control.id}"));

  @override
  State<PaperNestIconPickerControl> createState() =>
      _PaperNestIconPickerControlState();
}

class _PaperNestIconPickerControlState
    extends State<PaperNestIconPickerControl> {
  late final FocusNode _focusNode;
  bool _focused = false;
  String? _value;

  bool get _readOnly => widget.control.getBool("read_only", false)!;
  bool get _interactive => !widget.control.disabled && !_readOnly;
  List<Control> get _options => widget.control.children("options");

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
    if (_focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
    widget.control.triggerEvent(_focused ? "focus" : "blur");
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    switch (name) {
      case "focus":
        _focusNode.requestFocus();
        return null;
      case "open":
        await _openPicker();
        return null;
      default:
        throw Exception("Unknown PaperNestIconPicker method: $name");
    }
  }

  String? _optionValue(Control option) => option.getString("value");

  Control? _optionForValue(String? value) {
    if (value == null) return null;
    for (final option in _options) {
      if (_optionValue(option) == value) return option;
    }
    return null;
  }

  String? _normalizedBackendValue() {
    final raw = widget.control.getString("value");
    if (_optionForValue(raw) != null) return raw;
    final fallback = widget.control.getString("fallback_value");
    if (_optionForValue(fallback) != null) return fallback;
    return _options.isEmpty ? null : _optionValue(_options.first);
  }

  Widget _optionIcon(Control? option, {required double size}) {
    final icon = option?.buildIconOrWidget("icon") ??
        widget.control.buildIconOrWidget("prefix_icon") ??
        const Icon(Icons.emoji_symbols_rounded);
    return IconTheme(
      data: IconThemeData(
        size: size,
        color: widget.control.getColor("icon_color", context),
      ),
      child: icon,
    );
  }

  String _optionLabel(Control? option) {
    if (option == null) {
      return widget.control.getString("hint_text", "Sélectionner une icône")!;
    }
    return option.getString("label", "") ?? "";
  }

  Future<void> _openPicker() async {
    if (!_interactive || _options.isEmpty) return;
    if (!_focusNode.hasFocus) _focusNode.requestFocus();

    var temporaryValue = _value ?? _normalizedBackendValue();

    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final width = widget.control.getDouble("dialog_width", 820) ?? 820;
            return AlertDialog(
              title: Text(
                widget.control.getString("picker_title", "Choisir une icône")!,
              ),
              content: SizedBox(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((widget.control.getString("picker_description") ?? "")
                        .isNotEmpty) ...[
                      Text(widget.control.getString("picker_description")!),
                      const SizedBox(height: 16),
                    ],
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              widget.control.getDouble("grid_max_extent", 190) ??
                                  190,
                          childAspectRatio: widget.control.getDouble(
                                "grid_child_aspect_ratio",
                                2.5,
                              ) ??
                              2.5,
                          crossAxisSpacing:
                              widget.control.getDouble("grid_spacing", 8) ?? 8,
                          mainAxisSpacing:
                              widget.control.getDouble("grid_run_spacing", 8) ??
                                  8,
                        ),
                        itemCount: _options.length,
                        itemBuilder: (context, index) {
                          final option = _options[index];
                          final value = _optionValue(option);
                          final isSelected = value == temporaryValue;
                          final radius = widget.control.getBorderRadius(
                                "option_border_radius",
                              ) ??
                              BorderRadius.circular(10);
                          final selectedColor = widget.control.getColor(
                                "selected_color",
                                context,
                              ) ??
                              Theme.of(context).colorScheme.primary;
                          return Material(
                            color: isSelected
                                ? widget.control.getColor(
                                      "selected_bgcolor",
                                      context,
                                    ) ??
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: radius,
                              side: BorderSide(
                                width: isSelected ? 2 : 1,
                                color: isSelected
                                    ? widget.control.getColor(
                                          "selected_border_color",
                                          context,
                                        ) ??
                                        selectedColor
                                    : widget.control.getColor(
                                          "border_color",
                                          context,
                                        ) ??
                                        Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              mouseCursor: value == null
                                  ? SystemMouseCursors.basic
                                  : SystemMouseCursors.click,
                              hoverColor: widget.control.getColor(
                                "hover_color",
                                context,
                              ),
                              onTap: value == null
                                  ? null
                                  : () => setDialogState(
                                        () => temporaryValue = value,
                                      ),
                              child: Padding(
                                padding: widget.control.getPadding(
                                      "option_padding",
                                    ) ??
                                    const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                child: Row(
                                  children: [
                                    _optionIcon(
                                      option,
                                      size: widget.control.getDouble(
                                            "option_icon_size",
                                            24,
                                          ) ??
                                          24,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _optionLabel(option),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isSelected
                                              ? selectedColor
                                              : widget.control.getColor(
                                                  "color",
                                                  context,
                                                ),
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 18,
                                        color: selectedColor,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    widget.control.getString("cancel_text", "Annuler")!,
                  ),
                ),
                FilledButton(
                  onPressed: temporaryValue == null
                      ? null
                      : () => Navigator.of(dialogContext).pop(temporaryValue),
                  child: Text(
                    widget.control.getString("confirm_text", "Appliquer")!,
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected == null || selected == _value) return;
    setState(() => _value = selected);
    widget.control.updateProperties({"value": selected});
    widget.control.triggerEvent("change", selected);
  }

  InputBorder _border(BuildContext context, {required bool focused}) {
    final width = focused
        ? widget.control.getDouble("focused_border_width", 2) ?? 2
        : widget.control.getDouble("border_width", 1) ?? 1;
    final color = focused
        ? widget.control.getColor("focused_border_color", context) ??
            Theme.of(context).colorScheme.primary
        : widget.control.getColor("border_color", context) ??
            Theme.of(context).colorScheme.outline;
    return OutlineInputBorder(
      borderRadius: widget.control.getBorderRadius("border_radius") ??
          BorderRadius.circular(4),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget? _labelControl(BuildContext context) {
    final custom = widget.control.buildIconOrWidget("label");
    if (custom != null) return custom;
    final label = widget.control.getString("label");
    if (label == null || label.isEmpty) return null;
    return Text(
      label,
      style: widget.control.getTextStyle("label_style", Theme.of(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backendValue = _normalizedBackendValue();
    if (_value != backendValue) _value = backendValue;
    final option = _optionForValue(_value);
    final theme = Theme.of(context);
    final label = _labelControl(context);
    final textStyle = widget.control.getTextStyle("text_style", theme) ??
        theme.textTheme.bodyLarge ??
        const TextStyle();
    final hintStyle = widget.control.getTextStyle("hint_style", theme) ??
        theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        );

    final field = Focus(
      focusNode: _focusNode,
      autofocus: widget.control.getBool("autofocus", false)!,
      onKeyEvent: (_, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          widget.control.triggerEvent("escape");
          return KeyEventResult.handled;
        }
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          _openPicker();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          mouseCursor: _interactive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onTap: _interactive ? _openPicker : null,
          borderRadius: widget.control.getBorderRadius("border_radius") ??
              BorderRadius.circular(4),
          child: InputDecorator(
            isFocused: _focused,
            isEmpty: option == null,
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.control.getColor("fill_color", context),
              enabled: !widget.control.disabled,
              contentPadding: widget.control.getPadding("content_padding") ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: _border(context, focused: false),
              disabledBorder: _border(context, focused: false),
              focusedBorder: _border(context, focused: true),
              prefixIcon: widget.control.buildIconOrWidget("prefix_icon"),
              suffixIcon: widget.control.buildIconOrWidget("suffix_icon") ??
                  const Icon(Icons.chevron_right_rounded),
            ),
            child: Row(
              children: [
                _optionIcon(
                  option,
                  size: widget.control.getDouble("icon_size", 24) ?? 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _optionLabel(option),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: option == null ? hintStyle : textStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (label == null) return field;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        const SizedBox(height: 6),
        field,
      ],
    );
  }
}
