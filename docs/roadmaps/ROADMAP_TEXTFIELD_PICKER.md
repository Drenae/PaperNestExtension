# Roadmap — Mode picker de PaperNestTextField

## État

**Phases 1 à 3 implémentées dans PaperNestExtension. Phase 4 en attente de validation.**

`PaperNestTextField` peut désormais afficher, à l’intérieur du champ, un bouton Python entièrement personnalisable. Le TextField ne crée aucun bouton Flutter spécifique et n’ouvre lui-même aucun picker ou dialogue.

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

Rendu attendu :

```text
+--- Label ------------------------------------------------------+
|                                      +---+ +---------------+   |
|  valeur / hint                        | X | |    CHOISIR    |   |
|                                      +---+ +---------------+   |
+---------------------------------------------------------------+
```

## Principes non négociables

- [x] Conserver le contrôle actuel et son comportement natif.
- [x] Ne pas recréer un bouton stylé directement en Flutter.
- [x] Ne pas ajouter `picker_bgcolor`, `picker_color` ou `picker_border_radius`.
- [x] Accepter un véritable contrôle Python dans `picker_button`.
- [x] Permettre notamment l’utilisation de `PaperNestButton` et des wrappers PaperNest.
- [x] Ne pas ouvrir un dialogue, ColorPicker, IconPicker ou DatePicker depuis le TextField.
- [x] Le callback d’ouverture reste porté par `picker_button.on_click`.
- [x] Ne modifier aucun autre contrôle pendant ce chantier.

## API retenue

```python
picker: bool = False
picker_button: Optional[Control] = None
```

- [x] `picker=False` : aucun bouton picker n’est affiché.
- [x] `picker=True` : `picker_button` est affiché dans la zone suffixe du champ.
- [x] `picker=True` exige un `picker_button` visible.
- [x] `picker_button` reste un contrôle Flet complet.
- [x] Le TextField ne détourne pas son propre `on_click`.
- [x] Les événements existants restent inchangés.

## Composition visuelle

- [x] Le bouton picker est placé à l’intérieur, à droite du contenu.
- [x] Le bouton d’effacement est placé avant le bouton picker.
- [x] Ordre final : contenu → bouton d’effacement → `picker_button`.
- [x] Le bouton conserve son style, gradient, animation et comportement Python.
- [x] Le suffixe utilise `mainAxisSize: MainAxisSize.min`.
- [x] Le champ conserve label, hint, bordures, validation et padding.
- [ ] Valider visuellement une valeur longue et une fenêtre étroite.

## Bouton d’effacement

- [x] Afficher le bouton lorsque `clear_button=True`, que la valeur n’est pas vide et que le mode picker est actif.
- [x] Ne pas exiger `search_mode=True`.
- [x] Synchroniser `value` côté Python.
- [x] Déclencher `on_clear`.
- [x] Ne pas déclencher `on_search` hors du mode recherche.
- [x] Conserver `_clearSearch()` pour le mode recherche.
- [x] Utiliser une fonction d’effacement générique partagée.

## État du champ picker

- [x] Utiliser `read_only=True` dans le futur wrapper `PickerTextField`.
- [x] Ne pas utiliser `disabled=True` par défaut.
- [x] Laisser `disabled` disponible pour désactiver réellement le champ.
- [ ] Valider le curseur, la sélection et le focus en lecture seule.

## Phase 1 — API Python PaperNestExtension

- [x] Importer `Control`.
- [x] Ajouter `picker: bool = False`.
- [x] Ajouter `picker_button: Optional[Control] = None`.
- [x] Valider qu’un contrôle visible est fourni lorsque `picker=True`.
- [x] Ne modifier aucune autre propriété existante.
- [x] Conserver `_migrate_state()` et `before_update()`.

Commit principal :

```text
d4f995cb513a9b781c04b3651517413e3f94e748
```

## Phase 2 — Rendu Flutter

- [x] Lire `picker`.
- [x] Construire `picker_button` avec `control.buildWidget()`.
- [x] Ne pas recréer le bouton en Dart.
- [x] Unifier la composition du suffixe sans casser password, search, refresh ou validation.
- [x] Afficher le bouton d’effacement générique avant `picker_button`.
- [x] Préserver les tooltips et événements existants.
- [x] Bloquer l’interaction du bouton enfant lorsque le TextField est désactivé.
- [ ] Valider visuellement l’état désactivé.

Commit principal :

```text
31f931f73ae751877121a134b2e40ebaf4a53bf0
```

## Phase 3 — Exemple PaperNestExtension

- [x] Ajouter un TextField normal sans picker.
- [x] Ajouter un TextField avec `picker=True` et un `PaperNestButton` simple.
- [x] Ajouter clear + picker avec une valeur existante.
- [x] Ajouter un bouton gradient et animé piloté depuis Python.
- [x] Ajouter un picker désactivé.
- [x] Tester `read_only=True`.
- [x] Ajouter une valeur longue.
- [x] Vérifier le callback du bouton dans l’exemple.
- [x] Vérifier `on_clear` dans l’exemple.

Commit principal :

```text
7b8cc27c99c666d4f313dbcf67137d7e26764c39
```

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

Cette phase ne commence qu’après validation complète de PaperNestExtension.

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

- [ ] Importer les types nécessaires sans dépendance circulaire.
- [ ] Permettre tout bouton compatible, notamment `PrimaryButton("Choisir", ...)`.
- [ ] Conserver les styles de `BaseTextField`.
- [ ] Ne pas imposer le texte, la couleur ou le variant du bouton.
- [ ] Migrer les usages pendant les roadmaps ColorPicker et IconPicker.
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