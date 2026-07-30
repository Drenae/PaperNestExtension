# Roadmap — PaperNestFilePicker

## État

La roadmap `PaperNestFilePicker` est terminée.

## Objectif

Fournir à PaperNest un contrôle unique pour la sélection, le dépôt, la validation et la gestion interne des fichiers, puis remplacer les mécanismes historiques sans dupliquer l’état entre l’extension et l’application.

## Implémentation de l’extension

- [x] Création de l’API Python `PaperNestFilePicker`.
- [x] Implémentation Flutter du contrôle.
- [x] Regroupement de la sélection native, du glisser-déposer et de la liste interne.
- [x] Création de `PaperNestFilePickerFile` et `PaperNestFilePickerUploadFile`.
- [x] Création des états `NORMAL`, `HOVER`, `DRAG_OVER`, `SUCCESS`, `ERROR` et `DISABLED`.
- [x] Création des types `ANY`, `MEDIA`, `IMAGE`, `VIDEO`, `AUDIO` et `CUSTOM`.
- [x] Gestion des extensions autorisées, de la sélection simple ou multiple et du titre de dialogue.
- [x] Gestion optionnelle des données binaires avec `with_data`.
- [x] Gestion d’une zone personnalisée ou de la zone PaperNest par défaut.
- [x] Gestion du clic, du bouton externe et du glisser-déposer.
- [x] Gestion de la liste intégrée, de la taille, des icônes et des couleurs par type.
- [x] Gestion de `max_file_size`, `max_files` et de l’affichage des contraintes.
- [x] Détection des doublons et validation des fichiers.
- [x] Création des événements typés.
- [x] Méthodes publiques `get_files()`, `remove_file()`, `clear_files()`, `upload()` et `get_directory_path()`.
- [x] Export public depuis `papernestextension.controls` et `papernestextension`.

## Migration dans PaperNest

- [x] Inventaire de tous les anciens mécanismes de sélection et de dépôt.
- [x] Comparaison de l’API réelle avec les usages de PaperNest.
- [x] Lecture et vérification de l’exemple fonctionnel.
- [x] Création de `BaseFilePicker` héritant directement de `PaperNestFilePicker`.
- [x] Application du thème via des `kwargs.setdefault(...)` surchargeables.
- [x] Définition de la sélection interne du contrôle comme source de vérité.
- [x] Conservation des métadonnées applicatives dans PaperNest via les identifiants des fichiers.
- [x] Migration de la sélection multiple et du glisser-déposer de `UploadPanel`.
- [x] Conservation du bouton « Ajouter des fichiers » appelant `pick_files()`.
- [x] Migration de la sélection simple ZIP du bouton `restore_button`.
- [x] Préservation des messages d’erreur et des contraintes existantes.
- [x] Vérification de la compatibilité avec les traitements PDF et les services d’import.
- [x] Suppression du FilePicker historique partagé de `MainWindow`.
- [x] Suppression de l’ancien wrapper `ft.FilePicker` de `forms.py`.
- [x] Suppression de `FileDropZone`.
- [x] Suppression de la dépendance `flet-dropzone`.
- [x] Nettoyage des imports obsolètes.
- [x] Confirmation qu’aucun parcours actuel ne nécessite une sélection de dossier.

## Validation de l’extension

- [x] Vérification de l’exemple fonctionnel et du bouton externe `pick_files()`.
- [x] Test de la sélection par clic.
- [x] Test du glisser-déposer.
- [x] Test de la sélection simple et multiple.
- [x] Test de l’ajout, de la suppression et de l’effacement complet.
- [x] Test de la détection des doublons.
- [x] Test des extensions interdites.
- [x] Test de la limite de taille et du nombre maximal de fichiers.
- [x] Test des états visuels et de l’état désactivé.
- [x] Test de `get_files()`, `remove_file()` et `clear_files()`.
- [x] Validation de `get_directory_path()` sur une plateforme compatible.
- [x] Build et test de l’exemple sous Windows avec les versions retenues.

## Validation dans PaperNest

- [x] Test du tableau de bord avec sélection par clic.
- [x] Test du glisser-déposer et de la sélection multiple.
- [x] Test de l’ajout, de la suppression et de l’effacement complet.
- [x] Test de la détection des doublons.
- [x] Test du bouton externe « Ajouter des fichiers ».
- [x] Test du parcours de restauration depuis `restore_button`.
- [x] Vérification des chemins transmis aux services.
- [x] Vérification de l’import et du traitement des PDF.
- [x] Vérification du rendu visuel sous Windows.
- [x] Vérification de la sélection interne comme source de vérité.
- [x] Validation de chaque parcours réel par l’utilisateur.
- [x] Validation du build Windows de PaperNest.
- [x] Mise à jour de la roadmap UI et des changelogs.

## Nettoyage final

- [x] Suppression des anciens wrappers et contrôles devenus inutiles.
- [x] Suppression des imports obsolètes.
- [x] Retrait de `flet-dropzone`.
- [x] Vérification finale de `forms.py`.
- [x] Nettoyage commun effectué après validation des migrations DatePicker et FilePicker.

## Critères de finalisation

Tous les parcours réels de PaperNest utilisent `PaperNestFilePicker`. Le clic, le bouton externe et le glisser-déposer alimentent la même sélection interne. Les builds Windows, les interactions, les traitements PDF et le nettoyage de l’ancien système sont validés.
