from dataclasses import field
from typing import Optional, Union

from flet.controls.adaptive_control import AdaptiveControl
from flet.controls.base_control import control
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

from papernestextension.controls.papernest_button_style import PaperNestButtonStyle

__all__ = ["PaperNestButton"]


@control("PaperNestButton")
class PaperNestButton(LayoutControl, AdaptiveControl):
    """Bouton Material Flet enrichi pour les besoins de PaperNest.

    Le comportement natif de ``Button`` est conservé. Les ajouts concernent
    le gradient, le chargement et les transformations animées au survol/clic.
    Le gradient peut être fourni directement ou par état dans
    :class:`PaperNestButtonStyle`.
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
    """Couleur de fond du bouton lorsqu'aucun gradient n'est résolu."""

    gradient: Optional[Gradient] = field(default=None, metadata={"skip": True})
    """Gradient direct du bouton, fusionné dans ``style`` comme état par défaut."""

    elevation: Number = field(default=1, metadata={"skip": True})
    """Élévation Material du bouton."""

    style: Optional[PaperNestButtonStyle] = field(
        default=None,
        metadata={"skip": True},
    )
    """Style Material et gradient par état du bouton."""

    loading: bool = False
    """Désactive l'action et affiche un indicateur de progression."""

    loading_text: Optional[str] = None
    """Texte temporaire affiché pendant le chargement lorsqu'il est renseigné."""

    loading_indicator_color: Optional[ColorValue] = None
    """Couleur de l'indicateur, sinon la couleur de premier plan est utilisée."""

    loading_indicator_size: Number = 16
    """Diamètre de l'indicateur de progression."""

    loading_indicator_stroke_width: Number = 2
    """Épaisseur du trait de l'indicateur de progression."""

    hover_scale: Number = 1.0
    """Facteur d'échelle appliqué au survol."""

    click_scale: Number = 1.0
    """Facteur d'échelle appliqué pendant l'animation de clic."""

    hover_offset_y: Number = 0
    """Translation verticale en pixels appliquée au survol."""

    click_offset_y: Number = 0
    """Translation verticale en pixels appliquée pendant l'animation de clic."""

    animation_duration: DurationValue = 160
    """Durée des animations PaperNest de survol et de clic."""

    animation_curve: str = "easeOutCubic"
    """Courbe Flutter utilisée pour les animations PaperNest."""

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
            or self.gradient is not None
            or self.elevation != 1
        ):
            self._internals["style"] = (
                self.style or PaperNestButtonStyle()
            ).copy(
                color=self.color,
                bgcolor=self.bgcolor,
                gradient=self.gradient,
                elevation=self.elevation,
            )
        else:
            self._internals.pop("style", None)

    async def focus(self):
        """Demande le focus pour ce contrôle."""
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
