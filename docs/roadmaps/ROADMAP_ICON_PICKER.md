# Roadmap — Remplacement de PaperNestIconPicker par une implémentation Python

## État

**Implémentation Python terminée dans PaperNest. Validation applicative en attente.**

Le contrôle Flutter actuel n’apporte aucune capacité inaccessible en Python. La recherche, la galerie, la sélection temporaire, l’aperçu, l’annulation et la validation sont désormais composés avec les contrôles Flet natifs.

## Architecture cible

```text
PaperNest
├── PickerTextField
├── AppDialog(ft.AlertDialog)
└── BaseIconPicker Python
    ├── recherche
    ├── grille responsive
    ├── sélection temporaire
    ├── aperçu
    └── validation

PaperNestExtension
└── aucun PaperNestIconPicker après validation
```

## Phase 1 — Conception Python

- [x] Définir un composant Python dédié.
- [x] Réutiliser `PickerTextField` comme champ d’ouverture.
- [x] Utiliser `AppDialog` pour le dialogue.
- [x] Créer un modèle Python local `PaperNestIconPickerOption`.
- [x] Conserver la valeur métier sous forme de nom Material.
- [x] Conserver le fallback `FOLDER_ROUNDED`.
- [x] Ajouter la recherche par libellé et valeur.
- [x] Construire une grille responsive.
- [x] Gérer la sélection temporaire.
- [x] Gérer l’annulation, la validation, `disabled` et `read_only`.

## Phase 2 — Intégration PaperNest

- [x] Remplacer `BaseIconPicker` par une composition Python.
- [x] Conserver l’API utilisée par l’éditeur de classeur.
- [x] Supprimer la dépendance PaperNest vers `PaperNestIconPicker`.
- [x] Supprimer la dépendance PaperNest vers l’option de l’extension.
- [x] Préserver les valeurs déjà enregistrées et le fallback.
- [x] Préserver la prévisualisation dynamique via `on_change`.

## Phase 3 — Validation

- [ ] Tester la recherche et son effacement.
- [ ] Tester la sélection puis l’annulation.
- [ ] Tester la validation explicite.
- [ ] Tester la conservation d’une valeur existante.
- [ ] Tester une valeur inconnue et le fallback.
- [ ] Tester `disabled` et `read_only`.
- [ ] Vérifier la création et la modification d’un classeur.
- [ ] Valider le rendu Windows.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows PaperNest.
- [ ] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 4 — Suppression de PaperNestExtension

Cette phase ne commence qu’après validation du remplacement Python.

- [ ] Supprimer le contrôle Python `PaperNestIconPicker` de l’extension.
- [ ] Supprimer `PaperNestIconPickerOption` de l’extension.
- [ ] Supprimer le contrôle Flutter.
- [ ] Supprimer son enregistrement et ses exports.
- [ ] Supprimer les exemples spécifiques devenus inutiles.
- [ ] Nettoyer la documentation et les imports.
- [ ] Compiler et valider PaperNestExtension après suppression.

## Critère de finalisation

La roadmap sera terminée lorsque le sélecteur Python sera validé sous Windows, puis que le fork Flutter aura été retiré sans régression.
