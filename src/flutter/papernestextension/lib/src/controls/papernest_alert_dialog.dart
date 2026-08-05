import 'package:flet/flet.dart';
import 'package:flet/src/widgets/control_inherited_notifier.dart';
import 'package:flutter/material.dart';

class PaperNestAlertDialogControl extends StatefulWidget {
  final Control control;

  const PaperNestAlertDialogControl({super.key, required this.control});

  @override
  State<PaperNestAlertDialogControl> createState() =>
      _PaperNestAlertDialogControlState();
}

class _PaperNestAlertDialogControlState
    extends State<PaperNestAlertDialogControl> {
  // Route pushed by showDialog. Kept in state so this control only closes the
  // route it opened, matching the native Flet AlertDialog implementation.
  ModalRoute? _dialogRoute;

  Control get control => widget.control;

  bool _usesPaperNestHeader() {
    return control.get("subtitle") != null ||
        control.get("title_action") != null ||
        control.get("header_bgcolor") != null ||
        control.get("header_padding") != null ||
        control.get("header_spacing") != null ||
        control.get("icon_bgcolor") != null ||
        control.get("icon_size") != null ||
        control.get("icon_container_size") != null ||
        control.get("icon_border_radius") != null ||
        control.get("subtitle_text_style") != null;
  }

  Widget? _buildPaperNestHeader(BuildContext context) {
    final title = control.buildTextOrWidget("title");
    final subtitle = control.buildTextOrWidget("subtitle");
    final titleAction = control.buildWidget("title_action");
    final iconSize = control.getDouble("icon_size", 20)!;
    final icon = control.buildIconOrWidget(
      "icon",
      size: iconSize,
      color: control.getColor("icon_color", context),
    );

    if (title == null &&
        subtitle == null &&
        titleAction == null &&
        icon == null) {
      return null;
    }

    final theme = Theme.of(context);
    final titleStyle = control.getTextStyle(
          "title_text_style",
          theme,
          theme.textTheme.titleLarge,
        ) ??
        const TextStyle();
    final subtitleStyle = control.getTextStyle(
          "subtitle_text_style",
          theme,
          theme.textTheme.bodySmall,
        ) ??
        const TextStyle();
    final spacing = control.getDouble("header_spacing", 12)!;
    final iconContainerSize =
        control.getDouble("icon_container_size", 38)!;
    final iconBorderRadius =
        control.getDouble("icon_border_radius", 12)!;
    final headerPadding = control.getPadding("header_padding") ??
        control.getPadding("title_padding") ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    final titleColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          DefaultTextStyle.merge(style: titleStyle, child: title),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          DefaultTextStyle.merge(style: subtitleStyle, child: subtitle),
        ],
      ],
    );

    return Container(
      width: double.infinity,
      color: control.getColor("header_bgcolor", context),
      padding: headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: control.getColor("icon_bgcolor", context),
                borderRadius: BorderRadius.circular(iconBorderRadius),
              ),
              child: icon,
            ),
            SizedBox(width: spacing),
          ],
          Expanded(child: titleColumn),
          if (titleAction != null) ...[
            SizedBox(width: spacing),
            titleAction,
          ],
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    final actions = control.buildWidgets("actions");
    final spacing = control.getDouble("actions_spacing");
    if (spacing == null || spacing == 0 || actions.length < 2) {
      return actions;
    }

    return [
      for (var index = 0; index < actions.length; index++)
        Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : spacing),
          child: actions[index],
        ),
    ];
  }

  Widget _createAlertDialog(BuildContext context) {
    return ControlInheritedNotifier(
      notifier: control,
      child: Builder(builder: (context) {
        ControlInheritedNotifier.of(context);
        final routeAnimation = ModalRoute.of(context)?.animation ??
            const AlwaysStoppedAnimation(1.0);
        final usesPaperNestHeader = _usesPaperNestHeader();
        final width = control.getDouble("width");
        final maxHeight = control.getDouble("max_height");
        final scrollable = control.getBool("scrollable", false)! ||
            maxHeight != null;

        final alertDialog = AlertDialog(
          title: usesPaperNestHeader
              ? _buildPaperNestHeader(context)
              : control.buildTextOrWidget("title"),
          titlePadding: usesPaperNestHeader
              ? EdgeInsets.zero
              : control.getPadding("title_padding"),
          content: control.buildWidget("content"),
          contentPadding: control.getPadding(
            "content_padding",
            const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          )!,
          actions: _buildActions(),
          actionsPadding: control.getPadding("actions_padding"),
          actionsAlignment:
              control.getMainAxisAlignment("actions_alignment"),
          shape: control.getShape("shape", Theme.of(context)),
          semanticLabel: control.getString("semantics_label"),
          insetPadding: control.getPadding(
            "inset_padding",
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          )!,
          iconPadding:
              usesPaperNestHeader ? EdgeInsets.zero : control.getPadding("icon_padding"),
          backgroundColor: control.getColor("bgcolor", context),
          buttonPadding: control.getPadding("action_button_padding"),
          shadowColor: control.getColor("shadow_color", context),
          elevation: control.getDouble("elevation"),
          clipBehavior:
              parseClip(control.getString("clip_behavior"), Clip.none)!,
          icon: usesPaperNestHeader
              ? null
              : control.buildIconOrWidget("icon"),
          iconColor: control.getColor("icon_color", context),
          scrollable: scrollable,
          actionsOverflowButtonSpacing:
              control.getDouble("actions_overflow_button_spacing"),
          alignment: control.getAlignment("alignment"),
          contentTextStyle:
              control.getTextStyle("content_text_style", Theme.of(context)),
          titleTextStyle: usesPaperNestHeader
              ? null
              : control.getTextStyle("title_text_style", Theme.of(context)),
        );

        Widget dialog = alertDialog;
        if (width != null || maxHeight != null) {
          dialog = ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: width ?? 0,
              maxWidth: width ?? double.infinity,
              maxHeight: maxHeight ?? double.infinity,
            ),
            child: dialog,
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: FadeTransition(
                opacity: routeAnimation,
                child: ColoredBox(
                  color: control.getColor("barrier_color", context) ??
                      DialogTheme.of(context).barrierColor ??
                      Theme.of(context).dialogTheme.barrierColor ??
                      Colors.black54,
                ),
              ),
            ),
            SafeArea(child: BaseControl(control: control, child: dialog)),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("PaperNestAlertDialog build: ${control.id}");

    final open = control.getBool("open", false)!;
    final lastOpen = control.getBool("_open", false)!;
    final modal = control.getBool("modal", false)!;
    final dismissible = control.getBool("dismissible", true)!;

    if (open && open != lastOpen) {
      if (control.get("title") == null &&
          control.get("content") == null &&
          control.children("actions").isEmpty) {
        return const ErrorControl(
          "PaperNestAlertDialog has nothing to display. Provide at minimum one of the following: title, content, actions.",
        );
      }

      control.updateProperties({"_open": open}, python: false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          barrierDismissible: dismissible && !modal,
          // Render the barrier in the dialog widget so it updates live.
          barrierColor: Colors.transparent,
          useSafeArea: false,
          useRootNavigator: false,
          context: context,
          builder: (context) {
            _dialogRoute ??= ModalRoute.of(context);
            return _createAlertDialog(context);
          },
        ).then((value) {
          final route = _dialogRoute;
          _dialogRoute = null;
          // Wait until the exit animation has fully completed before firing
          // dismiss, matching the native Flet implementation.
          (route?.completed ?? Future.value()).then((_) {
            debugPrint("Dismissing PaperNestAlertDialog(${control.id})");
            control.updateProperties({"_open": false}, python: false);
            control.updateProperties({"open": false});
            control.triggerEvent("dismiss");
          });
        });
      });
    } else if (!open && lastOpen) {
      control.updateProperties({"_open": false}, python: false);
      final route = _dialogRoute;
      if (route != null && route.isActive) {
        debugPrint(
          "PaperNestAlertDialog(${control.id}): Closing dialog managed by this widget.",
        );
        Navigator.of(context).pop();
      } else {
        debugPrint(
          "PaperNestAlertDialog(${control.id}): Dialog was not opened by this widget, skipping pop.",
        );
      }
    }

    return const SizedBox.shrink();
  }
}
