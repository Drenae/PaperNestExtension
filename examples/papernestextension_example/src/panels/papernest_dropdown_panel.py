import flet as ft
from cards import AppSection

from papernestextension import (
    PaperNestDropdown,
    PaperNestDropdownOption,
)


class PaperNestDropdownPanel(AppSection):
    def __init__(self, page: ft.Page) -> None:
        self.app_page = page
        self.dropdown_result = ft.Text("Catégorie : aucune")

        self.category_dropdown = PaperNestDropdown(
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
            label="Catégorie",
            hint_text="Choisir une catégorie",
            clear_button=True,
            options=[
                PaperNestDropdownOption(key="administratif", text="Administratif"),
                PaperNestDropdownOption(key="factures", text="Factures"),
                PaperNestDropdownOption(key="sante", text="Santé")
            ],
            on_change=self.on_category_change,
        )

        super().__init__(
            title="PaperNestDropdown",
            icon=ft.Icons.ARROW_DROP_DOWN_CIRCLE_OUTLINED,
            expand=1,
            content=ft.Column(controls=[self.category_dropdown, self.dropdown_result])
        )

    def on_category_change(self, event: ft.ControlEvent) -> None:
        self.dropdown_result.value = f"Catégorie : {event.control.value or 'aucune'}"
        self.app_page.update()