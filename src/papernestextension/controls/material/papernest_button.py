from typing import Optional, Union

from flet.controls.base_control import control
from flet.controls.buttons import ButtonStyle
from flet.controls.control import Control
from flet.controls.control_event import ControlEventHandler
from flet.controls.duration import DurationValue
from flet.controls.gradients import Gradient
from flet.controls.icon_data import IconData
from flet.controls.layout_control import LayoutControl
from flet.controls.types import (
    ClipBehavior,
    ColorValue,
    IconDataOrControl,
    Number,
    StrOrControl,
    Url,
)
from flet.utils.validation import V, ValidationRules

__all__ = ["PaperNestButton"]


@control("PaperNestButton")
class PaperNestButton(LayoutControl):
    """Bouton Material avec gradients et animations PaperNest.

    Le contrôle Flutter ne définit aucune variante visuelle. Les couleurs,
    bordures, formes et styles sont entièrement construits côté Python avec
    ``color``, ``bgcolor`` et ``ButtonStyle``.
    """

    content: Optional[StrOrControl] = None
    icon: Optional[IconDataOrControl] = None
    trailing_icon: Optional[IconDataOrControl] = None
    icon_color: Optional[ColorValue] = None

    color: Optional[ColorValue] = None
    bgcolor: Optional[ColorValue] = None
    elevation: Number = 0
    style: Optional[ButtonStyle] = None

    gradient: Optional[Gradient] = None
    hover_gradient: Optional[Gradient] = None

    loading: bool = False
    loading_text: Optional[str] = None
    loading_indicator_color: Optional[ColorValue] = None
    loading_indicator_size: Number = 16
    loading_indicator_stroke_width: Number = 2

    hover_scale: Number = 1.02
    click_scale: Number = 0.98
    hover_offset_y: Number = -1
    click_offset_y: Number = 0
    animation_duration: DurationValue = 160
    animation_curve: str = "easeOutCubic"

    autofocus: Optional[bool] = None
    clip_behavior: Optional[ClipBehavior] = None
    url: Optional[Union[str, Url]] = None

    on_click: Optional[ControlEventHandler["PaperNestButton"]] = None
    on_long_press: Optional[ControlEventHandler["PaperNestButton"]] = None
    on_hover: Optional[ControlEventHandler["PaperNestButton"]] = None
    on_focus: Optional[ControlEventHandler["PaperNestButton"]] = None
    on_blur: Optional[ControlEventHandler["PaperNestButton"]] = None

    __validation_rules__: ValidationRules = (
        V.ensure(
            lambda ctrl: (
                isinstance(ctrl.icon, IconData)
                or (isinstance(ctrl.icon, Control) and ctrl.icon.visible)
                or isinstance(ctrl.content, str)
                or (isinstance(ctrl.content, Control) and ctrl.content.visible)
            ),
            message="at least icon or content (string or visible Control) must be provided",
        ),
    )

    async def focus(self) -> None:
        await self._invoke_method("focus")

    def set_loading(
        self,
        loading: bool,
        *,
        loading_text: Optional[str] = None,
        update: bool = True,
    ) -> None:
        """Active ou désactive l'état de chargement du bouton."""
        self.loading = loading
        if loading_text is not None:
            self.loading_text = loading_text
        if update:
            self.update()
