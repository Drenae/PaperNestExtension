# Roadmap — Refonte de PaperNestColorPicker

## État

**Option A implémentée dans PaperNest et en attente de validation.**

PaperNest utilise désormais directement `MaterialPicker` depuis `flet-color-pickers` dans un `AppDialog` Python. L’ancien `PaperNestColorPicker` reste temporairement présent dans PaperNestExtension jusqu’à validation complète de `flet run` et du build Windows.

## Architecture cible validée

```text
PaperNest
├── PickerTextField
├── AppDialog(ft.AlertDialog)
└── BaseColorPicker Python
    ├── MaterialPicker de flet-color-pickers
    ├── normalisation → #RRGGBB
    ├── sélection temporaire
    ├── annulation
    ├── validation
    └── effacement

PaperNestExtension
└── suppression future de PaperNestColorPicker
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

- [x] Ajouter `flet-color-pickers==0.85.3` aux dépendances de PaperNest.
- [x] Conserver un helper de normalisation acceptant `#RGB`, `#RRGGBB`, `#AARRGGBB`, `None` et les valeurs invalides avec fallback.
- [x] Refaire `BaseColorPicker` autour de `PickerTextField`.
- [x] Afficher la couleur courante avec une pastille dans le champ.
- [x] Utiliser un vrai `PrimaryButton` comme bouton Choisir.
- [x] Construire un `MaterialPicker` dans `AppDialog`.
- [x] Gérer une valeur temporaire pendant l’ouverture du dialogue.
- [x] Appliquer la valeur uniquement lors de la validation.
- [x] Ne pas modifier la valeur lors de l’annulation.
- [x] Gérer l’effacement avec `clear_button`.
- [x] Préserver `on_change` et `on_clear`.

Commits PaperNest :

```text
28007f5c5475379af78652ea00f79b03cdce2bb1
3557729b657172cafd6e38554a8fc6448d846e2b
```

## Phase 3 — Migration PaperNest

- [x] Remplacer le wrapper de l’éditeur de classeur et de sous-catégorie sans modifier son appel public.
- [x] Préserver `BaseColorPicker.normalize_value()`.
- [x] Préserver les valeurs déjà enregistrées.
- [x] Préserver le fallback métier `DEFAULT_COLOR`.
- [x] Préserver la prévisualisation dynamique après validation.
- [x] Ne modifier aucun autre picker pendant cette phase.

## Phase 4 — Validation

- [ ] Installer/synchroniser la nouvelle dépendance.
- [ ] Tester une valeur `#RGB`.
- [ ] Tester une valeur `#RRGGBB`.
- [ ] Tester une valeur `#AARRGGBB`.
- [ ] Tester une couleur issue de `ft.Colors`.
- [ ] Tester la sélection temporaire.
- [ ] Tester l’annulation.
- [ ] Tester la validation.
- [ ] Tester l’effacement.
- [ ] Tester les changements programmatiques.
- [ ] Vérifier la création et la modification d’un classeur.
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
