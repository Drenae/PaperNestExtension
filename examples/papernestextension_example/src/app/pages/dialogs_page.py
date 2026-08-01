import flet as ft
from papernestextension import PaperNestAlertDialog, PaperNestDialogVariant

from cards import PageHeader


class DialogsPage(ft.Column):
    def __init__(self, page: ft.Page):
        self.app_page = page
        super().__init__(
            expand=True,
            scroll=ft.ScrollMode.AUTO,
            spacing=24,
            controls=[
                PageHeader(
                    title="Dialogues",
                    subtitle=(
                        "Variantes, modalité, fermeture extérieure, action d’en-tête "
                        "et contenu scrollable"
                    ),
                ),
                self._build_variants_section(),
                self._build_behaviors_section(),
            ],
        )

    def _build_variants_section(self) -> ft.Control:
        buttons = [
            self._dialog_button(
                "Standard",
                ft.Icons.INFO_OUTLINE_ROUNDED,
                PaperNestDialogVariant.STANDARD,
            ),
            self._dialog_button(
                "Principal",
                ft.Icons.STAR_OUTLINE_ROUNDED,
                PaperNestDialogVariant.PRIMARY,
            ),
            self._dialog_button(
                "Succès",
                ft.Icons.CHECK_CIRCLE_OUTLINE_ROUNDED,
                PaperNestDialogVariant.SUCCESS,
            ),
            self._dialog_button(
                "Avertissement",
                ft.Icons.WARNING_AMBER_ROUNDED,
                PaperNestDialogVariant.WARNING,
            ),
            self._dialog_button(
                "Danger",
                ft.Icons.DELETE_OUTLINE_ROUNDED,
                PaperNestDialogVariant.DANGER,
            ),
        ]
        return self._section(
            "Variantes",
            "Chaque variante modifie l’accent visuel de l’en-tête.",
            ft.Row(controls=buttons, wrap=True, spacing=12, run_spacing=12),
        )

    def _build_behaviors_section(self) -> ft.Control:
        return self._section(
            "Comportements",
            "Cas particuliers à valider avant l’intégration dans les pickers.",
            ft.Row(
                wrap=True,
                spacing=12,
                run_spacing=12,
                controls=[
                    ft.FilledButton(
                        "Titre avec action",
                        icon=ft.Icons.CLOSE_ROUNDED,
                        on_click=lambda _event: self._open_dialog(
                            title="Action dans l’en-tête",
                            icon=ft.Icons.TUNE_ROUNDED,
                            variant=PaperNestDialogVariant.PRIMARY,
                            title_action=True,
                        ),
                    ),
                    ft.FilledButton(
                        "Contenu scrollable",
                        icon=ft.Icons.ARTICLE_OUTLINED,
                        on_click=lambda _event: self._open_scrollable_dialog(),
                    ),
                    ft.FilledButton(
                        "Modal",
                        icon=ft.Icons.LOCK_OUTLINE_ROUNDED,
                        on_click=lambda _event: self._open_dialog(
                            title="Dialogue modal",
                            icon=ft.Icons.LOCK_OUTLINE_ROUNDED,
                            variant=PaperNestDialogVariant.WARNING,
                            modal=True,
                            dismissible=False,
                            message=(
                                "Un clic à l’extérieur ne doit pas fermer ce dialogue. "
                                "Utilisez le bouton Fermer."
                            ),
                        ),
                    ),
                    ft.OutlinedButton(
                        "Fermeture extérieure",
                        icon=ft.Icons.TOUCH_APP_OUTLINED,
                        on_click=lambda _event: self._open_dialog(
                            title="Dialogue non modal",
                            icon=ft.Icons.TOUCH_APP_OUTLINED,
                            variant=PaperNestDialogVariant.STANDARD,
                            modal=False,
                            dismissible=True,
                            message=(
                                "Cliquez à l’extérieur du dialogue pour vérifier "
                                "l’événement de fermeture."
                            ),
                        ),
                    ),
                ],
            ),
        )

    def _dialog_button(
        self,
        label: str,
        icon,
        variant: PaperNestDialogVariant,
    ) -> ft.Control:
        return ft.FilledButton(
            label,
            icon=icon,
            on_click=lambda _event: self._open_dialog(
                title=f"Variante {label.lower()}",
                icon=icon,
                variant=variant,
            ),
        )

    def _open_dialog(
        self,
        *,
        title: str,
        icon,
        variant: PaperNestDialogVariant,
        message: str = "Ce dialogue utilise PaperNestAlertDialog.",
        modal: bool = False,
        dismissible: bool = True,
        title_action: bool = False,
    ) -> None:
        dialog = PaperNestAlertDialog(
            title=title,
            icon=icon,
            variant=variant,
            modal=modal,
            dismissible=dismissible,
            width=560,
            content=ft.Text(message, size=14, color="#4B5563"),
        )
        dialog.actions = [
            ft.TextButton("Annuler", on_click=lambda _event: self._close_dialog(dialog)),
            ft.FilledButton("Fermer", on_click=lambda _event: self._close_dialog(dialog)),
        ]
        if title_action:
            dialog.title_action = ft.IconButton(
                icon=ft.Icons.CLOSE_ROUNDED,
                icon_color="#FFFFFF",
                tooltip="Fermer",
                on_click=lambda _event: self._close_dialog(dialog),
            )
        self._show_dialog(dialog)

    def _open_scrollable_dialog(self) -> None:
        paragraphs = [
            ft.Text(
                f"Section {index} — Ce contenu permet de vérifier le défilement, "
                "la hauteur maximale et le maintien visible des actions.",
                size=14,
                color="#4B5563",
            )
            for index in range(1, 13)
        ]
        dialog = PaperNestAlertDialog(
            title="Contenu long et scrollable",
            icon=ft.Icons.ARTICLE_OUTLINED,
            variant=PaperNestDialogVariant.PRIMARY,
            width=640,
            max_height=620,
            scrollable=True,
            content=ft.Column(tight=True, spacing=14, controls=paragraphs),
        )
        dialog.actions = [
            ft.FilledButton("Fermer", on_click=lambda _event: self._close_dialog(dialog))
        ]
        self._show_dialog(dialog)

    def _show_dialog(self, dialog: PaperNestAlertDialog) -> None:
        self.app_page.overlay.append(dialog)
        dialog.open = True
        self.app_page.update()

    def _close_dialog(self, dialog: PaperNestAlertDialog) -> None:
        dialog.open = False
        self.app_page.update()

    @staticmethod
    def _section(title: str, subtitle: str, content: ft.Control) -> ft.Control:
        return ft.Container(
            padding=24,
            bgcolor="#FFFFFF",
            border=ft.Border.all(1, "#D9DCE3"),
            border_radius=16,
            content=ft.Column(
                tight=True,
                spacing=16,
                controls=[
                    ft.Text(title, size=18, weight=ft.FontWeight.BOLD),
                    ft.Text(subtitle, size=13, color="#6B7280"),
                    content,
                ],
            ),
        )
