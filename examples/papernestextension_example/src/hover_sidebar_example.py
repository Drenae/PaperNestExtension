import flet as ft

from papernestextension import (
    PaperNestHoverSidebar,
    PaperNestHoverSidebarDestination,
)


COLLAPSED_WIDTH = 76


def main(page: ft.Page) -> None:
    page.title = "PaperNestHoverSidebar — Exemple"
    page.padding = 0
    page.spacing = 0
    page.bgcolor = "#F5F6F8"

    title = ft.Text("Accueil", size=28, weight=ft.FontWeight.BOLD)
    status = ft.Text("Survolez la barre latérale.")

    labels = [
        "Accueil",
        "Recherche",
        "Documents importants",
        "Corbeille",
        "Administration",
    ]

    def handle_change(event: ft.ControlEvent) -> None:
        index = int(event.data)
        title.value = labels[index]
        status.value = f"Destination sélectionnée : {labels[index]}"
        page.update()

    sidebar = PaperNestHoverSidebar(
        expand=True,
        collapsed_width=COLLAPSED_WIDTH,
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
            PaperNestHoverSidebarDestination(
                label="Accueil",
                icon=ft.Icons.DASHBOARD_OUTLINED,
                selected_icon=ft.Icons.DASHBOARD_ROUNDED,
            ),
            PaperNestHoverSidebarDestination(
                label="Recherche",
                icon=ft.Icons.MANAGE_SEARCH_ROUNDED,
            ),
            PaperNestHoverSidebarDestination(
                label="Documents importants",
                icon=ft.Icons.STAR_OUTLINE_ROUNDED,
                selected_icon=ft.Icons.STAR_ROUNDED,
            ),
            PaperNestHoverSidebarDestination(
                label="Corbeille",
                icon=ft.Icons.DELETE_OUTLINE_ROUNDED,
                selected_icon=ft.Icons.DELETE_ROUNDED,
            ),
        ],
        secondary_destinations=[
            PaperNestHoverSidebarDestination(
                label="Administration",
                icon=ft.Icons.ADMIN_PANEL_SETTINGS_OUTLINED,
                selected_icon=ft.Icons.ADMIN_PANEL_SETTINGS_ROUNDED,
            ),
        ],
        on_change=handle_change,
        on_expand=lambda _event: setattr(
            status, "value", "Sidebar déployée sans déplacer le contenu."
        ),
        on_collapse=lambda _event: setattr(
            status, "value", "Sidebar repliée."
        ),
    )

    content = ft.Container(
        expand=True,
        margin=ft.Margin.only(left=COLLAPSED_WIDTH),
        padding=40,
        content=ft.Column(
            controls=[
                title,
                status,
                ft.Container(
                    height=260,
                    border_radius=20,
                    bgcolor="#FFFFFF",
                    padding=30,
                    content=ft.Text(
                        "Cette carte ne doit jamais bouger lorsque la sidebar "
                        "se déploie. La largeur supplémentaire doit la recouvrir.",
                        size=18,
                    ),
                ),
            ]
        ),
    )

    page.add(
        ft.Stack(
            expand=True,
            controls=[
                content,
                ft.Container(
                    left=0,
                    top=0,
                    bottom=0,
                    content=sidebar,
                ),
            ],
        )
    )


ft.run(main)
