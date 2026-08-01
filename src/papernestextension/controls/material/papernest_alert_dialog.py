from dataclasses import field
from enum import Enum
from typing import Optional

from flet.controls.alignment import Alignment
from flet.controls.base_control import control
from flet.controls.buttons import OutlinedBorder
from flet.controls.control import Control
from flet.controls.control_event import ControlEventHandler
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

__all__ = ["PaperNestAlertDialog", "PaperNestDialogVariant"]


class PaperNestDialogVariant(str, Enum):
    STANDARD = "standard"
    PRIMARY = "primary"
    SUCCESS = "success"
    WARNING = "warning"
    DANGER = "danger"


@control("PaperNestAlertDialog")
class PaperNestAlertDialog(DialogControl):
    """Dialogue PaperNest avec en-tête structuré et surface réutilisable.

    Le contrôle conserve le cycle de vie d'un ``AlertDialog`` Flet : ``open``
    pilote son affichage et ``on_dismiss`` est déclenché après la fermeture.
    Le rendu visuel est partagé avec les dialogues internes des pickers.
    """

    content: Optional[Control] = None
    title: Optional[StrOrControl] = None
    title_action: Optional[Control] = None
    actions: list[Control] = field(default_factory=list)
    icon: Optional[IconDataOrControl] = None

    variant: PaperNestDialogVariant = PaperNestDialogVariant.STANDARD
    modal: bool = False
    dismissible: bool = True
    scrollable: bool = False

    width: Optional[Number] = 560
    max_height: Optional[Number] = None

    bgcolor: Optional[ColorValue] = None
    header_bgcolor: Optional[ColorValue] = None
    header_color: Optional[ColorValue] = None
    icon_bgcolor: Optional[ColorValue] = None
    icon_color: Optional[ColorValue] = None
    barrier_color: Optional[ColorValue] = None
    shadow_color: Optional[ColorValue] = None
    elevation: Optional[Number] = None

    title_padding: Optional[PaddingValue] = None
    content_padding: Optional[PaddingValue] = None
    actions_padding: Optional[PaddingValue] = None
    inset_padding: Optional[PaddingValue] = None
    action_button_padding: Optional[PaddingValue] = None
    header_padding: Optional[PaddingValue] = None

    actions_alignment: Optional[MainAxisAlignment] = MainAxisAlignment.END
    actions_overflow_button_spacing: Optional[Number] = None
    alignment: Optional[Alignment] = None
    shape: Optional[OutlinedBorder] = None
    clip_behavior: ClipBehavior = ClipBehavior.ANTI_ALIAS
    content_text_style: Optional[TextStyle] = None
    title_text_style: Optional[TextStyle] = None
    semantics_label: Optional[str] = None

    on_dismiss: Optional[ControlEventHandler["PaperNestAlertDialog"]] = None

    def before_update(self):
        super().before_update()
        if not self.dismissible:
            self.modal = True
