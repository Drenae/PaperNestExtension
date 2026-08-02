from dataclasses import field
from datetime import date, datetime, timezone
from enum import Enum
import json
import re
from typing import Optional

from flet.controls.base_control import control
from flet.controls.border_radius import BorderRadiusValue
from flet.controls.control_event import ControlEventHandler, Event, EventHandler
from flet.controls.duration import DateTimeValue
from flet.controls.layout_control import LayoutControl
from flet.controls.material.form_field_control import InputBorder
from flet.controls.material.textfield import KeyboardType
from flet.controls.padding import Padding, PaddingValue
from flet.controls.text_style import TextStyle
from flet.controls.types import (
    ColorValue,
    IconDataOrControl,
    Locale,
    Number,
    StrOrControl,
    TextAlign,
)

__all__ = [
    "PaperNestDatePicker",
    "PaperNestDatePickerEntryMode",
    "PaperNestDatePickerEntryModeChangeEvent",
    "PaperNestDatePickerMode",
]


class PaperNestDatePickerMode(Enum):
    DAY = "day"
    YEAR = "year"


class PaperNestDatePickerEntryMode(Enum):
    CALENDAR = "calendar"
    INPUT = "input"
    CALENDAR_ONLY = "calendarOnly"
    INPUT_ONLY = "inputOnly"


class PaperNestDatePickerEntryModeChangeEvent(Event["PaperNestDatePicker"]):
    entry_mode: PaperNestDatePickerEntryMode


@control("PaperNestDatePicker")
class PaperNestDatePicker(LayoutControl):
    """Sélecteur de date autonome à l'apparence d'un champ Material.

    Le champ ouvre le DatePicker Material natif. Son dialogue conserve toutes
    les fonctions natives et reçoit une identité visuelle PaperNest via le
    ``builder`` Flutter de ``showDatePicker()``.
    """

    value: Optional[DateTimeValue] = None
    first_date: DateTimeValue = field(
        default_factory=lambda: datetime(year=1900, month=1, day=1)
    )
    last_date: DateTimeValue = field(
        default_factory=lambda: datetime(year=2050, month=1, day=1)
    )
    current_date: DateTimeValue = field(default_factory=datetime.now)
    locale: Optional[Locale] = field(default_factory=lambda: Locale("fr", "FR"))

    keyboard_type: KeyboardType = KeyboardType.DATETIME
    date_picker_mode: PaperNestDatePickerMode = PaperNestDatePickerMode.DAY
    entry_mode: PaperNestDatePickerEntryMode = PaperNestDatePickerEntryMode.CALENDAR

    help_text: Optional[str] = "Sélectionner une date"
    cancel_text: Optional[str] = "Annuler"
    confirm_text: Optional[str] = "Valider"
    error_format_text: Optional[str] = "Format invalide"
    error_invalid_text: Optional[str] = "Date hors limites"
    field_hint_text: Optional[str] = "jj/mm/aaaa"
    field_label_text: Optional[str] = "Date"

    switch_to_calendar_icon: Optional[IconDataOrControl] = None
    switch_to_input_icon: Optional[IconDataOrControl] = None
    barrier_color: Optional[ColorValue] = None
    inset_padding: PaddingValue = field(
        default_factory=lambda: Padding.symmetric(horizontal=16.0, vertical=24.0)
    )

    # Thème du dialogue DatePicker Material natif.
    picker_primary_color: Optional[ColorValue] = None
    picker_bgcolor: Optional[ColorValue] = None
    picker_header_bgcolor: Optional[ColorValue] = None
    picker_header_color: Optional[ColorValue] = None
    picker_border_radius: Number = 20

    autofocus: bool = False
    text_align: TextAlign = TextAlign.START

    # Apparence FormField, déclarée localement pour garder le contrôle autonome.
    label: Optional[StrOrControl] = None
    hint_text: Optional[str] = "jj/mm/aaaa"
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

    on_change: Optional[ControlEventHandler["PaperNestDatePicker"]] = None
    on_cleared: Optional[ControlEventHandler["PaperNestDatePicker"]] = None
    on_entry_mode_change: Optional[
        EventHandler[PaperNestDatePickerEntryModeChangeEvent]
    ] = None
    on_focus: Optional[ControlEventHandler["PaperNestDatePicker"]] = None
    on_blur: Optional[ControlEventHandler["PaperNestDatePicker"]] = None
    on_tap_outside: Optional[ControlEventHandler["PaperNestDatePicker"]] = None
    on_escape: Optional[ControlEventHandler["PaperNestDatePicker"]] = None

    @staticmethod
    def _date_from_event_data(event_data) -> Optional[datetime]:
        """Force une date civile pure sans décalage de fuseau."""
        if event_data is None:
            return None

        value = event_data
        if isinstance(value, datetime):
            if value.tzinfo is not None:
                value = value.astimezone()
            return datetime(value.year, value.month, value.day)
        if isinstance(value, date):
            return datetime(value.year, value.month, value.day)

        if isinstance(value, str):
            text = value.strip()
            if text.startswith("{"):
                try:
                    payload = json.loads(text)
                    value = payload.get("value") or payload.get("date") or text
                except (json.JSONDecodeError, TypeError):
                    value = text
        elif isinstance(value, dict):
            value = value.get("value") or value.get("date")

        if value is None:
            return None

        if isinstance(value, (int, float)) or (
            isinstance(value, str)
            and re.fullmatch(r"-?\d+(?:\.\d+)?", value.strip())
        ):
            timestamp = float(value)
            if abs(timestamp) > 10_000_000_000:
                timestamp /= 1000.0
            local = datetime.fromtimestamp(timestamp, tz=timezone.utc).astimezone()
            return datetime(local.year, local.month, local.day)

        if isinstance(value, str):
            text = value.strip()
            if re.match(r"^\d{4}-\d{2}-\d{2}", text):
                try:
                    return datetime.strptime(text[:10], "%Y-%m-%d")
                except ValueError:
                    return None
            for fmt in ("%d/%m/%Y", "%m/%d/%Y"):
                try:
                    parsed = datetime.strptime(text, fmt)
                    return datetime(parsed.year, parsed.month, parsed.day)
                except ValueError:
                    continue
        return None

    async def _trigger_event(self, event_name, event_data):
        if event_name == "change":
            selected_date = self._date_from_event_data(event_data)
            self.value = selected_date
        elif event_name == "cleared":
            self.value = None
        await super()._trigger_event(event_name, event_data)

    async def focus(self) -> None:
        await self._invoke_method("focus")

    async def open(self) -> None:
        await self._invoke_method("open")

    async def clear(self) -> None:
        await self._invoke_method("clear")
