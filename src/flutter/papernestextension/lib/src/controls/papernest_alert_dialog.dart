import 'package:flet/flet.dart';
import 'package:flet/src/widgets/control_inherited_notifier.dart';
import 'package:flutter/material.dart';

import '../widgets/papernest_dialog_surface.dart';

class PaperNestAlertDialogControl extends StatefulWidget {
  final Control control;

  const PaperNestAlertDialogControl({super.key, required this.control});

  @override
  State<PaperNestAlertDialogControl> createState() =>
      _PaperNestAlertDialogControlState();
}

class _PaperNestAlertDialogControlState
    extends State<PaperNestAlertDialogControl> {
  ModalRoute? _dialogRoute;

  Control get control => widget.control;

  Widget _createDialog(BuildContext context) {
    return ControlInheritedNotifier(
      notifier: control,
      child: Builder(
        builder: (context) {
          ControlInheritedNotifier.of(context);
          final routeAnimation = ModalRoute.of(context)?.animation ??
              const AlwaysStoppedAnimation(1.0);
          final dialog = PaperNestDialogSurface(
            control: control,
            title: control.buildTextOrWidget("title"),
            titleAction: control.buildWidget("title_action"),
            icon: control.buildIconOrWidget("icon"),
            content: control.buildWidget("content"),
            actions: control.buildWidgets("actions"),
            variant: control.getString("variant", "standard")!,
            width: control.getDouble("width", 560),
            maxHeight: control.getDouble("max_height"),
            scrollable: control.getBool("scrollable", false)!,
          );

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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final open = control.getBool("open", false)!;
    final lastOpen = control.getBool("_open", false)!;
    final modal = control.getBool("modal", false)!;
    final dismissible = control.getBool("dismissible", true)!;

    if (open && open != lastOpen) {
      final hasTitle = control.get("title") != null;
      final hasContent = control.get("content") != null;
      final hasActions = control.children("actions").isNotEmpty;
      if (!hasTitle && !hasContent && !hasActions) {
        return const ErrorControl(
          "PaperNestAlertDialog has nothing to display. Provide at least title, content or actions.",
        );
      }

      control.updateProperties({"_open": true}, python: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          barrierDismissible: dismissible && !modal,
          barrierColor: Colors.transparent,
          useSafeArea: false,
          useRootNavigator: false,
          context: context,
          builder: (context) {
            _dialogRoute ??= ModalRoute.of(context);
            return _createDialog(context);
          },
        ).then((_) {
          final route = _dialogRoute;
          _dialogRoute = null;
          (route?.completed ?? Future.value()).then((_) {
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
        Navigator.of(context).pop();
      }
    }

    return const SizedBox.shrink();
  }
}
