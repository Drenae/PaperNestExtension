import flet as ft
from papernestextension import PaperNestIconPicker, PaperNestIconPickerOption


class PaperNestIconPickerPanel(ft.Container):
    def __init__(self, page: ft.Page):
        self.selected_value = ft.Text("Valeur : FOLDER_ROUNDED")
        options = [
            ("Dossier", "FOLDER_ROUNDED", ft.Icons.FOLDER_ROUNDED),
            ("Identité", "BADGE_ROUNDED", ft.Icons.BADGE_ROUNDED),
            ("Logement", "OTHER_HOUSES_ROUNDED", ft.Icons.OTHER_HOUSES_ROUNDED),
            ("Santé", "HEALTH_AND_SAFETY_ROUNDED", ft.Icons.HEALTH_AND_SAFETY_ROUNDED),
            ("Fiscalité", "REQUEST_QUOTE_ROUNDED", ft.Icons.REQUEST_QUOTE_ROUNDED),
            ("Banque", "ACCOUNT_BALANCE_ROUNDED", ft.Icons.ACCOUNT_BALANCE_ROUNDED),
            ("Assurance", "VERIFIED_USER_ROUNDED", ft.Icons.VERIFIED_USER_ROUNDED),
            ("Travail", "WORK_ROUNDED", ft.Icons.WORK_ROUNDED),
            ("Véhicule", "DIRECTIONS_CAR_ROUNDED", ft.Icons.DIRECTIONS_CAR_ROUNDED),
            ("Famille", "FAMILY_RESTROOM_ROUNDED", ft.Icons.FAMILY_RESTROOM_ROUNDED),
            ("Études", "SCHOOL_ROUNDED", ft.Icons.SCHOOL_ROUNDED),
            ("Archives", "ARCHIVE_ROUNDED", ft.Icons.ARCHIVE_ROUNDED),
        ]

        def handle_change(event: ft.ControlEvent) -> None:
            self.selected_value.value = f"Valeur : {event.data}"
            page.update()

        picker = PaperNestIconPicker(
            label="Icône",
            value="FOLDER_ROUNDED",
            fallback_value="FOLDER_ROUNDED",
            picker_title="Choisir une icône",
            picker_description="Sélectionnez une icône puis confirmez votre choix.",
            cancel_text="Annuler",
            confirm_text="Appliquer",
            fill_color="#FFFFFF",
            border_color="#BDBDBD",
            focused_border_color="#F9A825",
            selected_color="#C17900",
            selected_bgcolor="#FFF8E1",
            selected_border_color="#F9A825",
            hover_color="#14F9A825",
            border_radius=10,
            option_border_radius=10,
            options=[
                PaperNestIconPickerOption(label=label, value=value, icon=icon)
                for label, value, icon in options
            ],
            on_change=handle_change,
        )

        super().__init__(
            padding=24,
            border=ft.Border.all(1, "#D9DCE3"),
            border_radius=16,
            bgcolor="#FFFFFF",
            content=ft.Column(
                tight=True,
                spacing=16,
                controls=[
                    ft.Text("PaperNestIconPicker", size=18, weight=ft.FontWeight.BOLD),
                    ft.Text(
                        "Sélecteur d'icône avec galerie responsive et validation explicite.",
                        size=13,
                        color="#666C76",
                    ),
                    picker,
                    self.selected_value,
                ],
            ),
        )
