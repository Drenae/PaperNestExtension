from enum import Enum
from typing import Annotated, Optional, Union

from flet.controls.adaptive_control import AdaptiveControl
from flet.controls.base_control import BaseControl, control, value
from flet.controls.control_event import ControlEventHandler, EventHandler
from flet.controls.core.autofill_group import AutofillHint
from flet.controls.core.text import TextSelection, TextSelectionChangeEvent
from flet.controls.material.form_field_control import FormFieldControl
from flet.controls.padding import PaddingValue
from flet.controls.text_style import StrutStyle
from flet.controls.types import (
    Brightness,
    ClipBehavior,
    ColorValue,
    MouseCursor,
    Number,
    TextAlign,
)
from flet.utils.validation import V

from papernestextension.controls.control_state import ValidationState

__all__ = [
    "InputFilter",
    "KeyboardType",
    "NumbersOnlyInputFilter",
    "PaperNestTextField",
    "PaperNestTextFieldState",
    "TextCapitalization",
    "TextOnlyInputFilter",
]


class KeyboardType(Enum):
    NONE = "none"
    TEXT = "text"
    MULTILINE = "multiline"
    NUMBER = "number"
    PHONE = "phone"
    DATETIME = "datetime"
    EMAIL = "email"
    URL = "url"
    VISIBLE_PASSWORD = "visiblePassword"
    NAME = "name"
    STREET_ADDRESS = "streetAddress"
    WEB_SEARCH = "webSearch"
    TWITTER = "twitter"


PaperNestTextFieldState = ValidationState


class TextCapitalization(Enum):
    CHARACTERS = "characters"
    WORDS = "words"
    SENTENCES = "sentences"
    NONE = "none"


@value
class InputFilter:
    regex_string: str
    allow: bool = True
    replacement_string: str = ""
    multiline: bool = False
    case_sensitive: bool = True
    unicode: bool = False
    dot_all: bool = False


class NumbersOnlyInputFilter(InputFilter):
    def __init__(self):
        super().__init__(
            regex_string=r"^[0-9]*$",
            allow=True,
            replacement_string="",
        )


class TextOnlyInputFilter(InputFilter):
    def __init__(self):
        super().__init__(
            regex_string=r"^[a-zA-Z]*$",
            allow=True,
            replacement_string="",
        )


@control("PaperNestTextField")
class PaperNestTextField(FormFieldControl, AdaptiveControl):
    value: str = ""
    selection: Optional[TextSelection] = None
    keyboard_type: KeyboardType = KeyboardType.TEXT
    multiline: bool = False
    min_lines: Annotated[Optional[int], V.gt(0), V.le_field("max_lines")] = None
    max_lines: Annotated[Optional[int], V.gt(0), V.ge_field("min_lines")] = None
    max_length: Annotated[
        Optional[int],
        V.or_(
            V.gt(0),
            V.eq(-1),
            message="max_length must be either strictly greater than 0 or equal to -1",
        ),
    ] = None
    password: bool = False
    can_reveal_password: bool = False
    read_only: bool = False
    shift_enter: bool = False
    ignore_up_down_keys: bool = False
    text_align: Optional[TextAlign] = None
    autofocus: bool = False
    capitalization: Optional[TextCapitalization] = None
    autocorrect: bool = True
    enable_suggestions: bool = True
    smart_dashes_type: bool = True
    smart_quotes_type: bool = True
    show_cursor: bool = True
    cursor_color: Optional[ColorValue] = None
    cursor_error_color: Optional[ColorValue] = None
    cursor_width: Number = 2.0
    cursor_height: Optional[Number] = None
    cursor_radius: Optional[Number] = None
    selection_color: Optional[ColorValue] = None
    input_filter: Optional[InputFilter] = None
    obscuring_character: str = "•"
    enable_interactive_selection: bool = True
    enable_ime_personalized_learning: bool = True
    can_request_focus: bool = True
    ignore_pointers: bool = False
    enable_stylus_handwriting: bool = True
    animate_cursor_opacity: Optional[bool] = None
    always_call_on_tap: bool = False
    scroll_padding: PaddingValue = 20
    clip_behavior: ClipBehavior = ClipBehavior.HARD_EDGE
    keyboard_brightness: Optional[Brightness] = None
    mouse_cursor: Optional[MouseCursor] = None
    strut_style: Optional[StrutStyle] = None
    autofill_hints: Optional[Union[AutofillHint, list[AutofillHint]]] = None
    search_mode: bool = False
    clear_button: bool = True
    debounce_ms: Annotated[int, V.ge(0)] = 300
    searching: bool = False
    show_refresh_action: bool = False
    refresh_action_disabled: bool = False
    refresh_action_tooltip: str = "Actualiser"
    state: PaperNestTextFieldState = PaperNestTextFieldState.NORMAL
    state_message: Optional[str] = None
    select_all_on_focus: bool = False
    clear_on_escape: bool = True
    blur_on_empty_escape: bool = True

    on_change: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_selection_change: Optional[EventHandler[TextSelectionChangeEvent["PaperNestTextField"]]] = None
    on_click: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_submit: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_focus: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_blur: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_tap_outside: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_search: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_clear: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_escape: Optional[ControlEventHandler["PaperNestTextField"]] = None
    on_refresh_action: Optional[ControlEventHandler["PaperNestTextField"]] = None

    def _migrate_state(self, other: BaseControl):
        super()._migrate_state(other)
        if (
            isinstance(other, PaperNestTextField)
            and self.value is None
            and self.value != other.value
        ):
            self.value = other.value

    def before_update(self):
        super().before_update()
        if (
            self.bgcolor is not None
            or self.fill_color is not None
            or self.hover_color is not None
            or self.focused_color is not None
        ) and self.filled is None:
            self.filled = True

        if self.search_mode:
            self.keyboard_type = KeyboardType.WEB_SEARCH
            self.multiline = False
            self.shift_enter = False
