import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaperNestDatePickerControl extends StatefulWidget {
  final Control control;

  PaperNestDatePickerControl({Key? key, required this.control})
      : super(key: key ?? ValueKey("control_${control.id}"));

  @override
  State<PaperNestDatePickerControl> createState() =>
      _PaperNestDatePickerControlState();
}

class _PaperNestDatePickerControlState
    extends State<PaperNestDatePickerControl> {
  late final FocusNode _focusNode;
  DateTime? _value;
  bool _focused = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.control.addInvokeMethodListener(_invokeMethod);
    _value = _parseDate(widget.control.get("value"));
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
        throw Exception("Unknown PaperNestDatePicker method: $name");
    }
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;

    if (raw is DateTime) {
      final local = raw.isUtc ? raw.toLocal() : raw;
      return DateTime(local.year, local.month, local.day);
    }

    if (raw is num) {
      final milliseconds =
          raw.abs() > 10000000000 ? raw.toInt() : raw.toInt() * 1000;
      final local = DateTime.fromMillisecondsSinceEpoch(
        milliseconds,
        isUtc: true,
      ).toLocal();
      return DateTime(local.year, local.month, local.day);
    }

    final text = raw.toString().trim();
    if (text.isEmpty || text.toLowerCase() == "none") return null;

    final civil = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(text);
    if (civil != null) {
      return DateTime(
        int.parse(civil.group(1)!),
        int.parse(civil.group(2)!),
        int.parse(civil.group(3)!),
      );
    }

    final parsed = DateTime.tryParse(text)?.toLocal();
    return parsed == null
        ? null
        : DateTime(parsed.year, parsed.month, parsed.day);
  }

  String _civilIso(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  String _displayDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year.toString().padLeft(4, '0')}';

  DatePickerEntryMode _entryMode() {
    switch (widget.control.getString("entry_mode")) {
      case "input":
        return DatePickerEntryMode.input;
      case "calendarOnly":
        return DatePickerEntryMode.calendarOnly;
      case "inputOnly":
        return DatePickerEntryMode.inputOnly;
      default:
        return DatePickerEntryMode.calendar;
    }
  }

  DatePickerMode _pickerMode() =>
      widget.control.getString("date_picker_mode") == "year"
          ? DatePickerMode.year
          : DatePickerMode.day;

  Widget _buildPickerTheme(BuildContext context, Widget? child) {
    final theme = Theme.of(context);
    final primaryColor =
        widget.control.getColor("picker_primary_color", context) ??
            const Color(0xFFF9A825);
    final backgroundColor =
        widget.control.getColor("picker_bgcolor", context) ?? Colors.white;
    final headerBackgroundColor =
        widget.control.getColor("picker_header_bgcolor", context) ??
            Colors.grey.shade900;
    final headerColor =
        widget.control.getColor("picker_header_color", context) ?? Colors.white;

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: primaryColor,
          surface: backgroundColor,
        ),
        datePickerTheme: theme.datePickerTheme.copyWith(
          backgroundColor: backgroundColor,
          headerBackgroundColor: headerBackgroundColor,
          headerForegroundColor: headerColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              widget.control.getDouble("picker_border_radius", 20) ?? 20,
            ),
          ),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }

  Future<void> _openPicker() async {
    if (widget.control.disabled) return;
    if (!_focusNode.hasFocus) _focusNode.requestFocus();

    final now = DateTime.now();
    final firstDate =
        _parseDate(widget.control.get("first_date")) ?? DateTime(1900, 1, 1);
    final lastDate =
        _parseDate(widget.control.get("last_date")) ?? DateTime(2050, 1, 1);
    var initialDate =
        _value ?? _parseDate(widget.control.get("current_date")) ?? now;
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(lastDate)) initialDate = lastDate;

    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: _parseDate(widget.control.get("current_date")),
      initialEntryMode: _entryMode(),
      initialDatePickerMode: _pickerMode(),
      helpText: widget.control.getString("help_text"),
      cancelText: widget.control.getString("cancel_text"),
      confirmText: widget.control.getString("confirm_text"),
      errorFormatText: widget.control.getString("error_format_text"),
      errorInvalidText: widget.control.getString("error_invalid_text"),
      fieldHintText: widget.control.getString("field_hint_text"),
      fieldLabelText: widget.control.getString("field_label_text"),
      barrierColor: widget.control.getColor("barrier_color", context),
      locale: const Locale('fr', 'FR'),
      builder: _buildPickerTheme,
      onDatePickerModeChange: (mode) {
        widget.control.triggerEvent(
          "entry_mode_change",
          mode == DatePickerEntryMode.input ? "input" : "calendar",
        );
      },
    );

    if (selected == null) return;
    final civil = DateTime(selected.year, selected.month, selected.day);
    setState(() => _value = civil);
    final iso = _civilIso(civil);
    widget.control.updateProperties({"value": iso});
    widget.control.triggerEvent("change", iso);
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
    return widget.control.buildIconOrWidget("prefix_icon") ??
        const Icon(Icons.calendar_month_outlined);
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
    final backendValue = _parseDate(widget.control.get("value"));
    if ((backendValue == null) != (_value == null) ||
        (backendValue != null &&
            _value != null &&
            _civilIso(backendValue) != _civilIso(_value!))) {
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
              _value == null ? "" : _displayDate(_value!),
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
