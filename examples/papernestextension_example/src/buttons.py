from __future__ import annotations

from typing import Optional, Union

import flet as ft

ButtonContent = Union[str, ft.Control]


class AppButton(ft.Button):
    def __init__(
        self,
        text: ButtonContent | None = None,
        on_click=None,
        icon=None,
        bgcolor=ft.Colors.YELLOW_700,
        color=ft.Colors.GREY_900,
        width: Optional[float] = None,
        expand: bool = False,
        disabled: bool = False,
        loading: bool = False,
        compact: bool = False,
        tooltip: str = "",
        **kwargs,
    ):
        if text is None and "content" in kwargs: text = kwargs.pop("content")
        if text is None: text = ""

        self._label = text
        self._source_icon = icon
        self._loading = loading
        self._compact = compact

        content = (text if isinstance(text, ft.Control) else ft.Text(text, size=13 if compact else 14, weight=ft.FontWeight.W_600, max_lines=1))
        style = kwargs.pop("style", ft.ButtonStyle(shape=ft.RoundedRectangleBorder(radius=10), padding=ft.Padding.symmetric(horizontal=(12 if compact else 16), vertical=0)))

        super().__init__(
            content=content,
            icon=None if loading else icon,
            on_click=on_click,
            bgcolor=bgcolor,
            color=color,
            width=width,
            height=(40 if compact else 44),
            expand=expand,
            disabled=disabled or loading,
            tooltip=tooltip,
            style=style,
            **kwargs,
        )

        if loading:
            self.content = ft.Row(spacing=8, alignment=ft.MainAxisAlignment.CENTER, controls=[ft.ProgressRing(width=16, height=16, stroke_width=2, color=color), content])


class PrimaryButton(AppButton):
    def __init__(self, text: ButtonContent, **kwargs):
        kwargs.setdefault("bgcolor", ft.Colors.YELLOW_700)
        kwargs.setdefault("color", ft.Colors.GREY_900)
        super().__init__(text=text, **kwargs)


class SecondaryButton(AppButton):
    def __init__(self, text: ButtonContent, **kwargs):
        kwargs.setdefault("bgcolor", ft.Colors.GREY_300)
        kwargs.setdefault("color", ft.Colors.GREY_900)
        super().__init__(text=text, **kwargs)


class SuccessButton(AppButton):
    def __init__(self, text: ButtonContent, **kwargs):
        kwargs.setdefault("bgcolor", ft.Colors.GREEN_700)
        kwargs.setdefault("color", ft.Colors.WHITE)
        super().__init__(text=text, **kwargs)


class DangerButton(AppButton):
    def __init__(self, text: ButtonContent, **kwargs):
        kwargs.setdefault("bgcolor", ft.Colors.RED_700)
        kwargs.setdefault("color", ft.Colors.WHITE)
        super().__init__(text=text, **kwargs)


class GhostButton(AppButton):
    def __init__(self, text: ButtonContent, **kwargs):
        kwargs.setdefault("bgcolor", ft.Colors.TRANSPARENT)
        kwargs.setdefault("color", ft.Colors.GREY_900)
        super().__init__(text=text, **kwargs)


class OutlineButton(AppButton):
    def __init__(self, text: ButtonContent, **kwargs):
        kwargs.setdefault("bgcolor", ft.Colors.WHITE)
        kwargs.setdefault("color", ft.Colors.GREY_900)
        kwargs.setdefault(
            "style",
            ft.ButtonStyle(
                shape=ft.RoundedRectangleBorder(radius=10),
                padding=ft.Padding.symmetric(horizontal=16, vertical=0),
                side=ft.BorderSide(1, ft.Colors.GREY_400),
            ),
        )
        super().__init__(text=text, **kwargs)
