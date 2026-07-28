import flet as ft
from cards import AppSection

from papernestextension import PaperNestTextField


class PaperNestTextFieldPanel(AppSection):
    def __init__(self, page: ft.Page) -> None:
        self.app_page = page
        self.textfield_result = ft.Text("Aucune recherche")

        self.search_field = PaperNestTextField(
            bgcolor=ft.Colors.WHITE,
            filled=True,
            border_width=1,
            focused_border_width=2,
            border_color=ft.Colors.GREY_500,
            focused_border_color=ft.Colors.YELLOW_800,
            border_radius=10,
            text_style=ft.TextStyle(color=ft.Colors.GREY_900, size=16),
            hint_style = ft.TextStyle(color=ft.Colors.GREY_600, size=16),
            label_style = ft.TextStyle(color=ft.Colors.GREY_700, size=14),
            hover_color=ft.Colors.TRANSPARENT,
            content_padding=ft.Padding.symmetric(horizontal=12, vertical=0),
            label="Rechercher un document",
            hint_text="Nom, catégorie, tag…",
            search_mode=True,
            clear_button=True,
            expand=True,
            debounce_ms=300,
            on_search=self.on_search,
        )

        super().__init__(
            title="PaperNestTextField",
            icon=ft.Icons.DYNAMIC_FORM_OUTLINED,
            expand=1,
            content=ft.Column(controls=[self.search_field, self.textfield_result])
        )

    def on_search(self, event: ft.ControlEvent) -> None:
        self.textfield_result.value = f"Recherche : {event.control.value or 'vide'}"
        self.app_page.update()