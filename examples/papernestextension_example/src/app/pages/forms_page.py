import flet as ft

from cards import PageHeader
from panels.papernest_dropdown_panel import PaperNestDropdownPanel
from panels.papernest_textfield_panel import PaperNestTextFieldPanel


class FormsPage(ft.Column):
    def __init__(self, page: ft.Page):
        super().__init__(
            expand=True,
            scroll=ft.ScrollMode.AUTO,
            spacing=24,
            controls=[
                PageHeader(
                    title="Formulaires",
                    subtitle="Champs de saisie et listes déroulantes PaperNestExtension",
                ),
                ft.ResponsiveRow(
                    spacing=24,
                    run_spacing=24,
                    vertical_alignment=ft.CrossAxisAlignment.START,
                    controls=[
                        ft.Container(
                            col={"sm": 12, "xl": 6},
                            content=PaperNestTextFieldPanel(page),
                        ),
                        ft.Container(
                            col={"sm": 12, "xl": 6},
                            content=PaperNestDropdownPanel(page),
                        ),
                    ],
                ),
            ],
        )
