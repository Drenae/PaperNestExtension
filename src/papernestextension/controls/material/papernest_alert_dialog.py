from dataclasses import field
from typing import Optional

from flet.controls.alignment import Alignment
from flet.controls.base_control import control
from flet.controls.buttons import OutlinedBorder
from flet.controls.control import Control
from flet.controls.dialog_control import DialogControl
from flet.controls.padding import PaddingValue
from flet.controls.text_style import TextStyle
from flet.controls.types import (
    ClipBehavior,
    ColorValue,
    IconDataOrControl,
    MainAxisAlignment,
    Number,
    StrOrControl,
)
from flet.utils.validation import V, ValidationRules

__all__ = ["PaperNestAlertDialog"]


@control("PaperNestAlertDialog")
class PaperNestAlertDialog(DialogControl):
    """Fork de ``AlertDialog`` avec un en-tête PaperNest piloté depuis Python.

    Le contrôle conserve le cycle de vie natif de Flet. Il n'intègre aucune
    variante métier et ne construit aucun picker.
    """

    # Propriétés natives de AlertDialog.
    content: Optional[Control] = None
    modal: bool = False
    title: Optional[StrOrControl] = None
    actions: list[Control] = field(default_factory=list)
    bgcolor: Optional[ColorValue] = None
    elevation: Optional[Number] = None
    icon: Optional[IconDataOrControl] = None
    title_padding: Optional[PaddingValue] = None
    content_padding: Optional[PaddingValue] = None
    actions_padding: Optional[PaddingValue] = None
    actions_alignment: Optional[MainAxisAlignment] = None
    shape: Optional[OutlinedBorder] = None
    inset_padding: Optional[PaddingValue] = None
    icon_padding: Optional[PaddingValue] = None
    action_button_padding: Optional[PaddingValue] = None
    shadow_color: Optional[ColorValue] = None
    icon_color: Optional[ColorValue] = None
    scrollable: bool = False
    actions_overflow_button_spacing: Optional[Number] = None
    alignment: Optional[Alignment] = None
    content_text_style: Optional[TextStyle] = None
    title_text_style: Optional[TextStyle] = None
    clip_behavior: ClipBehavior = ClipBehavior.NONE
    semantics_label: Optional[str] = None
    barrier_color: Optional[ColorValue] = None

    # Comportement supplémentaire demandé par PaperNest.
    dismissible: bool = True

    # En-tête PaperNest, entièrement piloté depuis Python.
    subtitle: Optional[StrOrControl] = None
    title_action: Optional[Control] = None
    header_bgcolor: Optional[ColorValue] = None
    header_padding: Optional[PaddingValue] = None
    header_spacing: Optional[Number] = None
    subtitle_text_style: Optional[TextStyle] = None

    # Pastille d'icône de l'en-tête.
    icon_bgcolor: Optional[ColorValue] = None
    icon_size: Optional[Number] = None
    icon_container_size: Optional[Number] = None
    icon_border_radius: Optional[Number] = None

    # Dimensions et espacement supplémentaires.
    width: Optional[Number] = None
    max_height: Optional[Number] = None
    actions_spacing: Optional[Number] = None

    __validation_rules__: ValidationRules = (
        V.ensure(
            lambda ctrl: (
                (
                    isinstance(ctrl.title, str)
                    or (isinstance(ctrl.title, Control) and ctrl.title.visible)
                )
                or (isinstance(ctrl.content, Control) and ctrl.content.visible)
                or any(action.visible for action in ctrl.actions)
            ),
            message=(
                "PaperNestAlertDialog has nothing to display. Provide at minimum "
                "one of the following: title, content, actions"
            ),
        ),
    )
