import flet as ft
from cards import AppSection

from papernestextension import PaperNestColorPicker


class PaperNestColorPickerPanel(AppSection):
    def __init__(self, page: ft.Page) -> None:
        self.app_page = page
        self.color_picker_result = ft.Text("Valeur : None")

        self.color_picker = PaperNestColorPicker(
            label="Couleur du document",
            hint_text="Sélectionner une couleur",
            value=ft.Colors.YELLOW_800,
            clear_button=True,
            enable_label=True,
            on_change=self.on_color_change,
            on_cleared=self.on_color_cleared,
            expand=True,
        )

        super().__init__(
            title="PaperNestColorPicker",
            icon=ft.Icons.COLOR_LENS_OUTLINED,
            expand=1,
            content=ft.Column(
                controls=[
                    ft.Text(
                        "Le contrôle reprend la base du PaperNestDatePicker et "
                        "ouvre un MaterialPicker dans un dialogue."
                    ),
                    self.color_picker,
                    self.color_picker_result,
                ]
            ),
        )

    def on_color_change(self, event: ft.ControlEvent) -> None:
        self.color_picker_result.value = f"Valeur : {self.color_picker.value}"
        self.color_picker_result.update()

    def on_color_cleared(self, event: ft.ControlEvent) -> None:
        self.color_picker_result.value = "Valeur : None"
        self.color_picker_result.update()
