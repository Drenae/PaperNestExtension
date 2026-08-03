from dataclasses import field
from typing import Optional, Union

from flet.controls.adaptive_control import AdaptiveControl
from flet.controls.base_control import control
from flet.controls.control import Control
from flet.controls.control_event import ControlEventHandler
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

from papernestextension.controls.papernest_button_style import PaperNestButtonStyle

__all__ = ["PaperNestButton"]


@control("PaperNestButton")
class PaperNestButton(LayoutControl, AdaptiveControl):
    """Copie PaperNest du contrôle Material ``Button`` de Flet.

    Cette base conserve volontairement le comportement natif avant l'ajout des
    fonctionnalités propres à PaperNestExtension dans les phases suivantes.
    """

    content: Optional[StrOrControl] = None
    """Libellé du bouton, sous forme de chaîne ou de contrôle Flet."""

    icon: Optional[IconDataOrControl] = None
    """Icône affichée dans le bouton."""

    icon_color: Optional[ColorValue] = None
    """Couleur de l'icône."""

    color: Optional[ColorValue] = field(default=None, metadata={"skip": True})
    """Couleur de premier plan du bouton."""

    bgcolor: Optional[ColorValue] = field(default=None, metadata={"skip": True})
    """Couleur de fond du bouton."""

    elevation: Number = field(default=1, metadata={"skip": True})
    """Élévation Material du bouton."""

    style: Optional[PaperNestButtonStyle] = field(
        default=None,
        metadata={"skip": True},
    )
    """Style Material du bouton."""

    autofocus: Optional[bool] = None
    """Indique si le bouton reçoit automatiquement le focus."""

    clip_behavior: Optional[ClipBehavior] = None
    """Comportement de découpage du bouton."""

    url: Optional[Union[str, Url]] = None
    """URL ouverte lors du clic."""

    on_click: Optional[ControlEventHandler["PaperNestButton"]] = None
    """Déclenché lors du clic."""

    on_long_press: Optional[ControlEventHandler["PaperNestButton"]] = None
    """Déclenché lors d'un appui long."""

    on_hover: Optional[ControlEventHandler["PaperNestButton"]] = None
    """Déclenché lorsque l'état de survol change."""

    on_focus: Optional[ControlEventHandler["PaperNestButton"]] = None
    """Déclenché lorsque le bouton reçoit le focus."""

    on_blur: Optional[ControlEventHandler["PaperNestButton"]] = None
    """Déclenché lorsque le bouton perd le focus."""

    __validation_rules__: ValidationRules = (
        V.ensure(
            lambda ctrl: (
                (
                    isinstance(ctrl.icon, IconData)
                    or (isinstance(ctrl.icon, Control) and ctrl.icon.visible)
                )
                or (
                    isinstance(ctrl.content, str)
                    or (isinstance(ctrl.content, Control) and ctrl.content.visible)
                )
            ),
            message=(
                "at least icon or content (string or visible Control) must be provided"
            ),
        ),
    )

    def before_update(self):
        super().before_update()
        if (
            self.style is not None
            or self.color is not None
            or self.bgcolor is not None
            or self.elevation != 1
        ):
            self._internals["style"] = (
                self.style or PaperNestButtonStyle()
            ).copy(
                color=self.color,
                bgcolor=self.bgcolor,
                elevation=self.elevation,
            )
        else:
            self._internals.pop("style", None)

    async def focus(self):
        """Demande le focus pour ce contrôle."""
        await self._invoke_method("focus")
