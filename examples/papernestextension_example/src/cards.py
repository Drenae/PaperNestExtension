from typing import Union

import flet as ft

class PageHeader(ft.Container):
    def __init__(self, title: str, subtitle: Union[str, ft.Control, None] = None, **kwargs):
        leading = []
        text_controls = [ft.Text(title, size=28, weight=ft.FontWeight.BOLD, color=ft.Colors.YELLOW_800)]
        if subtitle: text_controls.append(subtitle if isinstance(subtitle, ft.Control) else ft.Text(subtitle, size=14, color=ft.Colors.WHITE_70))
        leading.append(ft.Column(spacing=2, controls=text_controls))

        super().__init__(
            padding=20,
            bgcolor=ft.Colors.GREY_900,
            border_radius=12,
            content=ft.Row(
                controls=[ft.Row(spacing=12, controls=leading)],
                vertical_alignment=ft.CrossAxisAlignment.CENTER,
            ),
            **kwargs,
        )

class AppSection(ft.Container):
    def __init__(self, title: str, content: ft.Control, icon=None, **kwargs):
        title_controls = []
        if icon is not None: title_controls.append(ft.Icon(icon, color=ft.Colors.YELLOW_700, size=22))
        title_controls.append(ft.Text(title, color=ft.Colors.WHITE, size=20, weight=ft.FontWeight.BOLD))


        super().__init__(
            border_radius=12,
            border=ft.Border.all(1, ft.Colors.GREY_200),
            bgcolor=ft.Colors.WHITE,
            clip_behavior=ft.ClipBehavior.ANTI_ALIAS,
            shadow=ft.BoxShadow(
                blur_radius=16,
                spread_radius=0,
                color=ft.Colors.with_opacity(0.08, ft.Colors.BLACK),
                offset=ft.Offset(0, 4)
            ),
            content=ft.Column(
                spacing=0,
                controls=[
                    ft.Container(
                        bgcolor=ft.Colors.GREY_900,
                        padding=ft.Padding.symmetric(horizontal=16, vertical=12),
                        content=ft.Row(controls=[ft.Row(spacing=8, controls=title_controls)])
                    ),
                    ft.Container(padding=25, content=content, expand=True, bgcolor=ft.Colors.WHITE)
                ]
            ),
            **kwargs,
        )