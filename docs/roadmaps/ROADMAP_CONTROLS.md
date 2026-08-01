# Roadmap des contrôles — PaperNestExtension

## État

Tous les contrôles actuellement nécessaires à PaperNest sont terminés, intégrés et validés sous Windows.

`PaperNestAlertDialog` est maintenant implémenté, compilé et validé dans l’application d’exemple. Son chantier reste ouvert pour la migration des pickers et l’intégration dans PaperNest.

Un chantier futur distinct est également identifié pour centraliser les composants Flutter partagés et réduire les duplications entre contrôles.

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

## Chantier d’architecture actif

- [ ] `PaperNestAlertDialog`

Le contrôle public Python et `PaperNestDialogSurface` sont créés et validés. Il reste à migrer les pickers concernés puis `AppDialog` dans PaperNest.

Roadmap détaillée :

- `ROADMAP_ALERT_DIALOG.md`

## Chantier d’architecture futur

- [ ] Centralisation des composants Flutter partagés.

Ce chantier devra réduire les duplications de bordures, décorations de champs, focus, survol et actions internes sans modifier les API publiques validées.

Roadmap détaillée :

- `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`

La création éventuelle d’un contrôle public `PaperNestButton` devra être décidée dans ce chantier uniquement si un besoin réel est confirmé. Elle n’est pas requise pour personnaliser les actions Python de `PaperNestAlertDialog`.

## Application d’exemple

La refonte de l’exemple en petite application navigable est suivie séparément :

- `ROADMAP_EXAMPLE_APP.md`

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
- Ne pas lancer une refactorisation transversale au milieu d’une migration fonctionnelle.
- Ne marquer un contrôle comme terminé qu’après validation de l’exemple, de l’intégration et du build Windows.
