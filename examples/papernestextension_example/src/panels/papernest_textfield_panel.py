import flet as ft

from cards import AppSection
from papernestextension import (
    PaperNestButton,
    PaperNestButtonStyle,
    PaperNestTextField,
)


class PaperNestTextFieldPanel(AppSection):
    def __init__(self, page: ft.Page) -> None:
        self.app_page = page
        self.textfield_result = ft.Text("Aucune action")

        common_field_style = dict(
            bgcolor=ft.Colors.WHITE,
            filled=True,
            border_width=1,
            focused_border_width=2,
            border_color=ft.Colors.GREY_500,
            focused_border_color=ft.Colors.YELLOW_800,
            border_radius=10,
            text_style=ft.TextStyle(color=ft.Colors.GREY_900, size=16),
            hint_style=ft.TextStyle(color=ft.Colors.GREY_600, size=16),
            label_style=ft.TextStyle(color=ft.Colors.GREY_700, size=14),
            hover_color=ft.Colors.TRANSPARENT,
            content_padding=ft.Padding.symmetric(horizontal=12, vertical=0),
            expand=True,
        )

        self.search_field = PaperNestTextField(
            **common_field_style,
            label="Rechercher un document",
            hint_text="Nom, catégorie, tag…",
            search_mode=True,
            clear_button=True,
            debounce_ms=300,
            on_search=self.on_search,
        )

        normal_field = PaperNestTextField(
            **common_field_style,
            label="Champ normal",
            hint_text="Aucun bouton picker",
            value="Texte modifiable",
        )

        simple_picker = PaperNestTextField(
            **common_field_style,
            label="Picker simple",
            hint_text="Sélectionner une valeur",
            read_only=True,
            picker=True,
            picker_button=self._picker_button("Choisir"),
        )

        clear_picker = PaperNestTextField(
            **common_field_style,
            label="Picker avec effacement",
            value="Banque",
            read_only=True,
            picker=True,
            clear_button=True,
            picker_button=self._picker_button("Choisir"),
            on_clear=self.on_clear,
        )

        animated_picker = PaperNestTextField(
            **common_field_style,
            label="Bouton entièrement piloté depuis Python",
            value="Documents administratifs",
            read_only=True,
            picker=True,
            clear_button=True,
            picker_button=PaperNestButton(
                content="Choisir",
                color=ft.Colors.GREY_900,
                elevation=1,
                height=36,
                hover_scale=1.03,
                click_scale=0.96,
                animation_duration=140,
                style=PaperNestButtonStyle(
                    shape=ft.RoundedRectangleBorder(radius=8),
                    padding=ft.Padding.symmetric(horizontal=16, vertical=0),
                    mouse_cursor=ft.MouseCursor.CLICK,
                    gradient={
                        ft.ControlState.DEFAULT: ft.LinearGradient(
                            begin=ft.Alignment.CENTER_LEFT,
                            end=ft.Alignment.CENTER_RIGHT,
                            colors=[ft.Colors.YELLOW_700, ft.Colors.YELLOW_800],
                        ),
                        ft.ControlState.HOVERED: ft.LinearGradient(
                            begin=ft.Alignment.CENTER_LEFT,
                            end=ft.Alignment.CENTER_RIGHT,
                            colors=[ft.Colors.YELLOW_600, ft.Colors.YELLOW_700],
                        ),
                    },
                ),
                on_click=self.on_picker_click,
            ),
            on_clear=self.on_clear,
        )

        long_value_picker = PaperNestTextField(
            **common_field_style,
            label="Valeur longue",
            value=(
                "Un libellé volontairement très long pour vérifier que le texte "
                "reste correctement contraint avant les actions"
            ),
            read_only=True,
            picker=True,
            clear_button=True,
            picker_button=self._picker_button("Choisir"),
        )

        disabled_picker = PaperNestTextField(
            **common_field_style,
            label="Picker désactivé",
            value="Valeur indisponible",
            read_only=True,
            disabled=True,
            picker=True,
            clear_button=True,
            picker_button=self._picker_button("Choisir"),
        )

        super().__init__(
            title="PaperNestTextField",
            icon=ft.Icons.DYNAMIC_FORM_OUTLINED,
            expand=1,
            content=ft.Column(
                spacing=16,
                controls=[
                    normal_field,
                    self.search_field,
                    simple_picker,
                    clear_picker,
                    animated_picker,
                    long_value_picker,
                    disabled_picker,
                    self.textfield_result,
                ],
            ),
        )

    def _picker_button(self, text: str) -> PaperNestButton:
        return PaperNestButton(
            content=text,
            color=ft.Colors.GREY_900,
            bgcolor=ft.Colors.YELLOW_700,
            height=36,
            elevation=0,
            hover_scale=1.02,
            click_scale=0.97,
            animation_duration=120,
            style=PaperNestButtonStyle(
                shape=ft.RoundedRectangleBorder(radius=8),
                padding=ft.Padding.symmetric(horizontal=14, vertical=0),
                mouse_cursor=ft.MouseCursor.CLICK,
            ),
            on_click=self.on_picker_click,
        )

    def on_search(self, event: ft.ControlEvent) -> None:
        self.textfield_result.value = (
            f"Recherche : {event.control.value or 'vide'}"
        )
        self.app_page.update()

    def on_picker_click(self, _event: ft.ControlEvent) -> None:
        self.textfield_result.value = "Bouton Choisir déclenché"
        self.app_page.update()

    def on_clear(self, _event: ft.ControlEvent) -> None:
        self.textfield_result.value = "Valeur effacée"
        self.app_page.update()
