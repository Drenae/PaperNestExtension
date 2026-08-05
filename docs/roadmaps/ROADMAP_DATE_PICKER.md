# Roadmap — Remplacement de PaperNestDatePicker par ft.DatePicker

## État

**Décision validée : `PaperNestDatePicker` doit être remplacé par le `ft.DatePicker` natif, configuré et enveloppé côté Python dans PaperNest.**

Le fork actuel n’apporte pas de capacité qui justifie un contrôle Flutter dédié. La langue, le thème, le format d’affichage et la normalisation des dates civiles peuvent être gérés côté Python autour du contrôle natif.

## Architecture cible

```text
PaperNest
├── PickerTextField
└── BaseDatePickerField Python
    ├── ft.DatePicker natif
    ├── locale et textes français
    ├── thème PaperNest
    ├── conversion date/datetime
    ├── correction du décalage d’un jour
    └── valeur ISO pour les services

PaperNestExtension
└── aucun PaperNestDatePicker
```

## Phase 1 — Étude et prototype Python

- [ ] Reprendre l’ancien wrapper Python du DatePicker natif comme référence.
- [ ] Vérifier l’API exacte de `ft.DatePicker` avec la version Flet figée du projet.
- [ ] Définir l’ouverture depuis `PickerTextField`.
- [ ] Définir la valeur publique (`date` ou `datetime`) sans ambiguïté.
- [ ] Définir `iso_value` pour les services PaperNest.
- [ ] Normaliser les dates civiles sans conversion UTC parasite.
- [ ] Garantir l’absence de décalage d’un jour.
- [ ] Appliquer la locale française et les textes français disponibles.
- [ ] Appliquer le thème PaperNest depuis Python.
- [ ] Gérer `first_date`, `last_date`, `current_date` et l’effacement.

## Phase 2 — Intégration PaperNest

- [ ] Remplacer `BaseDatePickerField` par le nouveau wrapper natif.
- [ ] Migrer le dialogue des métadonnées.
- [ ] Préserver les callbacks existants.
- [ ] Préserver `iso_value`.
- [ ] Préserver le bouton d’effacement.
- [ ] Préserver l’état désactivé.
- [ ] Vérifier les dates initiales déjà enregistrées.

## Phase 3 — Validation

- [ ] Tester la valeur initiale.
- [ ] Tester la sélection et la modification.
- [ ] Tester l’effacement.
- [ ] Tester les limites de dates.
- [ ] Tester la locale et les libellés français.
- [ ] Tester plusieurs fuseaux et l’absence de décalage d’un jour.
- [ ] Vérifier les valeurs ISO envoyées aux services.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows PaperNest.
- [ ] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 4 — Suppression de PaperNestExtension

Cette phase ne commence qu’après validation du wrapper Python natif.

- [ ] Supprimer `PaperNestDatePicker` côté Python.
- [ ] Supprimer les enums et événements spécifiques devenus inutiles.
- [ ] Supprimer le contrôle Flutter.
- [ ] Supprimer l’enregistrement et les exports.
- [ ] Supprimer l’exemple dédié devenu inutile.
- [ ] Nettoyer la documentation et les imports.
- [ ] Compiler et valider PaperNestExtension après suppression.

## Critère de finalisation

La roadmap sera terminée lorsque le DatePicker natif, piloté côté Python, reproduira les comportements utiles de PaperNest sans décalage de date, puis que le fork Flutter aura été supprimé sans régression.
