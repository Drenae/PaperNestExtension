import 'dart:async';

import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaperNestTextFieldControl extends StatefulWidget {
  final Control control;

  PaperNestTextFieldControl({Key? key, required this.control})
      : super(key: key ?? ValueKey("control_${control.id}"));

  @override
  State<PaperNestTextFieldControl> createState() => _PaperNestTextFieldControlState();
}

class _PaperNestTextFieldControlState extends State<PaperNestTextFieldControl> {
  String _value = "";
  bool _revealPassword = false;
  bool _focused = false;
  late TextEditingController _controller;
  late final FocusNode _focusNode;
  late final FocusNode _shiftEnterfocusNode;
  String? _lastFocusValue;
  String? _lastBlurValue;
  TextSelection? _selection;
  Timer? _searchDebounce;

  KeyEventResult _handleTextFieldKeyEvent(KeyEvent event,
      {required bool submitOnEnter}) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      final searchMode = widget.control.getBool("search_mode", false)!;
      final clearOnEscape = widget.control.getBool("clear_on_escape", true)!;
      final blurOnEmptyEscape =
          widget.control.getBool("blur_on_empty_escape", true)!;

      widget.control.triggerEvent("escape", _controller.text);

      if (searchMode && clearOnEscape && _controller.text.isNotEmpty) {
        _clearSearch();
      } else if (blurOnEmptyEscape) {
        _focusNode.unfocus();
        _shiftEnterfocusNode.unfocus();
      }

      return KeyEventResult.handled;
    }

    // ignore up/down arrow keys if flag is set
    if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
        widget.control.getBool("ignore_up_down_keys", false)! &&
        (event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.arrowDown)) {
      return KeyEventResult.handled;
    }

    // submit on Enter if flag is set and shift is not pressed
    if (submitOnEnter &&
        event is KeyDownEvent &&
        !HardwareKeyboard.instance.isShiftPressed &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
      widget.control.triggerEvent("submit");
      return KeyEventResult.handled;
    }

    // let the system handle other key events
    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleControllerChange);
    _shiftEnterfocusNode = FocusNode(
      onKeyEvent: (FocusNode node, KeyEvent event) =>
          _handleTextFieldKeyEvent(event, submitOnEnter: true),
    );
    _shiftEnterfocusNode.addListener(_onShiftEnterFocusChange);
    _focusNode = FocusNode(
      onKeyEvent: (FocusNode node, KeyEvent event) =>
          _handleTextFieldKeyEvent(event, submitOnEnter: false),
    );
    _focusNode.addListener(_onFocusChange);
    widget.control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _controller.removeListener(_handleControllerChange);
    _controller.dispose();
    _shiftEnterfocusNode.removeListener(_onShiftEnterFocusChange);
    _shiftEnterfocusNode.dispose();
    _focusNode.removeListener(_onFocusChange);
    widget.control.removeInvokeMethodListener(_invokeMethod);
    _focusNode.dispose();
    super.dispose();
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    debugPrint("TextField.$name($args)");
    switch (name) {
      case "focus":
        _focusNode.requestFocus();
      default:
        throw Exception("Unknown TextField method: $name");
    }
  }

  void _selectAllIfRequested(bool hasFocus) {
    if (!hasFocus ||
        !widget.control.getBool("select_all_on_focus", false)! ||
        _controller.text.isEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  void _onShiftEnterFocusChange() {
    _focused = _shiftEnterfocusNode.hasFocus;
    _selectAllIfRequested(_focused);
    widget.control
        .triggerEvent(_shiftEnterfocusNode.hasFocus ? "focus" : "blur");
  }

  void _onFocusChange() {
    _focused = _focusNode.hasFocus;
    _selectAllIfRequested(_focused);
    widget.control.triggerEvent(_focusNode.hasFocus ? "focus" : "blur");
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _controller.clear();
    _value = "";
    widget.control.updateProperties({"value": ""});
    widget.control.triggerEvent("clear", "");
    widget.control.triggerEvent("search", "");
    if (mounted) {
      setState(() {});
    }
  }

  void _handleControllerChange() {
    final selection = _controller.selection;
    if (_selection == selection) return;

    _selection = selection;

    if (!selection.isValid ||
        !widget.control.hasEventHandler("selection_change")) {
      return;
    }

    widget.control.updateProperties({"selection": selection.toMap()});
    widget.control.triggerEvent("selection_change", {
      "selected_text":
          _controller.text.substring(selection.start, selection.end),
      "selection": selection.toMap()
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("TextField build: ${widget.control.id}");

    bool autofocus = widget.control.getBool("autofocus", false)!;

    String value = widget.control.getString("value", "")!;
    if (_value != value) {
      _value = value;
      _controller.value = TextEditingValue(
        text: value,
        // preserve cursor position at the end
        selection: TextSelection.collapsed(offset: value.length),
      );
      _selection = _controller.selection;
    }

    var selection = widget.control.getTextSelection("selection",
        minOffset: 0, maxOffset: _controller.text.length);
    if (selection != null && selection != _controller.selection) {
      _controller.selection = selection;
      _selection = selection;
    }

    var shiftEnter = widget.control.getBool("shift_enter", false)!;
    var multiline = widget.control.getBool("multiline", false)! || shiftEnter;
    var minLines = widget.control.getInt("min_lines", 1)!;
    var maxLines = widget.control.getInt("max_lines", multiline ? null : 1);

    var password = widget.control.getBool("password", false)!;
    var canRevealPassword =
        widget.control.getBool("can_reveal_password", false)!;
    var cursorColor = widget.control.getColor("cursor_color", context);
    var selectionColor = widget.control.getColor("selection_color", context);
    var textSize = widget.control.getDouble("text_size");
    var color = widget.control.getColor("color", context);
    var focusedColor = widget.control.getColor("focused_color", context);
    var textStyle = widget.control
        .getTextStyle("text_style", Theme.of(context), const TextStyle())!;
    if (textSize != null || color != null || focusedColor != null) {
      textStyle = textStyle.copyWith(
          fontSize: textSize, color: _focused ? focusedColor ?? color : color);
    }

    TextCapitalization textCapitalization = widget.control
        .getTextCapitalization("capitalization", TextCapitalization.none)!;

    FilteringTextInputFormatter? inputFilter =
        widget.control.getTextInputFormatter("input_filter");

    List<TextInputFormatter>? inputFormatters = [];
    // add non-null input formatters
    if (inputFilter != null) {
      inputFormatters.add(inputFilter);
    }
    if (textCapitalization != TextCapitalization.none) {
      inputFormatters.add(TextCapitalizationFormatter(textCapitalization));
    }

    final searchMode = widget.control.getBool("search_mode", false)!;
    final clearButton = widget.control.getBool("clear_button", true)!;
    final searching = widget.control.getBool("searching", false)!;
    final showRefreshAction =
        widget.control.getBool("show_refresh_action", false)!;

    final fieldState =
        widget.control.getString("state", "normal")!.toLowerCase();
    final stateMessage = widget.control.getString("state_message");
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

    Widget? suffixIcon;
    if (password && canRevealPassword) {
      suffixIcon = IconButton(
        icon: Icon(
          _revealPassword ? Icons.visibility_off : Icons.visibility,
        ),
        tooltip: _revealPassword ? "Masquer" : "Afficher",
        onPressed: () {
          setState(() {
            _revealPassword = !_revealPassword;
          });
        },
      );
    } else if ((searchMode &&
            (searching || showRefreshAction ||
                (clearButton && _value.isNotEmpty))) ||
        stateIcon != null) {
      suffixIcon = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (searching)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          if (showRefreshAction)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: widget.control
                  .getString("refresh_action_tooltip", "Actualiser"),
              onPressed:
                  widget.control.getBool("refresh_action_disabled", false)!
                      ? null
                      : () => widget.control.triggerEvent("refresh_action"),
            ),
          if (stateIcon != null && stateColor != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(stateIcon, color: stateColor, size: 20),
            ),
          if (clearButton && _value.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: "Effacer la recherche",
              onPressed: _clearSearch,
            ),
        ],
      );
    }

    var textVerticalAlign = widget.control.getDouble("text_vertical_align");

    FocusNode focusNode = shiftEnter ? _shiftEnterfocusNode : _focusNode;
    var focusValue = widget.control.getString("focus");
    var blurValue = widget.control.getString("blur");
    if (focusValue != null && focusValue != _lastFocusValue) {
      _lastFocusValue = focusValue;
      focusNode.requestFocus();
    }
    if (blurValue != null && blurValue != _lastBlurValue) {
      _lastBlurValue = blurValue;
      _focusNode.unfocus();
    }

    var fitParentSize = widget.control.getBool("fit_parent_size", false)!;
    var maxLength = widget.control.getInt("max_length");

    InputBorder? withStateBorder(InputBorder? border, double width) {
      if (border == null || stateColor == null) return border;
      return border.copyWith(
        borderSide: BorderSide(color: stateColor, width: width),
      );
    }

    InputBorder? resolveFocusedBorder(InputDecoration decoration) {
      if (decoration.focusedBorder != null) {
        return decoration.focusedBorder;
      }

      final baseBorder = decoration.enabledBorder ?? decoration.border;
      if (baseBorder == null || baseBorder == InputBorder.none) {
        return baseBorder;
      }

      return baseBorder.copyWith(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: widget.control.getDouble("focused_border_width", 2.0)!,
        ),
      );
    }

    var decoration = buildInputDecoration(
      context,
      widget.control,
      customSuffix: suffixIcon,
      valueLength: _value.length,
      maxLength: maxLength,
      focused: _focused,
    ).copyWith(
      prefixIcon: searchMode ? const Icon(Icons.search) : null,
    );

    final focusedBorder = resolveFocusedBorder(decoration);

    if (fieldState == "error") {
      decoration = decoration.copyWith(
        errorText: stateMessage,
        enabledBorder: withStateBorder(decoration.enabledBorder, 1),
        errorBorder: withStateBorder(
          decoration.errorBorder ?? decoration.enabledBorder,
          1,
        ),
        focusedBorder: focusedBorder,
        focusedErrorBorder: focusedBorder,
      );
    } else if (stateColor != null) {
      decoration = decoration.copyWith(
        helperText: stateMessage,
        helperStyle: decoration.helperStyle?.copyWith(color: stateColor) ??
            TextStyle(color: stateColor),
        enabledBorder: withStateBorder(decoration.enabledBorder, 1),
        focusedBorder: focusedBorder,
      );
    } else if (stateMessage != null) {
      decoration = decoration.copyWith(helperText: stateMessage);
    }

    Widget textField = TextFormField(
        style: textStyle,
        autofocus: autofocus,
        enabled: !widget.control.disabled,
        onFieldSubmitted: !multiline
            ? (value) {
                _searchDebounce?.cancel();
                widget.control.triggerEvent("submit", value);
                if (searchMode) {
                  widget.control.triggerEvent("search", value);
                }
              }
            : null,
        decoration: decoration,
        showCursor: widget.control.getBool("show_cursor"),
        textAlignVertical: textVerticalAlign != null
            ? TextAlignVertical(y: textVerticalAlign)
            : null,
        cursorHeight: widget.control.getDouble("cursor_height"),
        cursorWidth: widget.control.getDouble("cursor_width", 2.0)!,
        cursorRadius: widget.control.getRadius("cursor_radius"),
        keyboardType: multiline
            ? TextInputType.multiline
            : widget.control
                .getTextInputType("keyboard_type", TextInputType.text)!,
        autocorrect: widget.control.getBool("autocorrect", true)!,
        enableSuggestions: widget.control.getBool("enable_suggestions", true)!,
        smartDashesType: widget.control.getBool("smart_dashes_type", true)!
            ? SmartDashesType.enabled
            : SmartDashesType.disabled,
        smartQuotesType: widget.control.getBool("smart_quotes_type", true)!
            ? SmartQuotesType.enabled
            : SmartQuotesType.disabled,
        textAlign: widget.control.getTextAlign("text_align", TextAlign.start)!,
        minLines: fitParentSize ? null : minLines,
        maxLines: fitParentSize ? null : maxLines,
        maxLength: maxLength,
        readOnly: widget.control.getBool("read_only", false)!,
        inputFormatters: inputFormatters.isNotEmpty ? inputFormatters : null,
        obscureText: password && !_revealPassword,
        controller: _controller,
        focusNode: focusNode,
        autofillHints: widget.control.getAutofillHints("autofill_hints"),
        expands: fitParentSize,
        enableInteractiveSelection:
            widget.control.getBool("enable_interactive_selection"),
        canRequestFocus: widget.control.getBool("can_request_focus", true)!,
        clipBehavior:
            widget.control.getClipBehavior("clip_behavior", Clip.hardEdge)!,
        cursorColor: cursorColor,
        ignorePointers: widget.control.getBool("ignore_pointers"),
        cursorErrorColor:
            widget.control.getColor("cursor_error_color", context),
        stylusHandwritingEnabled:
            widget.control.getBool("enable_stylus_handwriting", true)!,
        scrollPadding: widget.control
            .getPadding("scroll_padding", const EdgeInsets.all(20.0))!,
        keyboardAppearance: widget.control.getBrightness("keyboard_brightness"),
        enableIMEPersonalizedLearning:
            widget.control.getBool("enable_ime_personalized_learning", true)!,
        obscuringCharacter:
            widget.control.getString("obscuring_character", '•')!,
        mouseCursor: widget.control.getMouseCursor("mouse_cursor"),
        cursorOpacityAnimates: widget.control.getBool("animate_cursor_opacity",
            Theme.of(context).platform == TargetPlatform.iOS)!,
        onTapAlwaysCalled: widget.control.getBool("always_call_on_tap", false)!,
        strutStyle: widget.control.getStrutStyle("strut_style"),
        onTap: () {
          widget.control.triggerEvent("click");
        },
        onTapOutside: widget.control.hasEventHandler("tap_outside")
            ? (PointerDownEvent? event) {
                widget.control.triggerEvent("tap_outside");
              }
            : null,
        onChanged: (String value) {
          final visibilityChanged = searchMode &&
              clearButton &&
              ((_value.isEmpty && value.isNotEmpty) ||
                  (_value.isNotEmpty && value.isEmpty));

          _value = value;
          widget.control.updateProperties({"value": value});

          if (visibilityChanged) {
            setState(() {});
          }

          if (widget.control.hasEventHandler("change")) {
            widget.control.triggerEvent("change", value);
          }

          if (searchMode && widget.control.hasEventHandler("search")) {
            _searchDebounce?.cancel();
            final debounceMs = widget.control.getInt("debounce_ms", 300)!;
            if (debounceMs == 0) {
              widget.control.triggerEvent("search", value);
            } else {
              _searchDebounce = Timer(Duration(milliseconds: debounceMs), () {
                if (mounted) {
                  widget.control.triggerEvent("search", _value);
                }
              });
            }
          }
        });

    if (cursorColor != null || selectionColor != null) {
      textField = TextSelectionTheme(
          data: TextSelectionTheme.of(context).copyWith(
              cursorColor: cursorColor, selectionColor: selectionColor),
          child: textField);
    }

    // linux workaround for https://github.com/flet-dev/flet/issues/3934
    textField =
        isLinuxDesktop() ? ExcludeSemantics(child: textField) : textField;

    if (widget.control.getExpand("expand", 0)! > 0) {
      return LayoutControl(control: widget.control, child: textField);
    } else {
      double? width = widget.control.getDouble("width");

      return LayoutControl(
        control: widget.control,
        child: width == null
            ? ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 300),
                child: textField)
            : textField,
      );
    }
  }
}