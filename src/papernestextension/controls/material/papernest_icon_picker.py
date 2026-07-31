from typing import Optional

from flet.controls.base_control import control
from flet.controls.border_radius import BorderRadiusValue
from flet.controls.control import Control
from flet.controls.control_event import ControlEventHandler
from flet.controls.layout_control import LayoutControl
from flet.controls.padding import PaddingValue
from flet.controls.text_style import TextStyle
from flet.controls.types import ColorValue, IconDataOrControl, Number, StrOrControl

__all__ = ["PaperNestIconPicker", "PaperNestIconPickerOption"]


@control("PaperNestIconPickerOption")
class PaperNestIconPickerOption(Control):
    """Option proposée par :class:`PaperNestIconPicker`.

    ``value`` reste la valeur métier enregistrée par l'application. ``icon``
    transporte séparément l'icône Flet à afficher dans le champ et la galerie.
    """

    label: str = ""
    value: str = ""
    icon: Optional[IconDataOrControl] = None


@control("PaperNestIconPicker")
class PaperNestIconPicker(LayoutControl):
    """Sélecteur d'icône autonome à l'apparence d'un champ Material."""

    options: Optional[list[PaperNestIconPickerOption]] = None
    value: Optional[str] = None
    fallback_value: Optional[str] = None

    label: Optional[StrOrControl] = None
    hint_text: str = "Sélectionner une icône"
    picker_title: str = "Choisir une icône"
    picker_description: Optional[str] = None
    cancel_text: str = "Annuler"
    confirm_text: str = "Appliquer"

    read_only: bool = False
    autofocus: bool = False

    prefix_icon: Optional[IconDataOrControl] = None
    suffix_icon: Optional[IconDataOrControl] = None
    icon_size: Number = 24
    option_icon_size: Number = 24

    color: Optional[ColorValue] = None
    icon_color: Optional[ColorValue] = None
    selected_color: Optional[ColorValue] = None
    selected_bgcolor: Optional[ColorValue] = None
    selected_border_color: Optional[ColorValue] = None
    hover_color: Optional[ColorValue] = None
    fill_color: Optional[ColorValue] = None
    border_color: Optional[ColorValue] = None
    focused_border_color: Optional[ColorValue] = None
    border_width: Number = 1
    focused_border_width: Number = 2
    border_radius: Optional[BorderRadiusValue] = None
    content_padding: Optional[PaddingValue] = None

    text_style: Optional[TextStyle] = None
    label_style: Optional[TextStyle] = None
    hint_style: Optional[TextStyle] = None

    dialog_width: Number = 820
    grid_max_extent: Number = 190
    grid_child_aspect_ratio: Number = 2.5
    grid_spacing: Number = 8
    grid_run_spacing: Number = 8
    option_border_radius: Optional[BorderRadiusValue] = None
    option_padding: Optional[PaddingValue] = None

    on_change: Optional[ControlEventHandler["PaperNestIconPicker"]] = None
    on_focus: Optional[ControlEventHandler["PaperNestIconPicker"]] = None
    on_blur: Optional[ControlEventHandler["PaperNestIconPicker"]] = None
    on_escape: Optional[ControlEventHandler["PaperNestIconPicker"]] = None

    def before_update(self):
        super().before_update()
        values = [option.value for option in (self.options or []) if option.value]
        if self.fallback_value not in values:
            self.fallback_value = values[0] if values else None
        if self.value not in values:
            self.value = self.fallback_value

    async def _trigger_event(self, event_name, event_data):
        if event_name == "change":
            self.value = str(event_data) if event_data is not None else None
        await super()._trigger_event(event_name, event_data)

    async def focus(self) -> None:
        await self._invoke_method("focus")

    async def open(self) -> None:
        await self._invoke_method("open")
