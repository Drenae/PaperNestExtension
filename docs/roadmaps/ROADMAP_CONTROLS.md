# Roadmap des contrôles — PaperNestExtension

## État

Tous les contrôles actuellement intégrés à PaperNest sont terminés et validés sous Windows.

`PaperNestAlertDialog` est désormais officiellement terminé. Le chantier actif devient `PaperNestButton`.

Un chantier distinct reste planifié pour centraliser les composants Flutter partagés et réduire les duplications entre contrôles.

## Contrôles terminés

- [x] `PaperNestTextField`
- [x] `PaperNestDropdown` + `PaperNestDropdownOption`
- [x] `PaperNestColorPicker`
- [x] `PaperNestDatePicker`
- [x] `PaperNestFilePicker`
- [x] `PaperNestIconPicker` + `PaperNestIconPickerOption`
- [x] `PaperNestGlideRail` + `PaperNestGlideRailDestination`
- [x] `PaperNestAlertDialog` + `PaperNestDialogSurface`

Roadmaps détaillées terminées :

- `ROADMAP_COLOR_PICKER.md`
- `ROADMAP_DATE_PICKER.md`
- `ROADMAP_FILE_PICKER.md`
- `ROADMAP_ICON_PICKER.md`
- `ROADMAP_GLIDE_RAIL.md`
- `ROADMAP_ALERT_DIALOG.md`

## Chantier actif

### PaperNestButton

- [ ] `PaperNestButton`

Le contrôle sera développé comme un contrôle public Python + Flutter avec les besoins réels de PaperNest, ses variants, gradients et animations. Son rendu Flutter interne devra aussi pouvoir être utilisé par les actions des dialogues et des pickers.

Les sources Flet de `Button` côté Python et Flutter ont été fournies. L’étude complète attend également les sources de `ButtonStyle` côté Python et Dart.

Roadmap détaillée :

- `ROADMAP_BUTTON.md`

## Chantier futur

### Composants Flutter partagés

- [ ] Centralisation des composants Flutter partagés.

Ce chantier devra réduire les duplications de bordures, décorations de champs, focus, survol, variants et actions internes sans modifier les API publiques validées.

Roadmap détaillée :

- `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`

## Application d’exemple

La petite application navigable est suivie dans :

- `ROADMAP_EXAMPLE_APP.md`

`PaperNestButton` devra recevoir sa propre page ou section dédiée sans reconstruire l’application d’exemple.

## Validation globale

- [x] Implémentations Python et Flutter des contrôles terminés.
- [x] Exemples fonctionnels vérifiés sous Windows.
- [x] Intégrations PaperNest validées pour les contrôles terminés.
- [x] Builds Windows validés.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.

## Règles de suivi

- Ajouter un contrôle uniquement lorsqu’un besoin réel existe dans PaperNest.
- Commencer par l’étude de l’existant, de l’API Python et du code Flutter.
- Éviter les options sans usage concret.
- Centraliser les composants visuels Flutter partagés plutôt que dupliquer leur rendu.
- Regrouper les helpers par thèmes cohérents et éviter un fichier par petite fonction.
- Ne pas lancer une refactorisation transversale au milieu d’une migration fonctionnelle.
- Ne marquer un contrôle comme terminé qu’après validation de l’exemple, de l’intégration et du build Windows.
