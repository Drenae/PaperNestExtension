from typing import Optional

from flet.controls.alignment import Alignment
from flet.controls.base_control import control
from flet.controls.control import Control
from flet.controls.control_event import ControlEventHandler
from flet.controls.material.form_field_control import FormFieldControl
from flet.controls.border_radius import BorderRadiusValue
from flet.controls.box import BoxShadow
from flet.controls.padding import PaddingValue
from flet.controls.text_style import TextStyle
from flet.controls.types import (
    ColorValue,
    IconDataOrControl,
    Number,
)
from flet.utils.validation import V, ValidationRules

from papernestextension.controls.control_state import ValidationState

__all__ = [
    "PaperNestDropdown",
    "PaperNestDropdownOption",
    "PaperNestDropdownState",
]


PaperNestDropdownState = ValidationState


@control("PaperNestDropdownOption")
class PaperNestDropdownOption(Control):
    key: Optional[str] = None
    text: Optional[str] = None
    content: Optional[Control] = None
    alignment: Optional[Alignment] = None
    text_style: Optional[TextStyle] = None
    leading_icon: Optional[IconDataOrControl] = None
    trailing_icon: Optional[IconDataOrControl] = None
    on_click: Optional[ControlEventHandler["PaperNestDropdownOption"]] = None
    __validation_rules__: ValidationRules = (
        V.ensure(
            lambda ctrl: ctrl.key is not None or ctrl.text is not None,
            message="key or text must be specified",
        ),
    )

@control("PaperNestDropdown")
class PaperNestDropdown(FormFieldControl):
    value: Optional[str] = None
    options: Optional[list[PaperNestDropdownOption]] = None
    alignment: Optional[Alignment] = None
    autofocus: bool = False
    hint_content: Optional[Control] = None
    select_icon: Optional[IconDataOrControl] = None
    item_height: Optional[Number] = None
    max_menu_height: Optional[Number] = None
    select_icon_size: Number = 24.0
    enable_feedback: Optional[bool] = None
    padding: Optional[PaddingValue] = None
    select_icon_enabled_color: Optional[ColorValue] = None
    select_icon_disabled_color: Optional[ColorValue] = None
    options_fill_horizontally: bool = True
    disabled_hint_content: Optional[Control] = None
    state: PaperNestDropdownState = PaperNestDropdownState.NORMAL
    state_message: Optional[str] = None
    show_state_icon: bool = True
    clear_button: bool = False
    clear_button_tooltip: str = "Effacer"
    loading: bool = False
    loading_text: str = "Chargement…"
    empty_text: str = "Aucune option disponible"
    menu_background_color: Optional[ColorValue] = None
    menu_border_color: Optional[ColorValue] = None
    menu_border_width: Number = 1
    menu_border_radius: Optional[BorderRadiusValue] = None
    menu_shadow: Optional[BoxShadow | list[BoxShadow]] = None
    menu_padding: Optional[PaddingValue] = None
    menu_item_padding: Optional[PaddingValue] = None
    menu_hover_color: Optional[ColorValue] = None
    menu_selected_color: Optional[ColorValue] = None
    menu_separator_color: Optional[ColorValue] = None
    menu_max_height: Optional[Number] = None
    menu_width: Optional[Number] = None
    on_change: Optional[ControlEventHandler["PaperNestDropdown"]] = None
    on_clear: Optional[ControlEventHandler["PaperNestDropdown"]] = None
    on_focus: Optional[ControlEventHandler["PaperNestDropdown"]] = None
    on_blur: Optional[ControlEventHandler["PaperNestDropdown"]] = None
    on_click: Optional[ControlEventHandler["PaperNestDropdown"]] = None

    def before_update(self):
        super().before_update()
        if (
            self.bgcolor is not None
            or self.fill_color is not None
            or self.focused_bgcolor is not None
        ) and self.filled is None:
            self.filled = True

    def __contains__(self, item):
        return item in self.options
