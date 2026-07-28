from datetime import datetime

import flet as ft
from cards import AppSection

from papernestextension import PaperNestDatePicker


class PaperNestDatePickerPanel(AppSection):
    def __init__(self, page: ft.Page) -> None:
        self.app_page = page
        self.date_picker_result = ft.Text("Valeur : None")

        self.date_picker = PaperNestDatePicker(
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
            label="Date du document",
            hint_text="jj/mm/aaaa",
            prefix_icon=ft.Icons.EVENT_ROUNDED,
            clear_button=True,
            on_cleared=self.on_date_cleared,
            first_date=datetime(1900, 1, 1),
            last_date=datetime(2050, 12, 31),
            on_change=self.on_date_change,
            expand=True,
        )

        super().__init__(
            title="PaperNestDatePicker",
            icon=ft.Icons.CALENDAR_MONTH_OUTLINED,
            expand=1,
            content=ft.Column(
                controls=[
                    ft.Text(
                        "Le contrôle ressemble à un champ Material mais agit comme "
                        "un bouton : un clic n'importe où ouvre le calendrier."
                    ),
                    self.date_picker,
                    self.date_picker_result,
                ]
            ),
        )

    def on_date_cleared(self, event: ft.ControlEvent) -> None:
        self.date_picker_result.value = "Valeur : None"
        self.date_picker_result.update()

    def on_date_change(self, event: ft.ControlEvent) -> None:
        value = self.date_picker.value
        formatted = value.strftime("%d-%m-%Y") if value else None
        self.date_picker_result.value = f"Valeur : {formatted}"
        self.date_picker_result.update()
