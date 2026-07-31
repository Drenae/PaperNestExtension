from typing import Optional, Union

from flet.controls.base_control import control
from flet.controls.border_radius import BorderRadiusValue
from flet.controls.control import Control
from flet.controls.control_event import ControlEventHandler
from flet.controls.layout_control import LayoutControl
from flet.controls.padding import PaddingValue
from flet.controls.text_style import TextStyle
from flet.controls.types import ColorValue, IconDataOrControl, Number

__all__ = [
    "PaperNestGlideRail",
    "PaperNestGlideRailDestination",
]


@control("PaperNestGlideRailDestination")
class PaperNestGlideRailDestination(Control):
    """Destination affichée dans :class:`PaperNestGlideRail`.

    ``icon`` et ``selected_icon`` acceptent aussi bien une icône Flet qu'un
    contrôle personnalisé, par exemple ``ft.Image(src="assets/logo.svg")``.
    Dans le cas d'une image, sa largeur et sa hauteur doivent être définies sur
    le contrôle lui-même : ``icon_size`` ne concerne que les icônes Flet.
    """

    label: str = ""
    icon: Optional[IconDataOrControl] = None
    selected_icon: Optional[IconDataOrControl] = None
    tooltip: Optional[str] = None


@control("PaperNestGlideRail")
class PaperNestGlideRail(LayoutControl):
    """Rail compacte qui glisse et se déploie au survol.

    Le contrôle doit être placé dans une pile au-dessus du contenu. Sa largeur
    passe de ``collapsed_width`` à ``expanded_width`` lorsque le pointeur entre
    dans sa zone, puis revient à sa largeur compacte lorsque le pointeur sort.

    ``brand_icon`` accepte une icône Flet ou tout contrôle visuel, notamment un
    ``ft.Image`` utilisant un PNG ou un SVG personnalisé.

    ``brand_title`` et ``brand_subtitle`` acceptent soit une chaîne pour le
    rendu natif par défaut, soit un contrôle Flet tel que ``ft.Text`` pour
    personnaliser librement couleur, police, graisse et autres propriétés.
    """

    destinations: Optional[list[PaperNestGlideRailDestination]] = None
    secondary_destinations: Optional[list[PaperNestGlideRailDestination]] = None
    selected_index: int = 0

    collapsed_width: Number = 76
    expanded_width: Number = 280
    animation_duration: int = 220
    animation_curve: str = "easeOutCubic"

    bgcolor: Optional[ColorValue] = None
    shadow_color: Optional[ColorValue] = None
    elevation: Number = 8
    border_radius: Optional[BorderRadiusValue] = None
    padding: Optional[PaddingValue] = None

    item_height: Number = 48
    item_spacing: Number = 4
    icon_size: Number = 24
    item_border_radius: Optional[BorderRadiusValue] = None
    item_padding: Optional[PaddingValue] = None

    hover_scale: Number = 1.025
    hover_animation_duration: int = 140

    color: Optional[ColorValue] = None
    selected_color: Optional[ColorValue] = None
    hover_color: Optional[ColorValue] = None
    selected_bgcolor: Optional[ColorValue] = None
    selected_border_color: Optional[ColorValue] = None
    divider_color: Optional[ColorValue] = None

    text_style: Optional[TextStyle] = None
    selected_text_style: Optional[TextStyle] = None

    brand_icon: Optional[IconDataOrControl] = None
    brand_title: Optional[Union[str, Control]] = None
    brand_subtitle: Optional[Union[str, Control]] = None
    brand_height: Number = 64

    on_change: Optional[ControlEventHandler["PaperNestGlideRail"]] = None
    on_expand: Optional[ControlEventHandler["PaperNestGlideRail"]] = None
    on_collapse: Optional[ControlEventHandler["PaperNestGlideRail"]] = None

    async def _trigger_event(self, event_name, event_data):
        if event_name == "change":
            try:
                self.selected_index = int(event_data)
            except (TypeError, ValueError):
                pass
        await super()._trigger_event(event_name, event_data)

    async def expand_rail(self) -> None:
        await self._invoke_method("expand")

    async def collapse_rail(self) -> None:
        await self._invoke_method("collapse")
