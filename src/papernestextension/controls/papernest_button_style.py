from typing import Optional

from flet.controls.alignment import Alignment
from flet.controls.base_control import value
from flet.controls.border import BorderSide
from flet.controls.buttons import OutlinedBorder
from flet.controls.control_state import ControlStateValue
from flet.controls.duration import DurationValue
from flet.controls.padding import PaddingValue
from flet.controls.text_style import TextStyle
from flet.controls.types import (
    ColorValue,
    MouseCursor,
    Number,
    VisualDensity,
)

__all__ = ["PaperNestButtonStyle"]


@value
class PaperNestButtonStyle:
    """Copie PaperNest de ``flet.ButtonStyle``.

    Aucune propriété supplémentaire n'est encore ajoutée. Cette classe sert de
    base fidèle pour l'étude du gradient par état prévue dans la phase 2.
    """

    color: Optional[ControlStateValue[ColorValue]] = None
    """Couleur du texte et des icônes descendants."""

    bgcolor: Optional[ControlStateValue[ColorValue]] = None
    """Couleur de fond du bouton."""

    overlay_color: Optional[ControlStateValue[ColorValue]] = None
    """Couleur de surbrillance des états interactifs."""

    shadow_color: Optional[ControlStateValue[ColorValue]] = None
    """Couleur de l'ombre Material."""

    elevation: Optional[ControlStateValue[Optional[Number]]] = None
    """Élévation Material."""

    animation_duration: Optional[DurationValue] = None
    """Durée des transitions Material de forme et d'élévation."""

    padding: Optional[ControlStateValue[PaddingValue]] = None
    """Espacement intérieur du bouton."""

    side: Optional[ControlStateValue[BorderSide]] = None
    """Bordure extérieure du bouton."""

    shape: Optional[ControlStateValue[OutlinedBorder]] = None
    """Forme Material du bouton."""

    alignment: Optional[Alignment] = None
    """Alignement du contenu."""

    enable_feedback: Optional[bool] = None
    """Active le retour acoustique ou haptique."""

    text_style: Optional[ControlStateValue[TextStyle]] = None
    """Style du texte descendant."""

    icon_size: Optional[ControlStateValue[Optional[Number]]] = None
    """Taille de l'icône."""

    icon_color: Optional[ControlStateValue[ColorValue]] = None
    """Couleur de l'icône."""

    visual_density: Optional[VisualDensity] = None
    """Densité visuelle du bouton."""

    mouse_cursor: Optional[ControlStateValue[MouseCursor]] = None
    """Curseur de souris du bouton."""

    def copy(
        self,
        *,
        color: Optional[ControlStateValue[ColorValue]] = None,
        bgcolor: Optional[ControlStateValue[ColorValue]] = None,
        overlay_color: Optional[ControlStateValue[ColorValue]] = None,
        shadow_color: Optional[ControlStateValue[ColorValue]] = None,
        elevation: Optional[ControlStateValue[Optional[Number]]] = None,
        animation_duration: Optional[DurationValue] = None,
        padding: Optional[ControlStateValue[PaddingValue]] = None,
        side: Optional[ControlStateValue[BorderSide]] = None,
        shape: Optional[ControlStateValue[OutlinedBorder]] = None,
        alignment: Optional[Alignment] = None,
        enable_feedback: Optional[bool] = None,
        text_style: Optional[ControlStateValue[TextStyle]] = None,
        icon_size: Optional[ControlStateValue[Optional[Number]]] = None,
        icon_color: Optional[ControlStateValue[ColorValue]] = None,
        visual_density: Optional[VisualDensity] = None,
        mouse_cursor: Optional[ControlStateValue[MouseCursor]] = None,
    ) -> "PaperNestButtonStyle":
        """Retourne une copie avec les propriétés indiquées remplacées."""
        return PaperNestButtonStyle(
            color=color if color is not None else self.color,
            bgcolor=bgcolor if bgcolor is not None else self.bgcolor,
            overlay_color=(
                overlay_color if overlay_color is not None else self.overlay_color
            ),
            shadow_color=(
                shadow_color if shadow_color is not None else self.shadow_color
            ),
            elevation=elevation if elevation is not None else self.elevation,
            animation_duration=(
                animation_duration
                if animation_duration is not None
                else self.animation_duration
            ),
            padding=padding if padding is not None else self.padding,
            side=side if side is not None else self.side,
            shape=shape if shape is not None else self.shape,
            alignment=alignment if alignment is not None else self.alignment,
            enable_feedback=(
                enable_feedback if enable_feedback is not None else self.enable_feedback
            ),
            text_style=text_style if text_style is not None else self.text_style,
            icon_size=icon_size if icon_size is not None else self.icon_size,
            icon_color=icon_color if icon_color is not None else self.icon_color,
            visual_density=(
                visual_density if visual_density is not None else self.visual_density
            ),
            mouse_cursor=(
                mouse_cursor if mouse_cursor is not None else self.mouse_cursor
            ),
        )
