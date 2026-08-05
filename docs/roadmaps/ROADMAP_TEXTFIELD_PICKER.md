# Roadmap — Mode picker de PaperNestTextField

## État

**À valider avant implémentation.**

L’objectif est d’ajouter à `PaperNestTextField` un mode permettant d’afficher, à l’intérieur du champ, un bouton Python entièrement personnalisable. Le TextField ne doit créer aucun bouton Flutter spécifique et ne doit ouvrir lui-même aucun picker ou dialogue.

Exemple cible :

```python
PaperNestTextField(
    value="Banque",
    picker=True,
    clear_button=True,
    picker_button=PrimaryButton(
        "Choisir",
        on_click=open_picker,
    ),
)
```

Rendu attendu :

```text
+--- Label ------------------------------------------------------+
|                                      +---+ +---------------+   |
|  valeur / hint                        | X | |    CHOISIR    |   |
|                                      +---+ +---------------+   |
+---------------------------------------------------------------+
```

## Principes non négociables

- [ ] Conserver le contrôle actuel et son comportement natif.
- [ ] Ne pas recréer un bouton stylé directement en Flutter.
- [ ] Ne pas ajouter `picker_bgcolor`, `picker_color` ou `picker_border_radius`.
- [ ] Accepter un véritable contrôle Python dans `picker_button`.
- [ ] Permettre notamment l’utilisation de `PaperNestButton` et des wrappers PaperNest (`PrimaryButton`, `SecondaryButton`, etc.).
- [ ] Ne pas ouvrir un dialogue, ColorPicker, IconPicker ou DatePicker depuis le TextField.
- [ ] Le callback d’ouverture reste porté par `picker_button.on_click`.
- [ ] Ne modifier aucun autre contrôle pendant ce chantier.

## API retenue

### Nouvelles propriétés

```python
picker: bool = False
picker_button: Optional[Control] = None
```

### Règles

- [ ] `picker=False` : aucun bouton picker n’est affiché.
- [ ] `picker=True` : `picker_button` est affiché dans la zone suffixe du champ.
- [ ] `picker=True` exige un `picker_button` visible.
- [ ] `picker_button` reste un contrôle Flet complet, sans reconstruction Flutter de son style ou de ses événements.
- [ ] Le TextField ne détourne pas son propre `on_click` pour ouvrir le picker.
- [ ] `on_change`, `on_focus`, `on_blur`, `on_submit` et les autres événements existants restent inchangés.

## Composition visuelle

- [ ] Le bouton picker est placé à droite du contenu du champ.
- [ ] Lorsque `clear_button=True` et qu’une valeur existe, le bouton d’effacement est placé avant le bouton picker.
- [ ] Ordre final : contenu → bouton d’effacement → `picker_button`.
- [ ] Le bouton picker doit conserver sa hauteur, son padding, sa forme, son gradient, ses animations et son état disabled définis côté Python.
- [ ] Le suffixe doit utiliser `mainAxisSize: MainAxisSize.min` afin de ne pas absorber toute la largeur.
- [ ] Le champ doit conserver son label flottant, son hint, ses bordures, ses états de validation et son padding.
- [ ] Vérifier l’affichage avec une valeur longue et une fenêtre étroite.

## Bouton d’effacement

Le contrôle possède déjà `clear_button`, mais son comportement actuel est principalement lié au mode recherche. Le mode picker doit rendre cette fonction utilisable sur un champ normal en lecture seule.

- [ ] Afficher le bouton d’effacement lorsque `clear_button=True` et que `value` n’est pas vide.
- [ ] Ne pas exiger `search_mode=True` pour afficher ce bouton en mode picker.
- [ ] Vider le contrôleur et synchroniser `value` côté Python.
- [ ] Déclencher l’événement existant `on_clear`.
- [ ] Ne pas déclencher artificiellement `on_search` hors du mode recherche.
- [ ] Conserver le comportement actuel de `_clearSearch()` pour `search_mode=True`.
- [ ] Ajouter une fonction d’effacement générique si nécessaire plutôt que de détourner `_clearSearch()`.

## État du champ picker

Pour un sélecteur, la valeur doit être affichée mais ne doit pas être saisissable manuellement.

### Décision proposée

- [ ] Utiliser `read_only=True` dans le wrapper `PickerTextField` de PaperNest.
- [ ] Ne pas utiliser `disabled=True` par défaut, car cela griserait le champ et pourrait empêcher l’interaction avec les actions suffixes.
- [ ] Laisser `disabled` disponible lorsqu’un écran veut réellement désactiver le champ et son picker.
- [ ] Vérifier que le curseur, la sélection et le focus restent cohérents en lecture seule.

## Phase 1 — API Python PaperNestExtension

Fichier :

```text
src/papernestextension/controls/material/papernest_textfield.py
```

- [ ] Importer `Control` si nécessaire pour typer `picker_button`.
- [ ] Ajouter `picker: bool = False`.
- [ ] Ajouter `picker_button: Optional[Control] = None`.
- [ ] Ajouter une validation exigeant un contrôle visible lorsque `picker=True`.
- [ ] Ne modifier aucune autre propriété existante.
- [ ] Conserver `_migrate_state()` et `before_update()`.

## Phase 2 — Rendu Flutter

Fichier :

```text
src/flutter/papernestextension/lib/src/controls/papernest_textfield.dart
```

- [ ] Lire `picker`.
- [ ] Construire `picker_button` avec le mécanisme Flet de rendu des contrôles enfants.
- [ ] Ne pas recréer le bouton avec `TextButton`, `ElevatedButton` ou un widget PaperNest codé en Dart.
- [ ] Étendre la composition actuelle du suffixe sans casser password, search, refresh ou validation state.
- [ ] Afficher le bouton d’effacement générique avant `picker_button`.
- [ ] Préserver les tooltips et événements existants.
- [ ] Vérifier que `disabled` du TextField produit un comportement cohérent pour le bouton enfant.

## Phase 3 — Exemple PaperNestExtension

Mettre à jour la page Formulaires et le panneau TextField.

- [ ] Ajouter un TextField normal sans picker comme référence.
- [ ] Ajouter un TextField avec `picker=True` et un `PaperNestButton` simple.
- [ ] Ajouter un TextField avec `picker=True`, `clear_button=True` et une valeur existante.
- [ ] Ajouter un bouton picker avec gradient et animation pour confirmer qu’il reste entièrement contrôlé depuis Python.
- [ ] Ajouter un picker désactivé.
- [ ] Tester `read_only=True`.
- [ ] Tester une valeur longue.
- [ ] Vérifier l’événement du bouton picker.
- [ ] Vérifier `on_clear`.

## Phase 4 — Validation PaperNestExtension

- [ ] Vérifier les imports Python.
- [ ] Compiler Flutter sans erreur.
- [ ] Valider `flet run`.
- [ ] Valider le rendu normal sans picker.
- [ ] Valider le rendu avec picker.
- [ ] Valider le bouton d’effacement.
- [ ] Valider la coexistence clear + picker.
- [ ] Valider les états validation, password et search existants.
- [ ] Valider le build Windows.
- [ ] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 5 — Intégration PaperNest

Fichier :

```text
src/app/theme/forms.py
```

Créer :

```python
class PickerTextField(BaseTextField):
    def __init__(self, picker_button, **kwargs):
        kwargs.setdefault("read_only", True)
        kwargs.setdefault("picker", True)
        kwargs.setdefault("picker_button", picker_button)
        kwargs.setdefault("clear_button", True)
        super().__init__(**kwargs)
```

- [ ] Importer les types nécessaires sans créer de dépendance circulaire.
- [ ] Permettre n’importe quel bouton compatible, notamment `PrimaryButton("Choisir", ...)`.
- [ ] Conserver tous les styles de `BaseTextField`.
- [ ] Ne pas imposer un texte, une couleur ou un variant de bouton dans `PickerTextField`.
- [ ] Migrer les usages progressivement lors des roadmaps ColorPicker et IconPicker.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows de PaperNest.

## Hors périmètre

- Ouverture de `PaperNestAlertDialog`.
- Contenu du ColorPicker.
- Contenu de l’IconPicker.
- DatePicker natif.
- FilePicker.
- Variants des boutons.
- Refonte générale du TextField.

## Critère de finalisation

Le mode picker sera terminé lorsque `PaperNestTextField` pourra afficher un contrôle bouton fourni depuis Python, à côté de son bouton d’effacement, sans gérer lui-même le picker ou le dialogue et sans casser les comportements existants du TextField.