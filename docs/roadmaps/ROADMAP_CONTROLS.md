# Roadmap des contrôles — PaperNestExtension

## État

La roadmap des contrôles est terminée. Tous les contrôles actuellement nécessaires à PaperNest sont implémentés, intégrés et validés sous Windows.

## Contrôles terminés

- [x] `PaperNestTextField`
- [x] `PaperNestDropdown` + `PaperNestDropdownOption` — même composant, deux classes complémentaires
- [x] `PaperNestColorPicker`
- [x] `PaperNestDatePicker`
- [x] `PaperNestFilePicker`

Roadmaps détaillées :

- `ROADMAP_COLOR_PICKER.md`
- `ROADMAP_DATE_PICKER.md`
- `ROADMAP_FILE_PICKER.md`

## Validation globale

- [x] Implémentation Python et Flutter des contrôles.
- [x] Exemples fonctionnels vérifiés sous Windows.
- [x] Intégration réelle dans PaperNest.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.
- [x] Validation des builds Windows.
- [x] Suppression des anciens wrappers et dépendances devenus inutiles dans PaperNest.
- [x] Mise à jour des roadmaps et changelogs des deux projets.

## Nouveaux contrôles

Aucun nouveau contrôle n’est planifié. PaperNest est considéré comme terminé et l’extension ne doit pas recevoir de fonctionnalités supplémentaires sans besoin concret dans l’application.

## Règles de suivi

- Ajouter un contrôle uniquement lorsqu’un besoin réel et validé existe dans PaperNest.
- Éviter toute complexité qui ne simplifie pas directement l’utilisation de l’application.
- Créer une roadmap dédiée pour toute nouvelle migration importante.
- Ne marquer un contrôle comme terminé qu’après validation de son implémentation, de son build et de son usage réel dans PaperNest.
