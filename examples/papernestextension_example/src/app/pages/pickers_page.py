import flet as ft

from cards import PageHeader
from panels.papernest_filepicker_panel import PaperNestFilePickerPanel


class PickersPage(ft.Column):
    def __init__(self, page: ft.Page):
        super().__init__(
            expand=True,
            scroll=ft.ScrollMode.AUTO,
            spacing=24,
            controls=[
                PageHeader(
                    title="Pickers",
                    subtitle="Sélection et glisser-déposer de fichiers",
                ),
                ft.ResponsiveRow(
                    spacing=24,
                    run_spacing=24,
                    vertical_alignment=ft.CrossAxisAlignment.START,
                    controls=[
                        ft.Container(
                            col={"sm": 12, "xl": 8},
                            content=PaperNestFilePickerPanel(page),
                        ),
                    ],
                ),
            ],
        )
