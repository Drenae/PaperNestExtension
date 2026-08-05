# Roadmap — Remplacement de PaperNestIconPicker par une implémentation Python

## État

**Décision validée : le sélecteur d’icônes doit être reconstruit entièrement en Python dans PaperNest, puis supprimé de PaperNestExtension.**

Le contrôle Flutter actuel n’apporte aucune capacité inaccessible en Python. La recherche, la galerie, la sélection temporaire, l’aperçu, l’annulation et la validation peuvent être composés avec les contrôles Flet natifs.

## Architecture cible

```text
PaperNest
├── PickerTextField
├── AppDialog(ft.AlertDialog)
└── IconPicker Python
    ├── recherche
    ├── grille responsive
    ├── sélection temporaire
    ├── aperçu
    └── validation

PaperNestExtension
└── aucun PaperNestIconPicker
```

## Phase 1 — Conception Python

- [ ] Définir une classe ou un composant Python dédié à l’affichage du picker.
- [ ] Réutiliser `PickerTextField` comme champ d’ouverture.
- [ ] Utiliser `AppDialog` pour la composition du dialogue.
- [ ] Conserver `PaperNestIconPickerOption` ou créer un modèle Python local équivalent.
- [ ] Conserver la valeur métier sous forme de nom Material (`FOLDER_ROUNDED`, etc.).
- [ ] Conserver le fallback `FOLDER_ROUNDED`.
- [ ] Ajouter la recherche par libellé et valeur.
- [ ] Construire une grille responsive.
- [ ] Gérer la sélection temporaire sans modifier la valeur finale avant validation.
- [ ] Gérer l’annulation, la validation et l’état désactivé.

## Phase 2 — Intégration PaperNest

- [ ] Remplacer `BaseIconPicker` par un wrapper Python utilisant `PickerTextField`.
- [ ] Migrer l’éditeur de classeur et de sous-catégorie.
- [ ] Préserver les valeurs déjà enregistrées.
- [ ] Préserver la prévisualisation dynamique.
- [ ] Vérifier le comportement avec une valeur inconnue.
- [ ] Vérifier la création et la modification des classeurs.

## Phase 3 — Validation

- [ ] Tester la recherche.
- [ ] Tester la sélection et l’annulation.
- [ ] Tester la validation explicite.
- [ ] Tester la conservation d’une valeur existante.
- [ ] Tester le fallback.
- [ ] Tester `disabled` et `read_only`.
- [ ] Valider le rendu Windows.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows PaperNest.
- [ ] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 4 — Suppression de PaperNestExtension

Cette phase ne commence qu’après validation du remplacement Python.

- [ ] Supprimer le contrôle Python `PaperNestIconPicker` de l’extension.
- [ ] Supprimer `PaperNestIconPickerOption` de l’extension si le modèle devient local à PaperNest.
- [ ] Supprimer le contrôle Flutter.
- [ ] Supprimer son enregistrement et ses exports.
- [ ] Supprimer les exemples spécifiques devenus inutiles.
- [ ] Nettoyer la documentation et les imports.
- [ ] Compiler et valider PaperNestExtension après suppression.

## Critère de finalisation

La roadmap sera terminée lorsque le sélecteur Python offrira tous les comportements réellement utilisés dans PaperNest, sera validé sous Windows, puis que le fork Flutter aura été retiré sans régression.
