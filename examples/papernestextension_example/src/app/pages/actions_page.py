import asyncio

import flet as ft

from papernestextension import PaperNestButton, PaperNestButtonStyle


BUTTON_SHAPE = ft.RoundedRectangleBorder(radius=12)
BUTTON_PADDING = ft.Padding.symmetric(horizontal=18, vertical=0)
BUTTON_CURSOR = {
    ft.ControlState.DISABLED: ft.MouseCursor.BASIC,
    ft.ControlState.DEFAULT: ft.MouseCursor.CLICK,
}


class ActionsPage(ft.Column):
    def __init__(self, page: ft.Page):
        self.app_page = page
        self.loading_button = PaperNestButton(
            content="Lancer le chargement",
            icon=ft.Icons.PLAY_ARROW_ROUNDED,
            color=ft.Colors.GREY_900,
            bgcolor=ft.Colors.AMBER_800,
            style=self._style(),
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
                    "PaperNestButton conserve le bouton Material natif et ajoute "
                    "les gradients par état, le chargement et les animations.",
                    color=ft.Colors.GREY_700,
                ),
                self._section(
                    "Base native et bgcolor",
                    [
                        PaperNestButton(content="Bouton natif"),
                        PaperNestButton(
                            content="Fond uni",
                            icon=ft.Icons.COLOR_LENS_ROUNDED,
                            color=ft.Colors.WHITE,
                            bgcolor=ft.Colors.BLUE_700,
                            style=self._style(),
                        ),
                        PaperNestButton(
                            content="Sans icône",
                            color=ft.Colors.GREY_900,
                            bgcolor=ft.Colors.GREY_300,
                            style=self._style(),
                        ),
                    ],
                ),
                self._section(
                    "Gradient normal",
                    [
                        PaperNestButton(
                            content="Gradient direct",
                            icon=ft.Icons.AUTO_AWESOME_ROUNDED,
                            color=ft.Colors.GREY_900,
                            bgcolor=ft.Colors.AMBER_800,
                            gradient=ft.LinearGradient(
                                begin=ft.Alignment.CENTER_LEFT,
                                end=ft.Alignment.CENTER_RIGHT,
                                colors=["#F9A825", "#FFD54F"],
                            ),
                            style=self._style(),
                        ),
                        PaperNestButton(
                            content="Gradient dans le style",
                            icon=ft.Icons.FLARE_ROUNDED,
                            color=ft.Colors.WHITE,
                            bgcolor=ft.Colors.PURPLE_700,
                            style=self._style(
                                gradient=ft.RadialGradient(
                                    colors=["#7E57C2", "#4527A0"],
                                ),
                            ),
                        ),
                    ],
                ),
                self._section(
                    "Gradients utiles pour Button",
                    [
                        PaperNestButton(
                            content="Survole-moi",
                            icon=ft.Icons.TOUCH_APP_ROUNDED,
                            color=ft.Colors.WHITE,
                            bgcolor=ft.Colors.BLUE_700,
                            style=self._style(
                                gradient={
                                    ft.ControlState.DEFAULT: ft.LinearGradient(
                                        colors=["#1565C0", "#42A5F5"],
                                    ),
                                    ft.ControlState.HOVERED: ft.LinearGradient(
                                        colors=["#00838F", "#26C6DA"],
                                    ),
                                },
                            ),
                        ),
                        PaperNestButton(
                            content="Gradient désactivé",
                            icon=ft.Icons.BLOCK_ROUNDED,
                            color=ft.Colors.WHITE,
                            bgcolor=ft.Colors.GREY_600,
                            disabled=True,
                            style=self._style(
                                gradient={
                                    ft.ControlState.DEFAULT: ft.LinearGradient(
                                        colors=["#43A047", "#66BB6A"],
                                    ),
                                    ft.ControlState.DISABLED: ft.LinearGradient(
                                        colors=["#757575", "#BDBDBD"],
                                    ),
                                },
                            ),
                        ),
                    ],
                ),
                self._section(
                    "Animations",
                    [
                        PaperNestButton(
                            content="Animation hover",
                            icon=ft.Icons.OPEN_WITH_ROUNDED,
                            color=ft.Colors.GREY_900,
                            bgcolor=ft.Colors.AMBER_800,
                            style=self._style(),
                            hover_scale=1.04,
                            hover_offset_y=-2,
                            animation_duration=180,
                        ),
                        PaperNestButton(
                            content="Animation clic rapide",
                            icon=ft.Icons.ADS_CLICK_ROUNDED,
                            color=ft.Colors.WHITE,
                            bgcolor=ft.Colors.RED_600,
                            style=self._style(),
                            click_scale=0.94,
                            click_offset_y=1,
                            animation_duration=120,
                        ),
                        PaperNestButton(
                            content="Hover + clic",
                            icon=ft.Icons.BOLT_ROUNDED,
                            color=ft.Colors.WHITE,
                            bgcolor=ft.Colors.GREEN_700,
                            style=self._style(
                                gradient={
                                    ft.ControlState.DEFAULT: ft.LinearGradient(
                                        colors=["#2E7D32", "#66BB6A"],
                                    ),
                                    ft.ControlState.HOVERED: ft.LinearGradient(
                                        colors=["#00695C", "#26A69A"],
                                    ),
                                },
                            ),
                            hover_scale=1.04,
                            hover_offset_y=-2,
                            click_scale=0.96,
                            animation_duration=160,
                        ),
                    ],
                ),
                self._section(
                    "Chargement",
                    [
                        self.loading_button,
                        PaperNestButton(
                            content="Chargement sans texte",
                            icon=ft.Icons.CLOUD_UPLOAD_ROUNDED,
                            color=ft.Colors.WHITE,
                            bgcolor=ft.Colors.INDIGO_600,
                            style=self._style(),
                            loading=True,
                        ),
                    ],
                ),
            ],
        )

    @staticmethod
    def _style(
        *,
        gradient=None,
        side: ft.BorderSide | None = None,
    ) -> PaperNestButtonStyle:
        return PaperNestButtonStyle(
            gradient=gradient,
            shape=BUTTON_SHAPE,
            padding=BUTTON_PADDING,
            side=side,
            mouse_cursor=BUTTON_CURSOR,
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

    def start_loading(self, _event=None) -> None:
        self.loading_button.set_loading(True, update=False)
        self.app_page.update()
        self.app_page.run_task(self._stop_loading)

    async def _stop_loading(self) -> None:
        await asyncio.sleep(1.5)
        self.loading_button.set_loading(False, update=False)
        self.app_page.update()
