# Roadmap des contrôles — PaperNestExtension

## État

Les contrôles nécessaires à PaperNest sont terminés et validés, à l’exception de l’étude encore ouverte pour transformer `BaseIconField` en contrôle autonome `PaperNestIconPicker`.

## Contrôles terminés

- [x] `PaperNestTextField`
- [x] `PaperNestDropdown` + `PaperNestDropdownOption` — même composant, deux classes complémentaires
- [x] `PaperNestColorPicker`
- [x] `PaperNestDatePicker`
- [x] `PaperNestFilePicker`
- [x] `PaperNestGlideRail` + `PaperNestGlideRailDestination`

Roadmaps détaillées terminées :

- `ROADMAP_COLOR_PICKER.md`
- `ROADMAP_DATE_PICKER.md`
- `ROADMAP_FILE_PICKER.md`
- `ROADMAP_GLIDE_RAIL.md`

## Contrôle à l’étude

- [ ] `PaperNestIconPicker`

Roadmap détaillée :

- `ROADMAP_ICON_PICKER.md`

Cette étude part d’un besoin concret et limité de PaperNest : remplacer le contrôle historique `BaseIconField` par un picker autonome cohérent avec les autres contrôles de l’extension.

## Validation globale des contrôles terminés

- [x] Implémentation Python et Flutter.
- [x] Exemples fonctionnels vérifiés sous Windows.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.
- [x] Validation des builds Windows.
- [x] Nettoyage des exemples et de la documentation.

L’intégration d’un contrôle dans PaperNest reste suivie séparément lorsqu’elle n’a pas encore été effectuée.

## Règles de suivi

- Ajouter un contrôle uniquement lorsqu’un besoin réel et validé existe dans PaperNest.
- Éviter toute complexité qui ne simplifie pas directement l’utilisation de l’application.
- Créer une roadmap dédiée pour toute nouvelle migration importante.
- Commencer par l’étude de l’existant et de l’API avant toute implémentation.
- Ne pas forker un contrôle Flet lorsque le besoin justifie mieux un contrôle autonome.
- Ne pas ajouter d’options par anticipation après validation d’un contrôle.
- Ne marquer un contrôle comme terminé qu’après validation de son implémentation et de son build.
