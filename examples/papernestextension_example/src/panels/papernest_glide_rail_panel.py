import flet as ft

from papernestextension import PaperNestGlideRail, PaperNestGlideRailDestination


class PaperNestGlideRailPanel(ft.Container):
    COLLAPSED_WIDTH = 76

    def __init__(self, page: ft.Page):
        self.page_ref = page
        self.title = ft.Text("Accueil", size=24, weight=ft.FontWeight.BOLD)
        self.status = ft.Text("Survolez la rail à gauche.")
        labels = [
            "Accueil",
            "Recherche",
            "Documents importants",
            "Corbeille",
            "Administration",
        ]

        def handle_change(event: ft.ControlEvent) -> None:
            index = int(event.data)
            self.title.value = labels[index]
            self.status.value = f"Destination sélectionnée : {labels[index]}"
            page.update()

        rail = PaperNestGlideRail(
            expand=True,
            collapsed_width=self.COLLAPSED_WIDTH,
            expanded_width=290,
            animation_duration=220,
            bgcolor="#17191F",
            color="#B8BCC6",
            selected_color="#FFFFFF",
            selected_bgcolor="#F9A825",
            selected_border_color="#C17900",
            hover_color="#22FFFFFF",
            divider_color="#343842",
            shadow_color="#66000000",
            border_radius=ft.BorderRadius.only(top_right=16, bottom_right=16),
            item_border_radius=12,
            brand_icon=ft.Icons.FOLDER_COPY_ROUNDED,
            brand_title="PaperNest",
            brand_subtitle="Documents personnels",
            destinations=[
                PaperNestGlideRailDestination(
                    label="Accueil",
                    icon=ft.Icons.DASHBOARD_OUTLINED,
                    selected_icon=ft.Icons.DASHBOARD_ROUNDED,
                ),
                PaperNestGlideRailDestination(
                    label="Recherche",
                    icon=ft.Icons.MANAGE_SEARCH_ROUNDED,
                ),
                PaperNestGlideRailDestination(
                    label="Documents importants",
                    icon=ft.Icons.STAR_OUTLINE_ROUNDED,
                    selected_icon=ft.Icons.STAR_ROUNDED,
                ),
                PaperNestGlideRailDestination(
                    label="Corbeille",
                    icon=ft.Icons.DELETE_OUTLINE_ROUNDED,
                    selected_icon=ft.Icons.DELETE_ROUNDED,
                ),
            ],
            secondary_destinations=[
                PaperNestGlideRailDestination(
                    label="Administration",
                    icon=ft.Icons.ADMIN_PANEL_SETTINGS_OUTLINED,
                    selected_icon=ft.Icons.ADMIN_PANEL_SETTINGS_ROUNDED,
                )
            ],
            on_change=handle_change,
        )

        demo_content = ft.Container(
            expand=True,
            margin=ft.Margin.only(left=self.COLLAPSED_WIDTH),
            padding=30,
            bgcolor="#F5F6F8",
            content=ft.Column(
                controls=[
                    self.title,
                    self.status,
                    ft.Container(
                        height=180,
                        border_radius=20,
                        bgcolor="#FFFFFF",
                        padding=24,
                        content=ft.Text(
                            "Cette carte ne doit jamais bouger lorsque la rail se "
                            "déploie. La largeur supplémentaire doit la recouvrir.",
                            size=16,
                        ),
                    ),
                ]
            ),
        )

        super().__init__(
            height=560,
            border=ft.Border.all(1, "#D9DCE3"),
            border_radius=16,
            clip_behavior=ft.ClipBehavior.ANTI_ALIAS,
            content=ft.Stack(
                expand=True,
                controls=[
                    demo_content,
                    ft.Container(left=0, top=0, bottom=0, content=rail),
                ],
            ),
        )
