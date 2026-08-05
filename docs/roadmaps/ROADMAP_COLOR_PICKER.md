# Roadmap — Refonte de PaperNestColorPicker

## État

**Décision non encore définitive : la suppression du fork Flutter dépend de la validation d’un prototype Python fondé sur `flet-color-picker`.**

L’audit du contrôle actuel montre que :

- la normalisation `#RGB`, `#RRGGBB` et `#AARRGGBB` est déjà réalisée côté Python ;
- la valeur publique peut être forcée en `#RRGGBB` côté Python ;
- les couleurs Flet sont résolues côté Flutter par `getColor()` ;
- le Dart actuel sert principalement à afficher `MaterialPicker`, ouvrir son dialogue, construire le faux champ et renvoyer le résultat en hexadécimal ;
- le dialogue, les actions et le champ d’ouverture ne doivent plus appartenir au picker.

## Principe directeur

Le picker doit uniquement afficher et gérer la sélection d’une couleur. Le champ d’ouverture, le dialogue, les actions, la normalisation publique et l’intégration au formulaire restent en Python.

Architecture cible privilégiée :

```text
PaperNest
├── PickerTextField
├── AppDialog(ft.AlertDialog)
└── BaseColorPicker Python
    ├── contenu flet-color-picker
    ├── normalisation ColorValue → #RRGGBB
    ├── sélection temporaire
    ├── annulation
    └── validation

PaperNestExtension
└── aucun PaperNestColorPicker
```

Architecture de repli uniquement si le prototype Python échoue :

```text
PaperNestExtension
└── PaperNestColorPickerContent
    └── affichage du picker uniquement
```

Dans ce cas de repli, le contrôle Flutter ne doit gérer ni champ, ni dialogue, ni bouton, ni actions.

## Phase 1 — Audit technique

- [x] Identifier la normalisation Python actuelle.
- [x] Identifier la conversion Flutter actuelle vers `#RRGGBB`.
- [x] Confirmer que le contrôle actuel mélange trop de responsabilités : champ, dialogue, picker et actions.
- [x] Confirmer que `PaperNestDialogSurface` doit disparaître du ColorPicker.
- [ ] Récupérer et lire intégralement les sources de la version exacte de `flet-color-picker` utilisée comme base.
- [ ] Comparer son API Python et son widget Flutter avec le fork PaperNest.
- [ ] Identifier précisément la modification qui a rendu compatibles les couleurs hexadécimales et les `ft.Colors`.

## Phase 2 — Prototype 100 % Python

- [ ] Ajouter temporairement `flet-color-picker` au projet de test.
- [ ] Construire le contenu du picker sans dialogue interne.
- [ ] Accepter une valeur initiale de type `ColorValue`.
- [ ] Accepter `#RGB`, `#RRGGBB`, `#AARRGGBB` et les valeurs issues de `ft.Colors`.
- [ ] Normaliser la valeur publique en `#RRGGBB`.
- [ ] Gérer une sélection temporaire distincte de la valeur finale.
- [ ] Composer le dialogue avec `AppDialog`.
- [ ] Ouvrir le dialogue depuis `PickerTextField`.
- [ ] Vérifier l’annulation et la validation explicite.
- [ ] Vérifier la mise à jour programmée de la valeur.

## Décision bloquante

Après le prototype :

### Option A — Prototype Python validé

- [ ] Supprimer complètement `PaperNestColorPicker` de l’extension.
- [ ] Conserver toute la normalisation dans PaperNest.
- [ ] Utiliser directement `flet-color-picker` comme dépendance de PaperNest.

### Option B — Limitation technique confirmée

- [ ] Conserver un contrôle Flutter minimal limité au contenu de sélection.
- [ ] Supprimer tout le rendu de champ Material.
- [ ] Supprimer l’ouverture du dialogue Flutter.
- [ ] Supprimer les boutons Annuler/Valider Flutter.
- [ ] Supprimer le focus, le clear button et les événements liés au faux champ.
- [ ] Exposer uniquement la valeur temporaire et l’événement de changement.

Aucune option ne sera implémentée définitivement avant validation de ce choix par l’utilisateur.

## Phase 3 — Intégration PaperNest

- [ ] Refaire `BaseColorPicker` autour de `PickerTextField`.
- [ ] Composer le dialogue côté Python.
- [ ] Préserver `normalize_value()` et le fallback métier.
- [ ] Préserver la prévisualisation dynamique des catégories.
- [ ] Migrer l’éditeur de classeur et de sous-catégorie.
- [ ] Tester les valeurs existantes et invalides.

## Phase 4 — Validation

- [ ] Tester une valeur hexadécimale.
- [ ] Tester une couleur Flet.
- [ ] Tester une valeur `#AARRGGBB`.
- [ ] Tester l’annulation et la validation.
- [ ] Tester l’effacement.
- [ ] Tester les changements programmatiques.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows PaperNest.
- [ ] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 5 — Nettoyage de l’extension

- [ ] Supprimer `PaperNestDialogSurface` lorsque plus aucun picker ne l’utilise.
- [ ] Supprimer ou réduire le contrôle Flutter selon l’option validée.
- [ ] Nettoyer les exports, les exemples et la documentation.
- [ ] Compiler et valider PaperNestExtension après nettoyage.

## Critère de finalisation

La roadmap sera terminée lorsque la compatibilité hexadécimale et `ft.Colors` sera préservée avec la solution la plus simple possible, que le champ et le dialogue seront entièrement pilotés depuis Python, puis que le code Flutter inutile aura été supprimé.
