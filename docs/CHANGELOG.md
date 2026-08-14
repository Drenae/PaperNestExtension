# Changelog — PaperNestExtension

Les évolutions importantes du projet sont consignées dans ce fichier.

## Version finalisée

Tous les contrôles actuellement nécessaires à PaperNest sont implémentés, intégrés et validés sous Windows.

## Contrôles disponibles

- `PaperNestTextField`
- `PaperNestDropdown` avec `PaperNestDropdownOption`
- `PaperNestFilePicker`
- `PaperNestButton`
- `PaperNestGlideRail`

`PaperNestDropdown` et `PaperNestDropdownOption` appartiennent au même composant fonctionnel.

## Contrôles retirés

- `PaperNestAlertDialog` : remplacé par `AppDialog(ft.AlertDialog)` dans PaperNest.
- `PaperNestColorPicker` : remplacé par une composition Python autour de `MaterialPicker`.
- `PaperNestDatePicker` : remplacé par `ft.DatePicker` et un wrapper Python.
- `PaperNestIconPicker` : remplacé par une galerie Python utilisant les icônes Flet natives.
- `PaperNestDialogSurface` : supprimé avec les contrôles Flutter qui l’utilisaient.

## PaperNestFilePicker

- Sélection native, bouton externe, glisser-déposer et liste interne unifiés.
- Gestion de la sélection simple ou multiple, des types, extensions, tailles et limites.
- Détection des doublons et événements typés.
- Méthodes `get_files()`, `remove_file()`, `clear_files()`, `upload()` et `get_directory_path()` validées.
- Exemple et build Windows validés.
- Intégration des parcours d’import et de restauration de PaperNest validée.

## Documentation et finalisation

- Documentation de développement et règles persistantes mises en place.
- Roadmaps détaillées des contrôles mises à jour et clôturées.
- Roadmap globale des contrôles clôturée.
- Nettoyage des anciens wrappers et dépendances dans PaperNest validé.

## Maintenance

Aucun nouveau contrôle n’est planifié. Une nouvelle fonctionnalité ne doit être ajoutée que lorsqu’un besoin concret et validé existe dans PaperNest.
