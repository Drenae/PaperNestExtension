# Roadmap — Mode picker de PaperNestTextField

## État

**Clôturée : PaperNestExtension et le wrapper `PickerTextField` sont validés, tous les usages prévus ont été migrés dans PaperNest.**

`PaperNestTextField` peut afficher, à l’intérieur du champ, un bouton Python entièrement personnalisable. Le TextField ne crée aucun bouton Flutter spécifique et n’ouvre lui-même aucun picker ou dialogue.

Exemple :

```python
PaperNestTextField(
    value="Banque",
    read_only=True,
    picker=True,
    clear_button=True,
    picker_button=PrimaryButton(
        "Choisir",
        on_click=open_picker,
    ),
)
```

## Principes validés

- [x] Conserver le contrôle actuel et son comportement natif.
- [x] Ne pas recréer un bouton stylé directement en Flutter.
- [x] Ne pas ajouter `picker_bgcolor`, `picker_color` ou `picker_border_radius`.
- [x] Accepter un véritable contrôle Python dans `picker_button`.
- [x] Permettre l’utilisation de `PaperNestButton` et des wrappers PaperNest.
- [x] Ne pas ouvrir un dialogue ou un picker depuis le TextField.
- [x] Le callback d’ouverture reste porté par `picker_button.on_click`.

## API validée

```python
picker: bool = False
picker_button: Optional[Control] = None
```

- [x] `picker=False` masque le bouton.
- [x] `picker=True` affiche `picker_button` dans le suffixe.
- [x] `picker=True` exige un contrôle visible.
- [x] Les événements natifs du TextField restent inchangés.

## Composition visuelle validée

- [x] Bouton intégré à l’intérieur du champ.
- [x] Ordre : contenu → effacer → `picker_button`.
- [x] Le bouton conserve style, gradient, animations et loading définis côté Python.
- [x] Valeur longue et largeur réduite validées.
- [x] Champ normal sans picker inchangé.
- [x] Coexistence avec les états validation, password et search validée.

## Effacement validé

- [x] `clear_button` fonctionne hors du mode recherche lorsque le picker est actif.
- [x] `value` est synchronisée côté Python.
- [x] `on_clear` est déclenché.
- [x] `on_search` n’est pas déclenché hors du mode recherche.

## PaperNestExtension

### Phase 1 — API Python

- [x] Ajouter `picker`.
- [x] Ajouter `picker_button`.
- [x] Valider le contrôle enfant.

Commit :

```text
d4f995cb513a9b781c04b3651517413e3f94e748
```

### Phase 2 — Flutter

- [x] Construire le bouton avec `control.buildWidget()`.
- [x] Ne pas recréer le bouton en Dart.
- [x] Composer proprement le suffixe.
- [x] Ajouter l’effacement générique.

Commit :

```text
31f931f73ae751877121a134b2e40ebaf4a53bf0
```

### Phase 3 — Exemple et validation

- [x] Champ normal.
- [x] Picker simple.
- [x] Clear + picker.
- [x] Gradient et animations.
- [x] Valeur longue.
- [x] État désactivé.
- [x] Compilation Flutter.
- [x] `flet run`.
- [x] Build Windows.
- [x] Validation utilisateur.

Commit exemple :

```text
7b8cc27c99c666d4f313dbcf67137d7e26764c39
```

## Intégration PaperNest

Le wrapper est disponible dans :

```text
src/app/theme/forms.py
```

```python
class PickerTextField(BaseTextField):
    def __init__(self, picker_button: ft.Control, **kwargs):
        kwargs.setdefault("read_only", True)
        kwargs.setdefault("picker", True)
        kwargs.setdefault("picker_button", picker_button)
        kwargs.setdefault("clear_button", True)
        super().__init__(**kwargs)
```

- [x] Ajouter `PickerTextField` sans dépendance circulaire.
- [x] Conserver les styles de `BaseTextField`.
- [x] Ne pas imposer le texte, la couleur ou la variante du bouton.
- [x] Ne migrer aucun usage avant la refonte de `PaperNestAlertDialog`, `PaperNestColorPicker` et `PaperNestIconPicker`.
- [x] Migrer progressivement les usages après validation de ces contrôles.
- [x] Valider PaperNest après migration complète.

Commit :

```text
a1fd71a34776c0cd0903409515aae3fab016d2ba
```

## Critère de finalisation

Le contrôle, son wrapper et la migration finale des pickers dans PaperNest sont validés.
