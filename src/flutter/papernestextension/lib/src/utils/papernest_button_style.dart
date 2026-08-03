import 'package:flutter/material.dart';

import 'package:flet/src/models/control.dart';
import 'package:flet/src/utils/alignment.dart';
import 'package:flet/src/utils/borders.dart';
import 'package:flet/src/utils/colors.dart';
import 'package:flet/src/utils/edge_insets.dart';
import 'package:flet/src/utils/geometry.dart';
import 'package:flet/src/utils/mouse.dart';
import 'package:flet/src/utils/numbers.dart';
import 'package:flet/src/utils/text.dart';
import 'package:flet/src/utils/theme.dart';
import 'package:flet/src/utils/time.dart';
import 'package:flet/src/utils/widget_state.dart';

ButtonStyle? parsePaperNestButtonStyle(
  dynamic value,
  ThemeData theme, {
  Color? defaultForegroundColor,
  Color? defaultBackgroundColor,
  Color? defaultOverlayColor,
  Color? defaultShadowColor,
  Color? defaultSurfaceTintColor,
  double? defaultElevation,
  EdgeInsets? defaultPadding,
  BorderSide? defaultBorderSide,
  OutlinedBorder? defaultShape,
  TextStyle? defaultTextStyle,
  ButtonStyle? defaultValue,
}) {
  if (value == null) return defaultValue;

  WidgetStateProperty<TextStyle?>? parseButtonTextStyle(
    dynamic styleValue,
    ThemeData styleTheme, {
    TextStyle? fallbackTextStyle,
  }) {
    final textStyle = parseWidgetStateTextStyle(
      styleValue,
      styleTheme,
      defaultTextStyle: fallbackTextStyle,
    );
    if (textStyle == null) return null;

    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      final resolved = textStyle.resolve(states);
      return resolved?.copyWith(inherit: false);
    });
  }

  return ButtonStyle(
    foregroundColor: parseWidgetStateColor(
      value["color"],
      theme,
      defaultColor: defaultForegroundColor,
    ),
    backgroundColor: parseWidgetStateColor(
      value["bgcolor"],
      theme,
      defaultColor: defaultBackgroundColor,
    ),
    overlayColor: parseWidgetStateColor(
      value["overlay_color"],
      theme,
      defaultColor: defaultOverlayColor,
    ),
    shadowColor: parseWidgetStateColor(
      value["shadow_color"],
      theme,
      defaultColor: defaultShadowColor,
    ),
    elevation: parseWidgetStateDouble(
      value["elevation"],
      defaultDouble: defaultElevation,
    ),
    animationDuration: parseDuration(value["animation_duration"]),
    padding: parseWidgetStatePadding(
      value["padding"],
      defaultPadding: defaultPadding,
    ),
    side: getWidgetStateProperty<BorderSide?>(
      value["side"],
      (jsonValue) => parseBorderSide(
        jsonValue,
        theme,
        defaultSideColor: theme.colorScheme.outline,
      ),
      defaultBorderSide,
    ),
    shape: parseWidgetStateOutlinedBorder(
      value["shape"],
      theme,
      defaultOutlinedBorder: defaultShape,
    ),
    iconColor: parseWidgetStateColor(
      value["icon_color"],
      theme,
      defaultColor: defaultForegroundColor,
    ),
    alignment: parseAlignment(value["alignment"]),
    enableFeedback: parseBool(value["enable_feedback"]),
    textStyle: parseButtonTextStyle(
      value["text_style"],
      theme,
      fallbackTextStyle: defaultTextStyle,
    ),
    iconSize: parseWidgetStateDouble(value["icon_size"]),
    visualDensity: parseVisualDensity(value["visual_density"]),
    mouseCursor: parseWidgetStateMouseCursor(value["mouse_cursor"]),
    fixedSize: parseWidgetStateSize(value["fixed_size"]),
    maximumSize: parseWidgetStateSize(value["maximum_size"]),
    minimumSize: parseWidgetStateSize(value["minimum_size"]),
  );
}

extension PaperNestButtonParsers on Control {
  ButtonStyle? getPaperNestButtonStyle(
    String propertyName,
    ThemeData theme, {
    Color? defaultForegroundColor,
    Color? defaultBackgroundColor,
    Color? defaultOverlayColor,
    Color? defaultShadowColor,
    Color? defaultSurfaceTintColor,
    double? defaultElevation,
    EdgeInsets? defaultPadding,
    BorderSide? defaultBorderSide,
    OutlinedBorder? defaultShape,
    ButtonStyle? defaultValue,
  }) {
    return parsePaperNestButtonStyle(
      get(propertyName),
      theme,
      defaultForegroundColor: defaultForegroundColor,
      defaultBackgroundColor: defaultBackgroundColor,
      defaultOverlayColor: defaultOverlayColor,
      defaultShadowColor: defaultShadowColor,
      defaultSurfaceTintColor: defaultSurfaceTintColor,
      defaultElevation: defaultElevation,
      defaultPadding: defaultPadding,
      defaultBorderSide: defaultBorderSide,
      defaultShape: defaultShape,
      defaultValue: defaultValue,
    );
  }
}
