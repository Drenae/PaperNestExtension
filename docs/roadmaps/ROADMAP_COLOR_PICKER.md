# Roadmap — Refonte de PaperNestColorPicker

## État

**Audit terminé. Option A validée : `PaperNestColorPicker` sera supprimé de PaperNestExtension après validation de son remplacement Python dans PaperNest.**

Le contrôle officiel `MaterialPicker` du paquet `flet-color-pickers` fournit déjà les capacités nécessaires :

- propriété `color: ColorValue | None` ;
- compatibilité avec les couleurs hexadécimales et les couleurs Flet ;
- événements renvoyant la couleur sélectionnée sous forme hexadécimale ;
- rendu autonome pouvant être placé directement dans un `ft.AlertDialog`.

Notre fork actuel n’apporte donc plus de capacité technique indispensable. Il mélange au contraire quatre responsabilités :

- faux champ Material ;
- ouverture du dialogue ;
- affichage du `MaterialPicker` ;
- actions Annuler / Valider.

La normalisation stricte vers `#RRGGBB` reste entièrement réalisable côté Python.

## Architecture cible validée

```text
PaperNest
├── PickerTextField
├── AppDialog(ft.AlertDialog)
└── BaseColorPicker Python
    ├── MaterialPicker de flet-color-pickers
    ├── normalisation ColorValue → #RRGGBB
    ├── sélection temporaire
    ├── annulation
    ├── validation
    └── effacement

PaperNestExtension
└── aucun PaperNestColorPicker
```

## Phase 1 — Audit technique

- [x] Lire le contrôle Python actuel de PaperNestExtension.
- [x] Lire le contrôle Flutter actuel de PaperNestExtension.
- [x] Identifier la normalisation `#RGB`, `#RRGGBB` et `#AARRGGBB` côté Python.
- [x] Identifier la conversion Flutter actuelle vers `#RRGGBB`.
- [x] Confirmer que le contrôle actuel mélange champ, dialogue, picker et actions.
- [x] Vérifier l’API officielle de `flet-color-pickers`.
- [x] Confirmer que `MaterialPicker.color` accepte `ColorValue`.
- [x] Confirmer que `on_color_change` renvoie une valeur hexadécimale.
- [x] Confirmer que le picker officiel peut être placé directement dans un dialogue Python.
- [x] Confirmer que `PaperNestDialogSurface` n’est pas nécessaire au ColorPicker.

## Décision technique

### Option A — validée

- [x] Utiliser directement `flet-color-pickers` dans PaperNest.
- [x] Conserver la normalisation dans PaperNest.
- [x] Prévoir la suppression complète de `PaperNestColorPicker` dans l’extension.

### Option B — abandonnée

Aucun contrôle Flutter minimal ne sera conservé : le paquet officiel couvre déjà le besoin.

## Phase 2 — Implémentation Python dans PaperNest

- [ ] Ajouter `flet-color-pickers` aux dépendances de PaperNest.
- [ ] Créer un helper de normalisation acceptant :
  - [ ] `#RGB` ;
  - [ ] `#RRGGBB` ;
  - [ ] `#AARRGGBB` ;
  - [ ] valeurs issues de `ft.Colors` ;
  - [ ] `None` et valeurs invalides avec fallback.
- [ ] Refaire `BaseColorPicker` autour de `PickerTextField`.
- [ ] Afficher la couleur courante dans le champ.
- [ ] Construire un `MaterialPicker` dans `AppDialog`.
- [ ] Gérer une valeur temporaire pendant l’ouverture du dialogue.
- [ ] Appliquer la valeur uniquement lors de la validation.
- [ ] Ne pas modifier la valeur lors de l’annulation.
- [ ] Gérer l’effacement avec `clear_button`.
- [ ] Préserver `on_change` et la prévisualisation dynamique.

## Phase 3 — Migration PaperNest

- [ ] Migrer l’éditeur de classeur et de sous-catégorie.
- [ ] Préserver `BaseColorPicker.normalize_value()` ou fournir un alias compatible.
- [ ] Préserver les valeurs déjà enregistrées.
- [ ] Préserver le fallback métier `DEFAULT_COLOR`.
- [ ] Vérifier les valeurs invalides historiques.
- [ ] Ne modifier aucun autre picker pendant cette phase.

## Phase 4 — Validation

- [ ] Tester une valeur `#RGB`.
- [ ] Tester une valeur `#RRGGBB`.
- [ ] Tester une valeur `#AARRGGBB`.
- [ ] Tester une couleur issue de `ft.Colors`.
- [ ] Tester la sélection temporaire.
- [ ] Tester l’annulation.
- [ ] Tester la validation.
- [ ] Tester l’effacement.
- [ ] Tester les changements programmatiques.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows PaperNest.
- [ ] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 5 — Nettoyage PaperNestExtension

Cette phase ne commence qu’après validation complète du remplacement Python.

- [ ] Supprimer `papernest_color_picker.py`.
- [ ] Supprimer `papernest_color_picker.dart`.
- [ ] Supprimer l’enregistrement Flutter du contrôle.
- [ ] Nettoyer les exports Python.
- [ ] Retirer les exemples du contrôle supprimé.
- [ ] Nettoyer les imports liés à `PaperNestDialogSurface`.
- [ ] Supprimer `PaperNestDialogSurface` lorsque plus aucun autre picker ne l’utilise.
- [ ] Compiler PaperNestExtension.
- [ ] Valider son build Windows après nettoyage.

## Critère de finalisation

La roadmap sera terminée lorsque PaperNest utilisera directement `MaterialPicker` depuis Python avec une valeur publique normalisée en `#RRGGBB`, que la sélection, l’annulation, la validation et l’effacement seront validés, puis que le fork `PaperNestColorPicker` aura été supprimé proprement de PaperNestExtension.
