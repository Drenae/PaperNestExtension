import flet as ft
from papernestextension import PaperNestGlideRail, PaperNestGlideRailDestination

from app.pages import DialogsPage, FormsPage, HomePage, PickersPage


COLLAPSED_WIDTH = 76


class ExampleMainWindow:
    def __init__(self, page: ft.Page):
        self.page = page
        self.selected_index = 0
        self.content = ft.Container(
            expand=True,
            margin=ft.Margin.only(left=COLLAPSED_WIDTH),
            padding=24,
            bgcolor="#F5F6F8",
        )
        self.page_factories = [
            lambda: HomePage(page),
            lambda: FormsPage(page),
            lambda: PickersPage(page),
            lambda: DialogsPage(page),
        ]
        self.rail = self._build_rail()

    def build(self) -> None:
        self.page.title = "PaperNestExtension — Exemples"
        self.page.padding = 0
        self.page.spacing = 0
        self.page.bgcolor = "#F5F6F8"
        self.page.add(
            ft.Stack(
                expand=True,
                controls=[
                    self.content,
                    ft.Container(
                        left=0,
                        top=0,
                        bottom=0,
                        content=self.rail,
                    ),
                ],
            )
        )
        self.navigate_to(0)

    def _build_rail(self) -> PaperNestGlideRail:
        return PaperNestGlideRail(
            expand=True,
            collapsed_width=COLLAPSED_WIDTH,
            expanded_width=280,
            animation_duration=220,
            padding=10,
            bgcolor="#17191F",
            color="#B8BCC6",
            selected_color="#FFFFFF",
            selected_bgcolor="#F9A825",
            selected_border_color="#C17900",
            hover_color="#22FFFFFF",
            hover_scale=1.025,
            divider_color="#343842",
            shadow_color="#66000000",
            border_radius=ft.BorderRadius.only(top_right=16, bottom_right=16),
            item_border_radius=12,
            brand_icon=ft.Icons.EXTENSION_ROUNDED,
            brand_title=ft.Text(
                "PaperNestExtension",
                color="#FFFFFF",
                size=15,
                weight=ft.FontWeight.BOLD,
            ),
            brand_subtitle=ft.Text(
                "Application d'exemple",
                color="#8E94A3",
                size=11,
            ),
            destinations=[
                PaperNestGlideRailDestination(
                    label="Accueil",
                    icon=ft.Icons.HOME_OUTLINED,
                    selected_icon=ft.Icons.HOME_ROUNDED,
                ),
                PaperNestGlideRailDestination(
                    label="Formulaires",
                    icon=ft.Icons.DYNAMIC_FORM_OUTLINED,
                    selected_icon=ft.Icons.DYNAMIC_FORM_ROUNDED,
                ),
                PaperNestGlideRailDestination(
                    label="Pickers",
                    icon=ft.Icons.TOUCH_APP_OUTLINED,
                    selected_icon=ft.Icons.TOUCH_APP_ROUNDED,
                ),
                PaperNestGlideRailDestination(
                    label="Dialogues",
                    icon=ft.Icons.CHAT_BUBBLE_OUTLINE_ROUNDED,
                    selected_icon=ft.Icons.CHAT_BUBBLE_ROUNDED,
                ),
            ],
            selected_index=0,
            on_change=self.handle_navigation,
        )

    def handle_navigation(self, event: ft.ControlEvent) -> None:
        try:
            index = int(event.data)
        except (TypeError, ValueError):
            return
        self.navigate_to(index)

    def navigate_to(self, index: int) -> None:
        if index < 0 or index >= len(self.page_factories):
            return
        self.selected_index = index
        self.rail.selected_index = index
        self.content.content = self.page_factories[index]()
        self.page.update()
