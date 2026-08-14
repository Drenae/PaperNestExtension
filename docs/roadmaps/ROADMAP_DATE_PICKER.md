# Roadmap — Remplacement de PaperNestDatePicker par ft.DatePicker

## État

**Nettoyage terminé : wrapper Python natif validé dans PaperNest et ancien contrôle supprimé de PaperNestExtension. Rebuild Windows final à valider.**

`BaseDatePickerField` utilise désormais `ft.DatePicker` directement. Le fork Flutter a été retiré de PaperNestExtension après validation sous Windows.

## Architecture cible

```text
PaperNest
├── PickerTextField
└── BaseDatePickerField Python
    ├── ft.DatePicker natif
    ├── locale et textes français
    ├── conversion date/datetime
    ├── correction du décalage d’un jour
    └── valeur ISO pour les services

PaperNestExtension
└── aucun PaperNestDatePicker après nettoyage final
```

## Phase 1 — Étude et prototype Python

- [x] Reprendre le wrapper actuel comme référence fonctionnelle.
- [x] Vérifier l’API exacte de `ft.DatePicker` avec la version Flet du projet.
- [x] Définir l’ouverture depuis `PickerTextField`.
- [x] Conserver une valeur publique `datetime | None` représentant une date civile.
- [x] Conserver `iso_value` pour les services PaperNest.
- [x] Normaliser les dates civiles sans conversion UTC parasite.
- [x] Conserver une conversion défensive des données d’événement.
- [x] Garantir l’absence de décalage d’un jour.
- [x] Appliquer `ft.Locale("fr", "FR")`.
- [x] Appliquer les textes français du dialogue et du mode saisie.
- [x] Gérer `first_date`, `last_date`, `current_date` et l’effacement.

## Phase 2 — Intégration PaperNest

- [x] Remplacer `BaseDatePickerField` par le wrapper natif.
- [x] Conserver l’API utilisée par le dialogue des métadonnées.
- [x] Supprimer la dépendance PaperNest vers `PaperNestDatePicker`.
- [x] Préserver les callbacks existants.
- [x] Préserver `iso_value`.
- [x] Préserver le bouton d’effacement.
- [x] Préserver `disabled` et `read_only`.
- [x] Préserver les dates initiales déjà enregistrées.

## Phase 3 — Validation

- [x] Tester une valeur initiale ISO.
- [x] Tester une valeur initiale `datetime`.
- [x] Tester la sélection et la modification.
- [x] Tester l’effacement.
- [x] Tester les limites de dates.
- [x] Tester la locale et tous les libellés français.
- [x] Vérifier l’absence de décalage d’un jour.
- [x] Vérifier les valeurs ISO envoyées aux services.
- [x] Vérifier les deux dates du dialogue des métadonnées.
- [x] Valider `flet run --recursive`.
- [x] Valider le build Windows PaperNest.
- [x] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 4 — Suppression de PaperNestExtension

Cette phase ne commence qu’après validation du wrapper Python natif.

- [x] Supprimer `PaperNestDatePicker` côté Python.
- [x] Supprimer les enums et événements spécifiques devenus inutiles.
- [x] Supprimer le contrôle Flutter.
- [x] Supprimer l’enregistrement et les exports.
- [x] Supprimer l’exemple dédié devenu inutile.
- [x] Nettoyer la documentation et les imports.
- [ ] Compiler et valider PaperNestExtension après suppression.

## Critère de finalisation

La roadmap sera terminée lorsque le DatePicker natif sera validé sans décalage de date, puis que l’ancien fork Flutter aura été supprimé proprement et que PaperNestExtension aura été recompilé avec succès.
