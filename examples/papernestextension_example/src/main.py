import flet as ft
from cards import PageHeader
from panels.papernest_colorpicker_panel import PaperNestColorPickerPanel
from panels.papernest_datepicker_panel import PaperNestDatePickerPanel
from panels.papernest_dropdown_panel import PaperNestDropdownPanel
from panels.papernest_filepicker_panel import PaperNestFilePickerPanel
from panels.papernest_glide_rail_panel import PaperNestGlideRailPanel
from panels.papernest_textfield_panel import PaperNestTextFieldPanel


def main(page: ft.Page) -> None:
    page.title = "PaperNestExtension — Exemples"
    page.padding = 15
    page.scroll = ft.ScrollMode.AUTO

    page.add(
        ft.Column(
            spacing=24,
            controls=[
                PageHeader(
                    title="PaperNestExtension",
                    subtitle="Exemples de tous les contrôles disponibles",
                ),
                ft.Row(
                    vertical_alignment=ft.CrossAxisAlignment.START,
                    spacing=24,
                    controls=[
                        PaperNestTextFieldPanel(page),
                        PaperNestDropdownPanel(page),
                    ],
                ),
                ft.Row(
                    spacing=24,
                    vertical_alignment=ft.CrossAxisAlignment.START,
                    controls=[
                        ft.Column(
                            spacing=24,
                            expand=1,
                            controls=[
                                PaperNestDatePickerPanel(page),
                                PaperNestColorPickerPanel(page),
                            ],
                        ),
                        PaperNestFilePickerPanel(page),
                    ],
                ),
                PageHeader(
                    title="PaperNestGlideRail",
                    subtitle="Rail de navigation compacte qui glisse au survol",
                ),
                PaperNestGlideRailPanel(page),
            ],
        )
    )


ft.run(main)
