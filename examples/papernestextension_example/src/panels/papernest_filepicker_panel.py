import flet as ft
from buttons import PrimaryButton, OutlineButton, SuccessButton, DangerButton, GhostButton
from cards import AppSection

from papernestextension import (
    PaperNestFilePicker,
    PaperNestFilePickerFileEvent,
    PaperNestFilePickerFilesChangedEvent,
    PaperNestFilePickerState,
    PaperNestFilePickerValidationEvent,
)


class PaperNestFilePickerPanel(AppSection):
    def __init__(self, page: ft.Page) -> None:
        self.app_page = page
        self.file_picker_status = ft.Text("Aucun fichier sélectionné")
        self.last_action = ft.Text("", size=12)

        self.file_picker = PaperNestFilePicker(
            drag_and_drop=True,
            allow_multiple=True,
            dialog_title="Sélectionner des documents",
            allowed_extensions=["pdf", "png", "jpg", "jpeg"],
            drop_text="Déposez vos documents ici",
            drop_subtitle="ou cliquez pour ouvrir l'explorateur",
            icon=ft.Icons.UPLOAD_FILE_OUTLINED,
            icon_color=ft.Colors.DEEP_PURPLE,
            icon_size=42,
            file_icon_size=22,
            use_file_type_colors=True,
            click_to_pick=True,
            max_file_size="50 MB",
            max_files=5,
            show_constraints=True,
            show_file_list=True,
            show_file_size=True,
            on_files_changed=self.on_files_changed,
            on_file_added=self.on_file_added,
            on_file_removed=self.on_file_removed,
            on_duplicate_file=self.on_duplicate_file,
            on_validation_error=self.on_validation_error,
            on_invalid_extension=self.on_invalid_extension,
            on_file_too_large=self.on_file_too_large,
            on_max_files_reached=self.on_max_files_reached,
            hover_border_color=ft.Colors.DEEP_PURPLE,
            hover_background_color=ft.Colors.DEEP_PURPLE_50,
            drag_border_color=ft.Colors.BLUE,
            drag_background_color=ft.Colors.BLUE_50,
            success_border_color=ft.Colors.GREEN,
            success_background_color=ft.Colors.GREEN_50,
            error_border_color=ft.Colors.RED,
            error_background_color=ft.Colors.RED_50,
        )

        super().__init__(
            title="PaperNestFilePicker",
            icon=ft.Icons.FILE_COPY_OUTLINED,
            expand=1,
            content=ft.Column(
                controls=[
                    ft.Text(
                        "Le clic, l'explorateur et le glisser-déposer alimentent "
                        "une seule liste intégrée. La V1.4.0 ajoute la validation "
                        "des extensions, de la taille et du nombre de fichiers."
                    ),
                    self.file_picker,
                    ft.Row(
                        controls=[
                            PrimaryButton("Ajouter des fichiers", icon=ft.Icons.FOLDER_OPEN, on_click=self.browse_files),
                            OutlineButton("Vider la sélection", icon=ft.Icons.DELETE_SWEEP_OUTLINED, on_click=self.clear_files),
                        ]
                    ),
                    ft.Divider(),
                    ft.Text(
                        "États manuels",
                        weight=ft.FontWeight.W_600,
                    ),
                    ft.Row(
                        controls=[
                            PrimaryButton("Normal", on_click=lambda _: self.set_file_picker_state(PaperNestFilePickerState.NORMAL)),
                            SuccessButton("Succès", on_click=lambda _: self.set_file_picker_state(PaperNestFilePickerState.SUCCESS)),
                            DangerButton("Erreur", on_click=lambda _: self.set_file_picker_state(PaperNestFilePickerState.ERROR)),
                            GhostButton("Désactivé", on_click=lambda _: self.set_file_picker_state(PaperNestFilePickerState.DISABLED))
                        ]
                    ),
                    ft.Divider(),
                    ft.Text(
                        "HOVER et DRAG_OVER sont appliqués automatiquement. "
                        "L'état DISABLED visuel peut être testé ici ; pour bloquer "
                        "réellement le contrôle, utilisez disabled=True."
                    ),
                    self.file_picker_status,
                    self.last_action,
                ]
            ),
        )

    def on_files_changed(self, event: PaperNestFilePickerFilesChangedEvent) -> None:
        count = len(event.selected_files)
        self.file_picker_status.value = (
            "Aucun fichier sélectionné"
            if count == 0
            else f"{count} fichier{'s' if count > 1 else ''} dans la sélection"
        )
        self.app_page.update()

    def on_file_added(self, event: PaperNestFilePickerFileEvent) -> None:
        self.last_action.value = f"Ajout : {event.selected_file.name}"
        self.app_page.update()

    def on_file_removed(self, event: PaperNestFilePickerFileEvent) -> None:
        self.last_action.value = f"Suppression : {event.selected_file.name}"
        self.app_page.update()

    def on_duplicate_file(self, event: PaperNestFilePickerFileEvent) -> None:
        self.last_action.value = f"Doublon ignoré : {event.selected_file.name} est déjà sélectionné"
        self.app_page.update()

    def on_validation_error(self, event: PaperNestFilePickerValidationEvent) -> None:
        self.last_action.value = f"Refus : {event.selected_file.name} — {event.message}"
        self.app_page.update()

    def on_invalid_extension(self, event: PaperNestFilePickerValidationEvent) -> None:
        print(f"Extension refusée : {event.selected_file.name}")

    def on_file_too_large(self, event: PaperNestFilePickerValidationEvent) -> None:
        print(f"Fichier trop volumineux : {event.selected_file.name}")

    def on_max_files_reached(self, event: PaperNestFilePickerValidationEvent) -> None:
        print(f"Nombre maximal atteint avec : {event.selected_file.name}")

    def set_file_picker_state(self, state: PaperNestFilePickerState) -> None:
        self.file_picker.state = state
        self.last_action.value = f"État manuel : {state.value}"
        self.app_page.update()

    async def browse_files(self, _: ft.ControlEvent) -> None:
        await self.file_picker.pick_files(
            dialog_title="Ajouter des documents",
            allow_multiple=True,
            allowed_extensions=["pdf", "png", "jpg", "jpeg"],
        )

    async def clear_files(self, _: ft.ControlEvent) -> None:
        await self.file_picker.clear_files()
