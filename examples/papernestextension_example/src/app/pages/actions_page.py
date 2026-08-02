import flet as ft

from papernestextension import PaperNestButton, PaperNestButtonVariant


class ActionsPage(ft.Column):
    def __init__(self, page: ft.Page):
        self.app_page = page
        self.loading_button = PaperNestButton(
            content="Lancer le chargement",
            icon=ft.Icons.PLAY_ARROW_ROUNDED,
            loading_text="Chargement…",
            on_click=self.toggle_loading,
        )

        super().__init__(
            expand=True,
            scroll=ft.ScrollMode.AUTO,
            spacing=20,
            controls=[
                ft.Text("Actions", size=28, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "Variantes, gradients, chargement et animations de PaperNestButton.",
                    color=ft.Colors.GREY_700,
                ),
                self._section(
                    "Variantes",
                    [
                        PaperNestButton(content="Principal", icon=ft.Icons.STAR_ROUNDED),
                        PaperNestButton(
                            content="Secondaire",
                            variant=PaperNestButtonVariant.SECONDARY,
                        ),
                        PaperNestButton(
                            content="Fantôme",
                            variant=PaperNestButtonVariant.GHOST,
                        ),
                        PaperNestButton(
                            content="Contour",
                            variant=PaperNestButtonVariant.OUTLINE,
                        ),
                        PaperNestButton(
                            content="Succès",
                            icon=ft.Icons.CHECK_ROUNDED,
                            variant=PaperNestButtonVariant.SUCCESS,
                        ),
                        PaperNestButton(
                            content="Danger",
                            icon=ft.Icons.DELETE_ROUNDED,
                            variant=PaperNestButtonVariant.DANGER,
                        ),
                    ],
                ),
                self._section(
                    "Gradients et animations",
                    [
                        PaperNestButton(
                            content="Gradient PaperNest",
                            icon=ft.Icons.AUTO_AWESOME_ROUNDED,
                            gradient=ft.LinearGradient(
                                colors=["#F9A825", "#FFCA28"],
                            ),
                            hover_gradient=ft.LinearGradient(
                                colors=["#FFB300", "#FFD54F"],
                            ),
                            pressed_gradient=ft.LinearGradient(
                                colors=["#C17900", "#F9A825"],
                            ),
                        ),
                        PaperNestButton(
                            content="Icône à droite",
                            trailing_icon=ft.Icons.ARROW_FORWARD_ROUNDED,
                            variant=PaperNestButtonVariant.OUTLINE,
                        ),
                    ],
                ),
                self._section(
                    "États",
                    [
                        self.loading_button,
                        PaperNestButton(
                            content="Désactivé",
                            icon=ft.Icons.BLOCK_ROUNDED,
                            disabled=True,
                        ),
                    ],
                ),
            ],
        )

    @staticmethod
    def _section(title: str, buttons: list[ft.Control]) -> ft.Container:
        return ft.Container(
            padding=20,
            border_radius=16,
            bgcolor=ft.Colors.WHITE,
            border=ft.Border.all(1, ft.Colors.GREY_300),
            content=ft.Column(
                spacing=16,
                controls=[
                    ft.Text(title, size=18, weight=ft.FontWeight.BOLD),
                    ft.Row(
                        wrap=True,
                        spacing=12,
                        run_spacing=12,
                        controls=buttons,
                    ),
                ],
            ),
        )

    def toggle_loading(self, _event=None) -> None:
        self.loading_button.set_loading(True, update=False)
        self.app_page.update()
