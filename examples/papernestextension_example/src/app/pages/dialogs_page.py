import flet as ft
from papernestextension import PaperNestAlertDialog, PaperNestButton

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
                        "PaperNestAlertDialog piloté entièrement depuis Python, "
                        "sans variant dans l’extension"
                    ),
                ),
                self._build_headers_section(),
                self._build_behaviors_section(),
            ],
        )

    def _build_headers_section(self) -> ft.Control:
        return self._section(
            "En-têtes pilotés depuis Python",
            "Les couleurs et la composition sont définies par chaque appel.",
            ft.Row(
                wrap=True,
                spacing=12,
                run_spacing=12,
                controls=[
                    ft.FilledButton(
                        "Titre seul",
                        on_click=lambda _event: self._open_dialog(
                            title="Dialogue minimal",
                            icon=None,
                        ),
                    ),
                    ft.FilledButton(
                        "Icône et titre",
                        icon=ft.Icons.STAR_OUTLINE_ROUNDED,
                        on_click=lambda _event: self._open_dialog(
                            title="Dialogue principal",
                            icon=ft.Icons.STAR_OUTLINE_ROUNDED,
                            icon_bgcolor=ft.Colors.YELLOW_700,
                            icon_color=ft.Colors.GREY_900,
                        ),
                    ),
                    ft.FilledButton(
                        "Titre et sous-titre",
                        icon=ft.Icons.INFO_OUTLINE_ROUNDED,
                        on_click=lambda _event: self._open_dialog(
                            title="Informations",
                            subtitle="Un sous-titre fourni depuis Python",
                            icon=ft.Icons.INFO_OUTLINE_ROUNDED,
                            icon_bgcolor=ft.Colors.BLUE_700,
                        ),
                    ),
                    ft.FilledButton(
                        "Action d’en-tête",
                        icon=ft.Icons.TUNE_ROUNDED,
                        on_click=lambda _event: self._open_dialog(
                            title="Action dans l’en-tête",
                            subtitle="Le bouton à droite est un contrôle Python",
                            icon=ft.Icons.TUNE_ROUNDED,
                            icon_bgcolor=ft.Colors.PURPLE_700,
                            title_action=True,
                        ),
                    ),
                ],
            ),
        )

    def _build_behaviors_section(self) -> ft.Control:
        return self._section(
            "Comportements natifs conservés",
            "Modalité, fermeture extérieure, hauteur naturelle et défilement.",
            ft.Row(
                wrap=True,
                spacing=12,
                run_spacing=12,
                controls=[
                    ft.FilledButton(
                        "Formulaire naturel",
                        icon=ft.Icons.EDIT_NOTE_ROUNDED,
                        on_click=lambda _event: self._open_form_dialog(),
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
                            subtitle="Le clic extérieur ne doit pas le fermer",
                            icon=ft.Icons.LOCK_OUTLINE_ROUNDED,
                            icon_bgcolor=ft.Colors.ORANGE_700,
                            modal=True,
                            dismissible=False,
                        ),
                    ),
                    ft.OutlinedButton(
                        "Fermeture extérieure",
                        icon=ft.Icons.TOUCH_APP_OUTLINED,
                        on_click=lambda _event: self._open_dialog(
                            title="Dialogue non modal",
                            subtitle="Cliquez à l’extérieur pour le fermer",
                            icon=ft.Icons.TOUCH_APP_OUTLINED,
                            icon_bgcolor=ft.Colors.GREY_700,
                            modal=False,
                            dismissible=True,
                        ),
                    ),
                ],
            ),
        )

    def _dialog_defaults(self) -> dict:
        return {
            "width": 560,
            "bgcolor": ft.Colors.WHITE,
            "header_bgcolor": ft.Colors.GREY_900,
            "header_padding": ft.Padding.symmetric(horizontal=24, vertical=16),
            "header_spacing": 12,
            "icon_size": 20,
            "icon_container_size": 38,
            "icon_border_radius": 12,
            "title_text_style": ft.TextStyle(
                size=18,
                weight=ft.FontWeight.BOLD,
                color=ft.Colors.WHITE,
            ),
            "subtitle_text_style": ft.TextStyle(
                size=12,
                color=ft.Colors.GREY_400,
            ),
            "content_padding": ft.Padding.only(
                left=24,
                right=24,
                top=20,
                bottom=16,
            ),
            "actions_padding": ft.Padding.only(
                left=24,
                right=24,
                top=8,
                bottom=20,
            ),
            "actions_alignment": ft.MainAxisAlignment.END,
            "actions_spacing": 8,
            "shape": ft.RoundedRectangleBorder(radius=20),
            "clip_behavior": ft.ClipBehavior.ANTI_ALIAS,
            "shadow_color": ft.Colors.with_opacity(0.22, ft.Colors.BLACK),
            "barrier_color": ft.Colors.with_opacity(0.48, ft.Colors.BLACK),
        }

    def _open_dialog(
        self,
        *,
        title: str,
        icon,
        subtitle: str | None = None,
        icon_bgcolor=ft.Colors.GREY_700,
        icon_color=ft.Colors.WHITE,
        message: str = "Ce dialogue utilise le nouveau fork de AlertDialog.",
        modal: bool = False,
        dismissible: bool = True,
        title_action: bool = False,
    ) -> None:
        dialog = PaperNestAlertDialog(
            title=title,
            subtitle=subtitle,
            icon=icon,
            icon_bgcolor=icon_bgcolor,
            icon_color=icon_color,
            modal=modal,
            dismissible=dismissible,
            content=ft.Text(message, size=14, color=ft.Colors.GREY_700),
            **self._dialog_defaults(),
        )
        dialog.actions = [
            PaperNestButton(
                content="Annuler",
                color=ft.Colors.GREY_800,
                bgcolor=ft.Colors.GREY_200,
                elevation=0,
                on_click=lambda _event: self._close_dialog(dialog),
            ),
            PaperNestButton(
                content="Fermer",
                color=ft.Colors.GREY_900,
                gradient=ft.LinearGradient(
                    begin=ft.Alignment.CENTER_LEFT,
                    end=ft.Alignment.CENTER_RIGHT,
                    colors=[ft.Colors.YELLOW_700, ft.Colors.YELLOW_800],
                ),
                hover_scale=1.02,
                click_scale=0.97,
                on_click=lambda _event: self._close_dialog(dialog),
            ),
        ]
        if title_action:
            dialog.title_action = ft.IconButton(
                icon=ft.Icons.CLOSE_ROUNDED,
                icon_color=ft.Colors.WHITE,
                tooltip="Fermer",
                on_click=lambda _event: self._close_dialog(dialog),
            )
        self._show_dialog(dialog)

    def _open_form_dialog(self) -> None:
        form = ft.Column(
            tight=True,
            spacing=12,
            controls=[
                ft.TextField(label="Nom", value="PaperNest"),
                ft.TextField(label="Description", multiline=True, min_lines=2),
            ],
        )
        dialog = PaperNestAlertDialog(
            title="Formulaire compact",
            subtitle="Les actions doivent suivre immédiatement le contenu",
            icon=ft.Icons.EDIT_NOTE_ROUNDED,
            icon_bgcolor=ft.Colors.YELLOW_700,
            icon_color=ft.Colors.GREY_900,
            content=form,
            **self._dialog_defaults(),
        )
        dialog.actions = [
            PaperNestButton(
                content="Annuler",
                bgcolor=ft.Colors.GREY_200,
                color=ft.Colors.GREY_800,
                elevation=0,
                on_click=lambda _event: self._close_dialog(dialog),
            ),
            PaperNestButton(
                content="Enregistrer",
                gradient=ft.LinearGradient(
                    colors=[ft.Colors.YELLOW_700, ft.Colors.YELLOW_800],
                ),
                color=ft.Colors.GREY_900,
                on_click=lambda _event: self._close_dialog(dialog),
            ),
        ]
        self._show_dialog(dialog)

    def _open_scrollable_dialog(self) -> None:
        paragraphs = [
            ft.Text(
                f"Section {index} — Vérification du défilement et du maintien "
                "des actions visibles.",
                size=14,
                color=ft.Colors.GREY_700,
            )
            for index in range(1, 16)
        ]
        dialog = PaperNestAlertDialog(
            title="Contenu long et scrollable",
            subtitle="Hauteur maximale définie depuis Python",
            icon=ft.Icons.ARTICLE_OUTLINED,
            icon_bgcolor=ft.Colors.BLUE_700,
            icon_color=ft.Colors.WHITE,
            width=640,
            max_height=620,
            scrollable=True,
            content=ft.Column(tight=True, spacing=14, controls=paragraphs),
            **{
                key: value
                for key, value in self._dialog_defaults().items()
                if key != "width"
            },
        )
        dialog.actions = [
            PaperNestButton(
                content="Fermer",
                bgcolor=ft.Colors.BLUE_700,
                color=ft.Colors.WHITE,
                on_click=lambda _event: self._close_dialog(dialog),
            )
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
            bgcolor=ft.Colors.WHITE,
            border=ft.Border.all(1, ft.Colors.GREY_300),
            border_radius=16,
            content=ft.Column(
                tight=True,
                spacing=16,
                controls=[
                    ft.Text(title, size=18, weight=ft.FontWeight.BOLD),
                    ft.Text(subtitle, size=13, color=ft.Colors.GREY_600),
                    content,
                ],
            ),
        )
