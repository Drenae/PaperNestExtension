import asyncio

import flet as ft

from papernestextension import PaperNestButton


BUTTON_SHAPE = ft.RoundedRectangleBorder(radius=12)


class ActionsPage(ft.Column):
    def __init__(self, page: ft.Page):
        self.app_page = page
        self.loading_button = self._primary(
            "Lancer le chargement",
            icon=ft.Icons.PLAY_ARROW_ROUNDED,
            loading_text="Chargement…",
            on_click=self.start_loading,
        )

        super().__init__(
            expand=True,
            scroll=ft.ScrollMode.AUTO,
            spacing=20,
            controls=[
                ft.Text("Actions", size=28, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "Styles Python, gradients, chargement et animations de PaperNestButton.",
                    color=ft.Colors.GREY_700,
                ),
                self._section(
                    "Styles construits côté Python",
                    [
                        self._primary("Principal", icon=ft.Icons.STAR_ROUNDED),
                        self._secondary("Secondaire"),
                        self._ghost("Fantôme"),
                        self._outline("Contour"),
                        self._success("Succès", icon=ft.Icons.CHECK_ROUNDED),
                        self._danger("Danger", icon=ft.Icons.DELETE_ROUNDED),
                    ],
                ),
                self._section(
                    "Gradients et animations",
                    [
                        PaperNestButton(
                            content="Gradient PaperNest",
                            icon=ft.Icons.AUTO_AWESOME_ROUNDED,
                            color=ft.Colors.GREY_900,
                            bgcolor=ft.Colors.TRANSPARENT,
                            gradient=ft.LinearGradient(
                                colors=["#F9A825", "#FFCA28"],
                            ),
                            hover_gradient=ft.LinearGradient(
                                colors=["#FFB300", "#FFD54F"],
                            ),
                            style=self._style(),
                        ),
                        self._outline(
                            "Icône à droite",
                            trailing_icon=ft.Icons.ARROW_FORWARD_ROUNDED,
                        ),
                    ],
                ),
                self._section(
                    "États",
                    [
                        self.loading_button,
                        self._secondary(
                            "Désactivé",
                            icon=ft.Icons.BLOCK_ROUNDED,
                            disabled=True,
                        ),
                    ],
                ),
            ],
        )

    @staticmethod
    def _style(*, side: ft.BorderSide | None = None) -> ft.ButtonStyle:
        return ft.ButtonStyle(
            shape=BUTTON_SHAPE,
            padding=ft.Padding.symmetric(horizontal=18, vertical=0),
            side=side,
            mouse_cursor={
                ft.ControlState.DISABLED: ft.MouseCursor.BASIC,
                ft.ControlState.DEFAULT: ft.MouseCursor.CLICK,
            },
        )

    @classmethod
    def _primary(cls, text: str, **kwargs) -> PaperNestButton:
        kwargs.setdefault("bgcolor", "#F9A825")
        kwargs.setdefault("color", "#212121")
        kwargs.setdefault("style", cls._style())
        return PaperNestButton(content=text, **kwargs)

    @classmethod
    def _secondary(cls, text: str, **kwargs) -> PaperNestButton:
        kwargs.setdefault("bgcolor", "#E0E0E0")
        kwargs.setdefault("color", "#212121")
        kwargs.setdefault("style", cls._style())
        return PaperNestButton(content=text, **kwargs)

    @classmethod
    def _ghost(cls, text: str, **kwargs) -> PaperNestButton:
        kwargs.setdefault("bgcolor", ft.Colors.TRANSPARENT)
        kwargs.setdefault("color", "#37474F")
        kwargs.setdefault("style", cls._style())
        return PaperNestButton(content=text, **kwargs)

    @classmethod
    def _outline(cls, text: str, **kwargs) -> PaperNestButton:
        kwargs.setdefault("bgcolor", ft.Colors.WHITE)
        kwargs.setdefault("color", "#37474F")
        kwargs.setdefault("style", cls._style(side=ft.BorderSide(1, "#B0BEC5")))
        return PaperNestButton(content=text, **kwargs)

    @classmethod
    def _success(cls, text: str, **kwargs) -> PaperNestButton:
        kwargs.setdefault("bgcolor", "#43A047")
        kwargs.setdefault("color", ft.Colors.WHITE)
        kwargs.setdefault("style", cls._style())
        return PaperNestButton(content=text, **kwargs)

    @classmethod
    def _danger(cls, text: str, **kwargs) -> PaperNestButton:
        kwargs.setdefault("bgcolor", "#E53935")
        kwargs.setdefault("color", ft.Colors.WHITE)
        kwargs.setdefault("style", cls._style())
        return PaperNestButton(content=text, **kwargs)

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

    def start_loading(self, _event=None) -> None:
        self.loading_button.set_loading(True, update=False)
        self.app_page.update()
        self.app_page.run_task(self._stop_loading)

    async def _stop_loading(self) -> None:
        await asyncio.sleep(1.5)
        self.loading_button.set_loading(False, update=False)
        self.app_page.update()
