import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class PaperNestColorPickerControl extends StatefulWidget {
  final Control control;

  PaperNestColorPickerControl({Key? key, required this.control})
      : super(key: key ?? ValueKey("control_${control.id}"));

  @override
  State<PaperNestColorPickerControl> createState() =>
      _PaperNestColorPickerControlState();
}

class _PaperNestColorPickerControlState
    extends State<PaperNestColorPickerControl> {
  late final FocusNode _focusNode;
  Color? _value;
  bool _focused = false;
  bool _hovered = false;

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
      case "clear":
        _clearValue();
        return null;
      default:
        throw Exception("Unknown PaperNestColorPicker method: $name");
    }
  }

  Color? _backendColor(BuildContext context) {
    final raw = widget.control.get("value");
    if (raw == null) return null;
    final text = raw.toString().trim();
    if (text.isEmpty || text.toLowerCase() == "none") return null;
    return widget.control.getColor("value", context);
  }

  String _colorHex(Color color) {
    final value = color.value;
    final alpha = (value >> 24) & 0xff;
    final rgb = value & 0x00ffffff;
    if (alpha == 0xff) {
      return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
    }
    return '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Future<void> _openPicker() async {
    if (widget.control.disabled) return;
    if (!_focusNode.hasFocus) _focusNode.requestFocus();

    var temporaryColor =
        _value ?? Theme.of(context).colorScheme.primary;

    final selected = await showDialog<Color>(
      context: context,
      barrierColor: widget.control.getColor("barrier_color", context),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                widget.control.getString(
                  "picker_title",
                  "Sélectionner une couleur",
                )!,
              ),
              content: SingleChildScrollView(
                child: MaterialPicker(
                  pickerColor: temporaryColor,
                  onColorChanged: (color) {
                    setDialogState(() => temporaryColor = color);
                  },
                  enableLabel:
                      widget.control.getBool("enable_label", false)!,
                  portraitOnly:
                      widget.control.getBool("portrait_only", false)!,
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
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(temporaryColor),
                  child: Text(
                    widget.control.getString("confirm_text", "Valider")!,
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected == null) return;
    setState(() => _value = selected);
    final hex = _colorHex(selected);
    widget.control.updateProperties({"value": hex});
    widget.control.triggerEvent("change", hex);
  }

  void _clearValue() {
    if (widget.control.disabled || _value == null) return;
    setState(() => _value = null);
    widget.control.updateProperties({"value": null});
    widget.control.triggerEvent("cleared");
    widget.control.triggerEvent("change", "");
    _focusNode.requestFocus();
  }

  InputBorder _border(BuildContext context, {required bool focused}) {
    final borderType = widget.control.getString("border") ?? "outline";
    if (borderType == "none") return InputBorder.none;

    final width = focused
        ? widget.control.getDouble("focused_border_width") ??
            widget.control.getDouble("border_width", 1)!
        : widget.control.getDouble("border_width", 1)!;
    final color = focused
        ? widget.control.getColor("focused_border_color", context) ??
            widget.control.getColor("border_color", context) ??
            Theme.of(context).colorScheme.primary
        : widget.control.getColor("border_color", context) ??
            Theme.of(context).colorScheme.outline;
    final side = width == 0
        ? BorderSide.none
        : BorderSide(color: color, width: width);

    if (borderType == "underline") {
      return UnderlineInputBorder(borderSide: side);
    }
    return OutlineInputBorder(
      borderSide: side,
      borderRadius: widget.control.getBorderRadius("border_radius") ??
          const BorderRadius.all(Radius.circular(4)),
    );
  }

  Widget _buildPrefixIcon() {
    final custom = widget.control.buildIconOrWidget("prefix_icon");
    if (custom != null) return custom;

    if (_value != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _value,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: const SizedBox(width: 24, height: 24),
        ),
      );
    }

    return const Icon(Icons.color_lens_outlined);
  }

  Widget? _buildClearButton() {
    final clearButton = widget.control.getBool("clear_button", false)!;
    if (!clearButton || _value == null || widget.control.disabled) return null;

    final icon = widget.control.buildIconOrWidget("clear_icon") ??
        const Icon(Icons.clear_rounded);
    return IconButton(
      icon: icon,
      tooltip: widget.control.getString("clear_tooltip", "Effacer"),
      onPressed: _clearValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final backendValue = _backendColor(context);
    if ((backendValue == null) != (_value == null) ||
        (backendValue != null &&
            _value != null &&
            backendValue.value != _value!.value)) {
      _value = backendValue;
    }

    final theme = Theme.of(context);
    final color = widget.control.getColor("color", context);
    final focusedColor = widget.control.getColor("focused_color", context);
    final textStyle = (widget.control.getTextStyle("text_style", theme) ??
            theme.textTheme.bodyLarge ??
            const TextStyle())
        .copyWith(
      fontSize: widget.control.getDouble("text_size"),
      color: _focused ? focusedColor ?? color : color,
    );

    final bgcolor = widget.control.getColor("bgcolor", context);
    final focusedBgcolor =
        widget.control.getColor("focused_bgcolor", context);
    final fillColor = widget.control.getColor("fill_color", context) ??
        (_focused ? focusedBgcolor ?? bgcolor : bgcolor);

    final decoration = InputDecoration(
      enabled: !widget.control.disabled,
      label: widget.control.buildTextOrWidget("label"),
      labelStyle: widget.control.getTextStyle("label_style", theme),
      floatingLabelStyle:
          widget.control.getTextStyle("floating_label_style", theme),
      hintText: widget.control.getString("hint_text"),
      hintStyle: widget.control.getTextStyle("hint_style", theme),
      hintMaxLines: widget.control.getInt("hint_max_lines"),
      helper: widget.control.buildTextOrWidget("helper"),
      helperText: widget.control.getString("helper_text"),
      helperStyle: widget.control.getTextStyle("helper_style", theme),
      helperMaxLines: widget.control.getInt("helper_max_lines"),
      error: widget.control.buildTextOrWidget("error"),
      errorText: widget.control.getString("error_text"),
      errorStyle: widget.control.getTextStyle("error_style", theme),
      errorMaxLines: widget.control.getInt("error_max_lines"),
      prefix: widget.control.buildTextOrWidget("prefix"),
      prefixStyle: widget.control.getTextStyle("prefix_style", theme),
      prefixIcon: _buildPrefixIcon(),
      prefixIconConstraints:
          widget.control.getBoxConstraints("prefix_icon_constraints"),
      suffixIcon: _buildClearButton(),
      suffixIconConstraints:
          widget.control.getBoxConstraints("suffix_icon_constraints"),
      isDense: widget.control.getBool("dense", false)!,
      isCollapsed: widget.control.getBool("collapsed", false)!,
      alignLabelWithHint:
          widget.control.getBool("align_label_with_hint", false),
      filled: widget.control.getBool("filled", fillColor != null)!,
      fillColor: fillColor,
      hoverColor: widget.control.getColor("hover_color", context),
      focusColor: widget.control.getColor("focus_color", context),
      contentPadding: widget.control.getPadding("content_padding"),
      constraints: widget.control.getBoxConstraints("size_constraints"),
      border: _border(context, focused: false),
      enabledBorder: _border(context, focused: false),
      focusedBorder: _border(context, focused: true),
      disabledBorder: _border(context, focused: false),
    );

    final field = FocusableActionDetector(
      focusNode: _focusNode,
      autofocus: widget.control.getBool("autofocus", false)!,
      enabled: !widget.control.disabled,
      mouseCursor: widget.control.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onShowFocusHighlight: (value) {
        if (_focused != value && mounted) setState(() => _focused = value);
      },
      onShowHoverHighlight: (value) {
        if (_hovered != value && mounted) setState(() => _hovered = value);
      },
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _openPicker();
            return null;
          },
        ),
      },
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          mouseCursor: widget.control.disabled
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          canRequestFocus: false,
          onTap: widget.control.disabled ? null : _openPicker,
          hoverColor: widget.control.getColor("hover_color", context),
          focusColor: widget.control.getColor("focus_color", context),
          borderRadius: widget.control.getBorderRadius("border_radius"),
          child: InputDecorator(
            isFocused: _focused,
            isHovering: _hovered,
            isEmpty: _value == null,
            decoration: decoration,
            child: Text(
              _value == null ? "" : _colorHex(_value!),
              style: textStyle,
              textAlign:
                  widget.control.getTextAlign("text_align", TextAlign.start),
            ),
          ),
        ),
      ),
    );

    return LayoutControl(control: widget.control, child: field);
  }
}
