import flet as ft
from cards import PageHeader
from panels.papernest_colorpicker_panel import PaperNestColorPickerPanel
from panels.papernest_datepicker_panel import PaperNestDatePickerPanel
from panels.papernest_dropdown_panel import PaperNestDropdownPanel
from panels.papernest_filepicker_panel import PaperNestFilePickerPanel
from panels.papernest_textfield_panel import PaperNestTextFieldPanel
from papernestextension import (
    PaperNestGlideRail,
    PaperNestGlideRailDestination,
    PaperNestIconPicker,
    PaperNestIconPickerOption,
)


GLIDE_RAIL_COLLAPSED_WIDTH = 76


def build_icon_picker_example(page: ft.Page) -> ft.Control:
    selected_value = ft.Text("Valeur : FOLDER_ROUNDED")
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
        selected_value.value = f"Valeur : {event.data}"
        page.update()

    picker = PaperNestIconPicker(
        width=520,
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

    return ft.Container(
        padding=24,
        border=ft.Border.all(1, "#D9DCE3"),
        border_radius=16,
        content=ft.Column(
            tight=True,
            spacing=16,
            controls=[picker, selected_value],
        ),
    )


def build_glide_rail_example(page: ft.Page) -> ft.Control:
    title = ft.Text("Accueil", size=24, weight=ft.FontWeight.BOLD)
    status = ft.Text("Survolez la rail à gauche.")
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

    rail = PaperNestGlideRail(
        expand=True,
        collapsed_width=GLIDE_RAIL_COLLAPSED_WIDTH,
        expanded_width=290,
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
        brand_icon=ft.Icons.FOLDER_COPY_ROUNDED,
        brand_title=ft.Text(
            "PaperNest",
            color="#FFFFFF",
            size=16,
            weight=ft.FontWeight.BOLD,
        ),
        brand_subtitle=ft.Text(
            "Documents personnels",
            color="#8E94A3",
            size=11,
        ),
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

    content = ft.Container(
        expand=True,
        margin=ft.Margin.only(left=GLIDE_RAIL_COLLAPSED_WIDTH),
        padding=30,
        bgcolor="#F5F6F8",
        content=ft.Column(
            controls=[
                title,
                status,
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

    return ft.Container(
        height=560,
        border=ft.Border.all(1, "#D9DCE3"),
        border_radius=16,
        clip_behavior=ft.ClipBehavior.ANTI_ALIAS,
        content=ft.Stack(
            expand=True,
            controls=[
                content,
                ft.Container(left=0, top=0, bottom=0, content=rail),
            ],
        ),
    )


def main(page: ft.Page) -> None:
    page.title = "PaperNestExtension — Exemples"
    page.padding = 15
    page.scroll = ft.ScrollMode.AUTO

    page.add(
        ft.Column(
            spacing=24,
            controls=[
                PageHeader(
                    title="PaperNestExtension",
                    subtitle="Exemples de tous les contrôles disponibles",
                ),
                ft.Row(
                    vertical_alignment=ft.CrossAxisAlignment.START,
                    spacing=24,
                    controls=[
                        PaperNestTextFieldPanel(page),
                        PaperNestDropdownPanel(page),
                    ],
                ),
                ft.Row(
                    spacing=24,
                    vertical_alignment=ft.CrossAxisAlignment.START,
                    controls=[
                        ft.Column(
                            spacing=24,
                            expand=1,
                            controls=[
                                PaperNestDatePickerPanel(page),
                                PaperNestColorPickerPanel(page),
                            ],
                        ),
                        PaperNestFilePickerPanel(page),
                    ],
                ),
                PageHeader(
                    title="PaperNestIconPicker",
                    subtitle="Sélecteur d'icône avec galerie et validation explicite",
                ),
                build_icon_picker_example(page),
                PageHeader(
                    title="PaperNestGlideRail",
                    subtitle="Rail de navigation compacte qui glisse au survol",
                ),
                build_glide_rail_example(page),
            ],
        )
    )


ft.run(main)
