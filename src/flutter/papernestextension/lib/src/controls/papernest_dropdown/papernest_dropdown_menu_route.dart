import 'package:flutter/material.dart';

class PaperNestDropdownMenuRoute extends StatelessWidget {
  const PaperNestDropdownMenuRoute({
    super.key,
    required this.layerLink,
    required this.opacity,
    required this.scale,
    required this.onDismiss,
    required this.child,
    this.offset = const Offset(0, 6),
  });

  final LayerLink layerLink;
  final Animation<double> opacity;
  final Animation<double> scale;
  final VoidCallback onDismiss;
  final Widget child;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onDismiss,
          ),
        ),
        CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: offset,
          child: Material(
            type: MaterialType.transparency,
            child: FadeTransition(
              opacity: opacity,
              child: ScaleTransition(
                scale: scale,
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
