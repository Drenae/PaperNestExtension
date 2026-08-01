import flet as ft

from cards import PageHeader
from panels.papernest_colorpicker_panel import PaperNestColorPickerPanel
from panels.papernest_datepicker_panel import PaperNestDatePickerPanel
from panels.papernest_filepicker_panel import PaperNestFilePickerPanel
from panels.papernest_iconpicker_panel import PaperNestIconPickerPanel


class PickersPage(ft.Column):
    def __init__(self, page: ft.Page):
        super().__init__(
            expand=True,
            scroll=ft.ScrollMode.AUTO,
            spacing=24,
            controls=[
                PageHeader(
                    title="Pickers",
                    subtitle="Sélecteurs de couleur, date, fichiers et icônes",
                ),
                ft.ResponsiveRow(
                    spacing=24,
                    run_spacing=24,
                    vertical_alignment=ft.CrossAxisAlignment.START,
                    controls=[
                        ft.Container(
                            col={"sm": 12, "xl": 6},
                            content=PaperNestDatePickerPanel(page),
                        ),
                        ft.Container(
                            col={"sm": 12, "xl": 6},
                            content=PaperNestColorPickerPanel(page),
                        ),
                        ft.Container(
                            col={"sm": 12, "xl": 6},
                            content=PaperNestIconPickerPanel(page),
                        ),
                        ft.Container(
                            col={"sm": 12, "xl": 6},
                            content=PaperNestFilePickerPanel(page),
                        ),
                    ],
                ),
            ],
        )
