# Roadmap — Refonte Python-first des pickers

## Statut final

**Roadmap terminée et validée sous Windows.**

La stratégie Python-first a été appliquée jusqu’au bout :

- `PaperNestButton` est finalisé et conservé dans l’extension ;
- `PaperNestTextField` fournit le mode picker avec un véritable contrôle Python ;
- `PaperNestAlertDialog` a été remplacé par `AppDialog(ft.AlertDialog)` ;
- `PaperNestColorPicker` a été remplacé par une composition Python autour de `MaterialPicker` ;
- `PaperNestIconPicker` a été remplacé par une galerie Python utilisant `ft.Icons` ;
- `PaperNestDatePicker` a été remplacé par `ft.DatePicker` et un wrapper Python ;
- `PaperNestFilePicker` a été conservé sans modification d’architecture ;
- les anciens contrôles Flutter, leurs exports, leurs exemples et `PaperNestDialogSurface` ont été supprimés.

## Architecture finale

```text
PaperNestExtension
├── PaperNestButton
├── PaperNestTextField
├── PaperNestDropdown
├── PaperNestFilePicker
└── PaperNestGlideRail

PaperNest
├── AppDialog(ft.AlertDialog)
├── PickerTextField
├── BaseColorPicker + MaterialPicker
├── BaseIconPicker + ft.Icons
└── BaseDatePickerField + ft.DatePicker
```

## Validation

- [x] Composition et logique métier conservées côté Python.
- [x] Absence de dépendance circulaire entre boutons, dialogues et pickers.
- [x] Migration complète des usages PaperNest.
- [x] Suppression des anciens contrôles devenus inutiles.
- [x] Nettoyage de l’application d’exemple.
- [x] Validation fonctionnelle sous Windows.
- [x] Validation du build Windows après nettoyage.

## Décisions de maintenance

`PaperNestDropdown` reste volontairement dans l’extension : il s’agit d’un fork de Dropdown M2 modernisé et personnalisé, stable et validé. Il ne doit pas être remplacé par le Dropdown natif sans besoin concret.

Les composants validés ne doivent plus être refondus en l’absence de problème réel.
