# Roadmap — Remplacement de PaperNestIconPicker par une implémentation Python

## État

**Implémentation Python validée dans PaperNest. Suppression de l’ancien contrôle de PaperNestExtension encore en attente.**

Le contrôle Flutter n’apporte aucune capacité inaccessible en Python. La recherche globale dans `ft.Icons`, la galerie, la sélection temporaire, l’aperçu, l’annulation et la validation sont désormais composés avec les contrôles Flet natifs.

## Architecture validée

```text
PaperNest
├── PickerTextField
├── AppDialog(ft.AlertDialog)
└── BaseIconPicker Python
    ├── icônes métier recommandées
    ├── recherche globale dans ft.Icons *_ROUNDED
    ├── grille responsive
    ├── sélection temporaire
    ├── aperçu
    └── validation

PaperNestExtension
└── aucun PaperNestIconPicker après nettoyage final
```

## Phase 1 — Conception Python

- [x] Définir un composant Python dédié.
- [x] Réutiliser `PickerTextField` comme champ d’ouverture.
- [x] Utiliser `AppDialog` pour le dialogue.
- [x] Créer un modèle Python local `PaperNestIconPickerOption`.
- [x] Conserver la valeur métier sous forme de nom Material.
- [x] Conserver le fallback `FOLDER_ROUNDED`.
- [x] Afficher les icônes métier recommandées sans recherche.
- [x] Rechercher dans toutes les icônes Flet `*_ROUNDED`.
- [x] Prioriser les recommandations dans les résultats.
- [x] Construire une grille responsive.
- [x] Limiter le nombre de résultats affichés pour préserver les performances.
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

- [x] Tester la recherche globale et son effacement.
- [x] Tester la sélection puis l’annulation.
- [x] Tester la validation explicite.
- [x] Tester la conservation d’une valeur existante.
- [x] Tester une valeur inconnue et le fallback.
- [x] Tester la sélection d’une icône hors recommandations.
- [x] Vérifier la création et la modification d’un classeur.
- [x] Valider le rendu Windows.
- [x] Valider `flet run --recursive`.
- [x] Valider le build Windows PaperNest.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.

## Phase 4 — Suppression de PaperNestExtension

Cette phase sera réalisée avec le nettoyage groupé des anciens pickers.

- [ ] Supprimer le contrôle Python `PaperNestIconPicker` de l’extension.
- [ ] Supprimer `PaperNestIconPickerOption` de l’extension.
- [ ] Supprimer le contrôle Flutter.
- [ ] Supprimer son enregistrement et ses exports.
- [ ] Supprimer les exemples spécifiques devenus inutiles.
- [ ] Nettoyer la documentation et les imports.
- [ ] Compiler et valider PaperNestExtension après suppression.

## Critère de finalisation

Le remplacement Python est validé. La roadmap sera entièrement clôturée après suppression propre de l’ancien fork dans PaperNestExtension et validation de son build Windows.
