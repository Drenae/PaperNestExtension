# Roadmap des contrôles — PaperNestExtension

## État

Tous les contrôles actuellement nécessaires à PaperNest sont terminés, intégrés et validés sous Windows.

Une nouvelle étude est ouverte pour `PaperNestAlertDialog`, afin d’unifier le rendu des dialogues Python et des dialogues internes aux pickers.

## Contrôles terminés

- [x] `PaperNestTextField`
- [x] `PaperNestDropdown` + `PaperNestDropdownOption`
- [x] `PaperNestColorPicker`
- [x] `PaperNestDatePicker`
- [x] `PaperNestFilePicker`
- [x] `PaperNestIconPicker` + `PaperNestIconPickerOption`
- [x] `PaperNestGlideRail` + `PaperNestGlideRailDestination`

Roadmaps détaillées terminées :

- `ROADMAP_COLOR_PICKER.md`
- `ROADMAP_DATE_PICKER.md`
- `ROADMAP_FILE_PICKER.md`
- `ROADMAP_ICON_PICKER.md`
- `ROADMAP_GLIDE_RAIL.md`

## Chantier d’architecture ouvert

- [ ] `PaperNestAlertDialog`

Ce chantier doit fournir un contrôle public Python et un composant Flutter interne partagé par les pickers.

Roadmap détaillée :

- `ROADMAP_ALERT_DIALOG.md`

## Application d’exemple

La refonte de l’exemple en petite application navigable est suivie séparément :

- `ROADMAP_EXAMPLE_APP.md`

## Validation globale

- [x] Implémentations Python et Flutter.
- [x] Exemples fonctionnels vérifiés sous Windows.
- [x] Intégrations PaperNest validées.
- [x] Builds Windows validés.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.

## Règles de suivi

- Ajouter un contrôle uniquement lorsqu’un besoin réel existe dans PaperNest.
- Commencer par l’étude de l’existant, de l’API Python et du code Flutter.
- Éviter les options sans usage concret.
- Centraliser les composants visuels Flutter partagés plutôt que dupliquer leur rendu.
- Ne marquer un contrôle comme terminé qu’après validation de l’exemple, de l’intégration et du build Windows.
