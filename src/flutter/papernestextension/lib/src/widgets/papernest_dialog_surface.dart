import 'package:flet/flet.dart';
import 'package:flutter/material.dart';

class PaperNestDialogSurface extends StatelessWidget {
  final Control? control;
  final Widget? title;
  final Widget? titleAction;
  final Widget? icon;
  final Widget? content;
  final List<Widget> actions;
  final String variant;
  final double? width;
  final double? maxHeight;
  final bool scrollable;

  const PaperNestDialogSurface({
    super.key,
    this.control,
    this.title,
    this.titleAction,
    this.icon,
    this.content,
    this.actions = const [],
    this.variant = "standard",
    this.width,
    this.maxHeight,
    this.scrollable = false,
  });

  Color _variantColor(BuildContext context) {
    switch (variant) {
      case "primary":
        return const Color(0xFFF9A825);
      case "success":
        return Colors.green.shade600;
      case "warning":
        return Colors.orange.shade700;
      case "danger":
        return Colors.red.shade600;
      default:
        return const Color(0xFF343842);
    }
  }

  Widget? _buildHeader(BuildContext context) {
    if (title == null && icon == null && titleAction == null) return null;

    final variantColor = _variantColor(context);
    final headerBackground =
        control?.getColor("header_bgcolor", context) ?? Colors.grey.shade900;
    final headerColor =
        control?.getColor("header_color", context) ?? Colors.white;
    final iconBackground =
        control?.getColor("icon_bgcolor", context) ?? variantColor;
    final resolvedIconColor =
        control?.getColor("icon_color", context) ?? Colors.white;

    return Container(
      padding: control?.getPadding("header_padding") ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: headerBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconTheme(
                data: IconThemeData(color: resolvedIconColor, size: 22),
                child: icon!,
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (title != null)
            Expanded(
              child: DefaultTextStyle.merge(
                style: control?.getTextStyle(
                      "title_text_style",
                      Theme.of(context),
                    ) ??
                    TextStyle(
                      color: headerColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                child: title!,
              ),
            )
          else
            const Spacer(),
          if (titleAction != null) ...[
            const SizedBox(width: 12),
            titleAction!,
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = _buildHeader(context);
    final effectiveWidth = width ?? control?.getDouble("width", 560) ?? 560;
    final effectiveMaxHeight =
        maxHeight ?? control?.getDouble("max_height");

    Widget? body = content;
    if (body != null && scrollable) {
      body = SingleChildScrollView(child: body);
    }

    final constrainedContent = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: effectiveWidth,
        maxHeight: effectiveMaxHeight ?? double.infinity,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header,
          if (body != null)
            Flexible(
              child: Padding(
                padding: control?.getPadding("content_padding") ??
                    const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: body,
              ),
            ),
          if (actions.isNotEmpty)
            Padding(
              padding: control?.getPadding("actions_padding") ??
                  const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: OverflowBar(
                alignment: control?.getMainAxisAlignment(
                      "actions_alignment",
                      MainAxisAlignment.end,
                    ) ??
                    MainAxisAlignment.end,
                spacing: 8,
                overflowSpacing: control?.getDouble(
                      "actions_overflow_button_spacing",
                      8,
                    ) ??
                    8,
                children: actions,
              ),
            ),
        ],
      ),
    );

    return Dialog(
      alignment: control?.getAlignment("alignment"),
      insetPadding: control?.getPadding(
            "inset_padding",
            const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          ) ??
          const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      backgroundColor:
          control?.getColor("bgcolor", context) ?? Colors.white,
      elevation: control?.getDouble("elevation", 24),
      shadowColor: control?.getColor("shadow_color", context),
      clipBehavior: Clip.antiAlias,
      shape: control?.getShape("shape", Theme.of(context)) ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: constrainedContent,
    );
  }
}
