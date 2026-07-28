from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Optional

from flet.controls.adaptive_control import AdaptiveControl
from flet.controls.base_control import control
from flet.controls.control import Control
from flet.controls.control_event import (
    ControlEventHandler,
    Event,
    EventHandler,
)
from flet.controls.exceptions import FletUnsupportedPlatformException
from flet.controls.layout_control import LayoutControl
from flet.controls.types import ColorValue, IconDataOrControl, Number

__all__ = [
    "PaperNestFilePicker",
    "PaperNestFilePickerDropEvent",
    "PaperNestFilePickerFile",
    "PaperNestFilePickerFileEvent",
    "PaperNestFilePickerFilesChangedEvent",
    "PaperNestFilePickerFileType",
    "PaperNestFilePickerState",
    "PaperNestFilePickerValidationEvent",
    "PaperNestFilePickerValidationReason",
    "PaperNestFilePickerUploadEvent",
    "PaperNestFilePickerUploadFile",
]


class PaperNestFilePickerState(Enum):
    """État visuel affiché par :class:`PaperNestFilePicker`."""

    NORMAL = "normal"
    HOVER = "hover"
    DRAG_OVER = "drag_over"
    SUCCESS = "success"
    ERROR = "error"
    DISABLED = "disabled"


class PaperNestFilePickerValidationReason(Enum):
    """Raison d'un refus lors de la validation d'un fichier."""

    INVALID_EXTENSION = "invalid_extension"
    FILE_TOO_LARGE = "file_too_large"
    MAX_FILES_REACHED = "max_files_reached"


class PaperNestFilePickerFileType(Enum):
    """Types de fichiers acceptés par :class:`PaperNestFilePicker`."""

    ANY = "any"
    MEDIA = "media"
    IMAGE = "image"
    VIDEO = "video"
    AUDIO = "audio"
    CUSTOM = "custom"


@dataclass
class PaperNestFilePickerUploadFile:
    """Descripteur d'un fichier à envoyer."""

    upload_url: str
    method: str = "PUT"
    id: Optional[int] = None
    name: Optional[str] = None


@dataclass
class PaperNestFilePickerFile:
    """Métadonnées d'un fichier sélectionné ou déposé."""

    id: int
    name: str
    size: int
    path: Optional[str] = None
    bytes: Optional[bytes] = None


@dataclass
class PaperNestFilePickerUploadEvent(Event["PaperNestFilePicker"]):
    """Progression d'envoi d'un fichier."""

    file_name: str
    progress: Optional[float] = None
    error: Optional[str] = None


@dataclass
class PaperNestFilePickerDropEvent(Event["PaperNestFilePicker"]):
    """Événement envoyé lorsque des fichiers sont déposés dans la zone."""

    files: list[dict[str, Any]] = field(default_factory=list)

    @property
    def selected_files(self) -> list[PaperNestFilePickerFile]:
        """Retourne les fichiers déposés sous forme d'objets typés."""

        return PaperNestFilePicker._files_from_data(self.files)


@dataclass
class PaperNestFilePickerFilesChangedEvent(Event["PaperNestFilePicker"]):
    """Événement envoyé après toute modification de la sélection."""

    files: list[dict[str, Any]] = field(default_factory=list)

    @property
    def selected_files(self) -> list[PaperNestFilePickerFile]:
        """Retourne la sélection complète sous forme d'objets typés."""

        return PaperNestFilePicker._files_from_data(self.files)


@dataclass
class PaperNestFilePickerFileEvent(Event["PaperNestFilePicker"]):
    """Événement envoyé lorsqu'un fichier est ajouté ou supprimé."""

    file: dict[str, Any] = field(default_factory=dict)

    @property
    def selected_file(self) -> PaperNestFilePickerFile:
        """Retourne le fichier concerné sous forme d'objet typé."""

        return PaperNestFilePickerFile(
            **PaperNestFilePicker._normalize_file_data(self.file)
        )


@dataclass
class PaperNestFilePickerValidationEvent(Event["PaperNestFilePicker"]):
    """Événement envoyé lorsqu'un fichier est refusé par une contrainte."""

    file: dict[str, Any] = field(default_factory=dict)
    reason: str = ""
    message: str = ""
    limit: Optional[Any] = None

    @property
    def selected_file(self) -> PaperNestFilePickerFile:
        """Retourne le fichier refusé sous forme d'objet typé."""

        return PaperNestFilePickerFile(
            **PaperNestFilePicker._normalize_file_data(self.file)
        )

    @property
    def validation_reason(self) -> PaperNestFilePickerValidationReason:
        """Retourne la raison sous forme d'énumération."""

        return PaperNestFilePickerValidationReason(self.reason)


@control("PaperNestFilePicker")
class PaperNestFilePicker(LayoutControl, AdaptiveControl):
    """
    Sélecteur PaperNest réunissant explorateur natif, dépôt et sélection interne.

    Les fichiers choisis et déposés sont fusionnés dans une même sélection. Le
    contrôle peut afficher cette sélection, supprimer un fichier et notifier
    l'application sans qu'elle maintienne une seconde liste en parallèle.
    """

    content: Optional[Control] = None
    """Contenu personnalisé de la zone. Une zone PaperNest est créée si absent."""

    drag_and_drop: bool = True
    """Active ou désactive le dépôt de fichiers sur la zone."""

    allowed_extensions: list[str] = field(default_factory=list)
    """Extensions autorisées, sans point (`pdf`, `png`, ...)."""

    allow_multiple: bool = True
    """Autorise la sélection de plusieurs fichiers depuis l'explorateur."""

    dialog_title: Optional[str] = None
    """Titre de l'explorateur ouvert par un clic sur la zone."""

    file_type: PaperNestFilePickerFileType = PaperNestFilePickerFileType.ANY
    """Type de fichier utilisé lors d'un clic sur la zone."""

    with_data: bool = False
    """Charge les octets des fichiers sélectionnés lorsque nécessaire."""

    show_file_list: bool = True
    """Affiche la liste intégrée sous la zone de dépôt."""

    show_file_size: bool = True
    """Affiche la taille de chaque fichier dans la liste intégrée."""

    empty_title: str = "Déposez vos fichiers ici"
    """Titre de la zone PaperNest lorsqu'aucun contenu personnalisé n'est fourni."""

    empty_subtitle: str = "ou cliquez pour sélectionner"
    """Sous-titre historique de la zone PaperNest par défaut."""

    drop_text: Optional[str] = None
    """Texte principal de la zone. Prioritaire sur :attr:`empty_title`."""

    drop_subtitle: Optional[str] = None
    """Sous-titre de la zone. Prioritaire sur :attr:`empty_subtitle`."""

    icon: Optional[IconDataOrControl] = None
    """Icône principale de la zone. Une icône d'envoi est utilisée par défaut."""

    icon_color: Optional[ColorValue] = None
    """Couleur de l'icône principale."""

    icon_size: Number = 36
    """Taille de l'icône principale."""

    file_icon_color: Optional[ColorValue] = None
    """Couleur commune des icônes de fichiers, prioritaire sur les couleurs automatiques."""

    file_icon_size: Number = 20
    """Taille des icônes affichées dans la liste de fichiers."""

    use_file_type_colors: bool = False
    """Utilise des couleurs distinctes pour les PDF, images et autres fichiers."""

    click_to_pick: bool = True
    """Ouvre l'explorateur lors d'un clic sur la zone."""

    max_file_size: Optional[int | str] = None
    """Taille maximale par fichier, en octets ou sous forme ``"10 MB"``."""

    max_files: Optional[int] = None
    """Nombre maximal de fichiers conservés dans la sélection."""

    show_constraints: bool = False
    """Affiche sous la zone les extensions, la taille et le nombre autorisés."""

    state: PaperNestFilePickerState = PaperNestFilePickerState.NORMAL
    """État visuel demandé. Le survol, le dépôt et la désactivation restent prioritaires."""

    hover_border_color: Optional[ColorValue] = None
    """Couleur de bordure au survol de la zone."""

    hover_background_color: Optional[ColorValue] = None
    """Couleur de fond au survol de la zone."""

    drag_border_color: Optional[ColorValue] = None
    """Couleur de bordure pendant un glisser-déposer."""

    drag_background_color: Optional[ColorValue] = None
    """Couleur de fond pendant un glisser-déposer."""

    success_border_color: Optional[ColorValue] = None
    """Couleur de bordure de l'état de succès."""

    success_background_color: Optional[ColorValue] = None
    """Couleur de fond de l'état de succès."""

    error_border_color: Optional[ColorValue] = None
    """Couleur de bordure de l'état d'erreur."""

    error_background_color: Optional[ColorValue] = None
    """Couleur de fond de l'état d'erreur."""

    disabled_border_color: Optional[ColorValue] = None
    """Couleur de bordure lorsque le contrôle est désactivé."""

    disabled_background_color: Optional[ColorValue] = None
    """Couleur de fond lorsque le contrôle est désactivé."""

    on_dropped: Optional[EventHandler[PaperNestFilePickerDropEvent]] = None
    """Appelé lorsque des fichiers valides sont déposés."""

    on_files_changed: Optional[
        EventHandler[PaperNestFilePickerFilesChangedEvent]
    ] = None
    """Appelé après ajout, suppression ou effacement de la sélection."""

    on_file_added: Optional[EventHandler[PaperNestFilePickerFileEvent]] = None
    """Appelé pour chaque nouveau fichier ajouté à la sélection."""

    on_file_removed: Optional[EventHandler[PaperNestFilePickerFileEvent]] = None
    """Appelé lorsqu'un fichier est retiré de la sélection."""

    on_duplicate_file: Optional[EventHandler[PaperNestFilePickerFileEvent]] = None
    """Appelé lorsqu'un fichier déjà présent est sélectionné ou déposé."""

    on_validation_error: Optional[
        EventHandler[PaperNestFilePickerValidationEvent]
    ] = None
    """Appelé pour chaque fichier refusé, quelle qu'en soit la raison."""

    on_invalid_extension: Optional[
        EventHandler[PaperNestFilePickerValidationEvent]
    ] = None
    """Appelé lorsqu'une extension n'est pas autorisée."""

    on_file_too_large: Optional[
        EventHandler[PaperNestFilePickerValidationEvent]
    ] = None
    """Appelé lorsqu'un fichier dépasse :attr:`max_file_size`."""

    on_max_files_reached: Optional[
        EventHandler[PaperNestFilePickerValidationEvent]
    ] = None
    """Appelé lorsque :attr:`max_files` empêche un nouvel ajout."""

    on_entered: Optional[ControlEventHandler["PaperNestFilePicker"]] = None
    """Appelé lorsqu'un glisser-déposer entre dans la zone."""

    on_exited: Optional[ControlEventHandler["PaperNestFilePicker"]] = None
    """Appelé lorsqu'un glisser-déposer quitte la zone."""

    on_upload: Optional[EventHandler[PaperNestFilePickerUploadEvent]] = None
    """Appelé pendant l'envoi d'un fichier."""

    async def get_files(self) -> list[PaperNestFilePickerFile]:
        """Retourne la sélection actuellement maintenue par le contrôle."""

        files = await self._invoke_method("get_files", {})
        return self._files_from_data(files)

    async def remove_file(self, file_id: int) -> bool:
        """Supprime un fichier de la sélection grâce à son identifiant courant."""

        return bool(await self._invoke_method("remove_file", {"file_id": file_id}))

    async def clear_files(self) -> None:
        """Vide entièrement la sélection."""

        await self._invoke_method("clear_files", {})

    async def upload(self, files: list[PaperNestFilePickerUploadFile]) -> None:
        await self._invoke_method("upload", {"files": files})

    async def get_directory_path(
        self,
        dialog_title: Optional[str] = None,
        initial_directory: Optional[str] = None,
    ) -> Optional[str]:
        if self.page.web:
            raise FletUnsupportedPlatformException(
                "get_directory_path is not supported in web mode"
            )

        return await self._invoke_method(
            "get_directory_path",
            {
                "dialog_title": dialog_title,
                "initial_directory": initial_directory,
            },
            timeout=3600,
        )

    async def save_file(
        self,
        dialog_title: Optional[str] = None,
        file_name: Optional[str] = None,
        initial_directory: Optional[str] = None,
        file_type: PaperNestFilePickerFileType = PaperNestFilePickerFileType.ANY,
        allowed_extensions: Optional[list[str]] = None,
        src_bytes: Optional[bytes] = None,
    ) -> Optional[str]:
        if (self.page.web or self.page.platform.is_mobile()) and not src_bytes:
            raise ValueError(
                '"src_bytes" is required when saving a file in web mode, '
                "or on mobile (Android & iOS)."
            )
        if self.page.web and not file_name:
            raise ValueError('"file_name" is required when saving a file in web mode.')

        return await self._invoke_method(
            "save_file",
            {
                "dialog_title": dialog_title,
                "file_name": file_name,
                "initial_directory": initial_directory,
                "file_type": file_type,
                "allowed_extensions": allowed_extensions,
                "src_bytes": src_bytes,
            },
            timeout=3600,
        )

    async def pick_files(
        self,
        dialog_title: Optional[str] = None,
        initial_directory: Optional[str] = None,
        file_type: PaperNestFilePickerFileType = PaperNestFilePickerFileType.ANY,
        allowed_extensions: Optional[list[str]] = None,
        allow_multiple: bool = False,
        with_data: bool = False,
    ) -> list[PaperNestFilePickerFile]:
        """Ouvre l'explorateur et ajoute les résultats à la sélection interne."""

        files = await self._invoke_method(
            "pick_files",
            {
                "dialog_title": dialog_title,
                "initial_directory": initial_directory,
                "file_type": file_type,
                "allowed_extensions": allowed_extensions,
                "allow_multiple": allow_multiple,
                "with_data": with_data,
            },
            timeout=3600,
        )
        return self._files_from_data(files)

    @staticmethod
    def _files_from_data(files: list[dict[str, Any]]) -> list[PaperNestFilePickerFile]:
        return [
            PaperNestFilePickerFile(**PaperNestFilePicker._normalize_file_data(file))
            for file in files
        ]

    @staticmethod
    def _normalize_file_data(file: dict[str, Any]) -> dict[str, Any]:
        normalized = dict(file)
        value = normalized.get("bytes")
        if isinstance(value, list):
            normalized["bytes"] = bytes(value)
        return normalized
