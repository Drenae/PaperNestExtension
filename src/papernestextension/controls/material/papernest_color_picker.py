import json
import re
from typing import Optional

from flet.controls.base_control import control
from flet.controls.border_radius import BorderRadiusValue
from flet.controls.control_event import ControlEventHandler
from flet.controls.layout_control import LayoutControl
from flet.controls.material.form_field_control import InputBorder
from flet.controls.padding import PaddingValue
from flet.controls.text_style import TextStyle
from flet.controls.types import (
    ColorValue,
    IconDataOrControl,
    Number,
    StrOrControl,
    TextAlign,
)

__all__ = ["PaperNestColorPicker"]


@control("PaperNestColorPicker")
class PaperNestColorPicker(LayoutControl):
    """Sélecteur de couleur autonome à l'apparence d'un champ Material.

    Toute la surface du contrôle ouvre un dialogue contenant un MaterialPicker.
    La valeur publique est toujours normalisée au format ``#RRGGBB``.
    """

    value: Optional[ColorValue] = None

    picker_title: str = "Sélectionner une couleur"
    cancel_text: str = "Annuler"
    confirm_text: str = "Valider"
    enable_label: bool = False
    portrait_only: bool = False
    barrier_color: Optional[ColorValue] = None

    autofocus: bool = False
    read_only: bool = False
    text_align: TextAlign = TextAlign.START

    label: Optional[StrOrControl] = None
    hint_text: Optional[str] = "Sélectionner une couleur"
    helper: Optional[StrOrControl] = None
    helper_text: Optional[str] = None
    helper_max_lines: Optional[int] = None
    error: Optional[StrOrControl] = None
    error_text: Optional[str] = None
    error_max_lines: Optional[int] = None
    text_size: Optional[Number] = None
    text_style: Optional[TextStyle] = None
    label_style: Optional[TextStyle] = None
    floating_label_style: Optional[TextStyle] = None
    hint_style: Optional[TextStyle] = None
    hint_max_lines: Optional[int] = None
    helper_style: Optional[TextStyle] = None
    error_style: Optional[TextStyle] = None
    prefix: Optional[StrOrControl] = None
    prefix_style: Optional[TextStyle] = None
    prefix_icon: Optional[IconDataOrControl] = None
    clear_button: bool = False
    clear_icon: Optional[IconDataOrControl] = None
    clear_tooltip: str = "Effacer"
    border: Optional[InputBorder] = None
    color: Optional[ColorValue] = None
    focused_color: Optional[ColorValue] = None
    bgcolor: Optional[ColorValue] = None
    focused_bgcolor: Optional[ColorValue] = None
    focus_color: Optional[ColorValue] = None
    border_width: Number = 1
    border_color: Optional[ColorValue] = None
    border_radius: Optional[BorderRadiusValue] = None
    focused_border_width: Optional[Number] = None
    focused_border_color: Optional[ColorValue] = None
    content_padding: Optional[PaddingValue] = None
    dense: bool = False
    collapsed: bool = False
    align_label_with_hint: bool = False
    filled: bool = False
    fill_color: Optional[ColorValue] = None
    hover_color: Optional[ColorValue] = None

    on_change: Optional[ControlEventHandler["PaperNestColorPicker"]] = None
    on_clear: Optional[ControlEventHandler["PaperNestColorPicker"]] = None
    # Compatibilité avec les premières versions de l'extension.
    on_cleared: Optional[ControlEventHandler["PaperNestColorPicker"]] = None
    on_focus: Optional[ControlEventHandler["PaperNestColorPicker"]] = None
    on_blur: Optional[ControlEventHandler["PaperNestColorPicker"]] = None
    on_tap_outside: Optional[ControlEventHandler["PaperNestColorPicker"]] = None
    on_escape: Optional[ControlEventHandler["PaperNestColorPicker"]] = None

    @staticmethod
    def _normalize_hex(value) -> Optional[str]:
        if value is None:
            return None

        text = str(value).strip()
        if not text or text.lower() == "none":
            return None

        if not text.startswith("#"):
            return text

        digits = text[1:]
        if re.fullmatch(r"[0-9a-fA-F]{3}", digits):
            digits = "".join(char * 2 for char in digits)
        elif re.fullmatch(r"[0-9a-fA-F]{8}", digits):
            # Les couleurs Flet peuvent arriver en #AARRGGBB : l'API publique
            # de PaperNestColorPicker ne conserve volontairement que le RGB.
            digits = digits[2:]
        elif not re.fullmatch(r"[0-9a-fA-F]{6}", digits):
            return text

        return f"#{digits.upper()}"

    @classmethod
    def _color_from_event_data(cls, event_data) -> Optional[str]:
        if event_data is None:
            return None

        value = event_data
        if isinstance(value, dict):
            value = value.get("value") or value.get("color")
        elif isinstance(value, str):
            text = value.strip()
            if text.startswith("{"):
                try:
                    payload = json.loads(text)
                    value = payload.get("value") or payload.get("color") or text
                except (json.JSONDecodeError, TypeError):
                    value = text

        return cls._normalize_hex(value)

    def before_update(self):
        super().before_update()
        self.value = self._normalize_hex(self.value)
        if (
            self.bgcolor is not None
            or self.fill_color is not None
            or self.focused_bgcolor is not None
        ) and not self.filled:
            self.filled = True

    async def _trigger_event(self, event_name, event_data):
        if event_name == "change":
            self.value = self._color_from_event_data(event_data)
        elif event_name in ("clear", "cleared"):
            self.value = None
        await super()._trigger_event(event_name, event_data)

    async def focus(self) -> None:
        await self._invoke_method("focus")

    async def open(self) -> None:
        await self._invoke_method("open")

    async def clear(self) -> None:
        await self._invoke_method("clear")
