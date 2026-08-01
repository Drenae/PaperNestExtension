import flet as ft

from cards import PageHeader


_COMPONENTS = [
    ("PaperNestTextField", "Champs de saisie enrichis, recherche, états et validation.", ft.Icons.TEXT_FIELDS_ROUNDED),
    ("PaperNestDropdown", "Listes déroulantes personnalisables avec options structurées.", ft.Icons.ARROW_DROP_DOWN_CIRCLE_ROUNDED),
    ("PaperNestColorPicker", "Sélection d'une couleur avec valeur normalisée en #RRGGBB.", ft.Icons.PALETTE_ROUNDED),
    ("PaperNestDatePicker", "Sélection de date avec champ Material et dialogue natif.", ft.Icons.CALENDAR_MONTH_ROUNDED),
    ("PaperNestFilePicker", "Sélection et glisser-déposer de fichiers avec validation.", ft.Icons.UPLOAD_FILE_ROUNDED),
    ("PaperNestIconPicker", "Galerie d'icônes avec sélection temporaire et confirmation.", ft.Icons.EMOJI_SYMBOLS_ROUNDED),
    ("PaperNestGlideRail", "Navigation compacte qui se déploie au survol sans déplacer le contenu.", ft.Icons.VIEW_SIDEBAR_ROUNDED),
]


class HomePage(ft.Column):
    def __init__(self, page: ft.Page):
        super().__init__(
            expand=True,
            scroll=ft.ScrollMode.AUTO,
            spacing=24,
            controls=[
                PageHeader(
                    title="PaperNestExtension",
                    subtitle="Bibliothèque de contrôles dédiée à PaperNest",
                ),
                ft.Text(
                    "Cette application présente les contrôles disponibles et leurs comportements réels. "
                    "Utilisez la navigation à gauche pour ouvrir les démonstrations par famille.",
                    size=15,
                    color="#555B66",
                ),
                ft.ResponsiveRow(
                    spacing=16,
                    run_spacing=16,
                    controls=[self._component_card(*component) for component in _COMPONENTS],
                ),
            ],
        )

    @staticmethod
    def _component_card(title: str, description: str, icon) -> ft.Control:
        return ft.Container(
            col={"sm": 12, "md": 6, "xl": 4},
            padding=20,
            border=ft.Border.all(1, "#D9DCE3"),
            border_radius=16,
            bgcolor="#FFFFFF",
            content=ft.Column(
                tight=True,
                spacing=12,
                controls=[
                    ft.Container(
                        width=44,
                        height=44,
                        alignment=ft.Alignment.CENTER,
                        border_radius=12,
                        bgcolor="#FFF4D6",
                        content=ft.Icon(icon, color="#C17900", size=25),
                    ),
                    ft.Text(title, size=16, weight=ft.FontWeight.BOLD),
                    ft.Text(description, size=13, color="#666C76"),
                ],
            ),
        )
