import flet as ft

from app.main_window import ExampleMainWindow


def main(page: ft.Page) -> None:
    ExampleMainWindow(page).build()


ft.run(main)
