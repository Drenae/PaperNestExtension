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
            clear_tooltip="Effacer la couleur",
            enable_label=True,
            on_change=self.on_color_change,
            on_clear=self.on_color_clear,
            expand=True,
        )

        super().__init__(
            title="PaperNestColorPicker",
            icon=ft.Icons.COLOR_LENS_OUTLINED,
            expand=1,
            content=ft.Column(
                controls=[
                    ft.Text(
                        "Toute la surface ouvre le MaterialPicker. La valeur est "
                        "toujours renvoyée au format #RRGGBB."
                    ),
                    self.color_picker,
                    self.color_picker_result,
                ]
            ),
        )

    def on_color_change(self, event: ft.ControlEvent) -> None:
        self.color_picker_result.value = f"Valeur : {self.color_picker.value}"
        self.color_picker_result.update()

    def on_color_clear(self, event: ft.ControlEvent) -> None:
        self.color_picker_result.value = "Valeur : None"
        self.color_picker_result.update()
