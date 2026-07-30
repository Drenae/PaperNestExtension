# Roadmap des contrôles — PaperNestExtension

## État

Les contrôles historiques nécessaires à PaperNest sont terminés et validés. Deux nouveaux besoins réels sont désormais à l’étude : transformer `BaseIconField` en picker autonome et créer une sidebar déployable au survol adaptée à PaperNest.

## Contrôles terminés

- [x] `PaperNestTextField`
- [x] `PaperNestDropdown` + `PaperNestDropdownOption` — même composant, deux classes complémentaires
- [x] `PaperNestColorPicker`
- [x] `PaperNestDatePicker`
- [x] `PaperNestFilePicker`

Roadmaps détaillées terminées :

- `ROADMAP_COLOR_PICKER.md`
- `ROADMAP_DATE_PICKER.md`
- `ROADMAP_FILE_PICKER.md`

## Contrôles à l’étude

- [ ] `PaperNestIconPicker`
- [ ] Sidebar déployable au survol — nom public final à définir

Roadmaps détaillées :

- `ROADMAP_ICON_PICKER.md`
- `ROADMAP_HOVER_SIDEBAR.md`

Ces études partent de besoins concrets et limités de PaperNest : remplacer le contrôle historique `BaseIconField` et remplacer la sidebar manuelle par une rail compacte qui se déploie au survol en superposition du contenu.

## Validation globale des contrôles terminés

- [x] Implémentation Python et Flutter des contrôles existants.
- [x] Exemples fonctionnels vérifiés sous Windows.
- [x] Intégration réelle dans PaperNest.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.
- [x] Validation des builds Windows.
- [x] Suppression des anciens wrappers et dépendances devenus inutiles dans PaperNest.
- [x] Mise à jour des roadmaps et changelogs des deux projets.

## Règles de suivi

- Ajouter un contrôle uniquement lorsqu’un besoin réel et validé existe dans PaperNest.
- Éviter toute complexité qui ne simplifie pas directement l’utilisation de l’application.
- Créer une roadmap dédiée pour toute nouvelle migration importante.
- Commencer par l’étude de l’existant et de l’API avant toute implémentation.
- Ne pas forker un contrôle Flet lorsque le besoin justifie mieux un contrôle autonome.
- Ne marquer un contrôle comme terminé qu’après validation de son implémentation, de son build et de son usage réel dans PaperNest.
