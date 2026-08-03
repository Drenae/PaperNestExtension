# Roadmap — PaperNestButton

## État

Phases 1 et 2 réalisées.

`PaperNestButton` et `PaperNestButtonStyle` repartent désormais des sources Flet fournies, copiées et renommées. L’ancien prototype de surface Flutter a été supprimé.

L’étude technique du gradient par état conclut que **l’option A est techniquement réalisable** : le gradient peut être ajouté à `PaperNestButtonStyle` sous la forme d’un `ControlStateValue[Gradient]`. Cette décision doit être validée par l’utilisateur avant toute implémentation du gradient ou démarrage de la phase 3.

Aucune propriété `gradient`, `loading`, animation de survol ou animation de clic n’est encore présente dans le nouveau contrôle de base.

## Références obligatoires

Avant toute modification :

- [x] Lire `docs/README_DEVELOPMENT.md`.
- [x] Lire `docs/RULES.md`.
- [x] Étudier la source Python Flet `button.py`.
- [x] Étudier la source Python Flet `buttons.py` contenant `ButtonStyle`.
- [x] Étudier la source Flutter Flet `button.dart`.
- [x] Étudier la source Flutter Flet `buttons.dart` contenant `parseButtonStyle()`.
- [x] Étudier `container.dart` pour comprendre le rendu d’un gradient avec une décoration.
- [x] Étudier `ControlStateValue` côté Python.
- [x] Étudier le helper Flutter générique `getWidgetStateProperty()`.
- [x] Étudier `parseGradient()` côté Flutter.
- [x] Étudier l’interpolation native des gradients Flutter.
- [x] Vérifier l’existence de `WidgetStatesController` sur les boutons Material natifs.

## Principe non négociable

- Partir des sources Flet, pas d’un bouton reconstruit de zéro.
- Conserver le comportement natif de `Button` et `ButtonStyle`.
- Renommer les classes, contrôles, imports et parseurs pour PaperNestExtension.
- Ajouter uniquement les fonctionnalités demandées.
- Ne créer aucune variante métier dans Flutter.
- Ne modifier aucun autre contrôle pendant ce chantier.
- Ne migrer PaperNest qu’après validation complète de l’exemple PaperNestExtension.
- Ne pas commencer une phase suivante sans validation lorsque la roadmap le prévoit.

## Phase 1 — Repartir des sources Flet

### Python

- [x] Remplacer l’ancien prototype par la source Flet `button.py` copiée vers :
  - `src/papernestextension/controls/material/papernest_button.py`
- [x] Renommer `Button` en `PaperNestButton`.
- [x] Enregistrer le contrôle sous le type `PaperNestButton`.
- [x] Conserver l’héritage `LayoutControl` et `AdaptiveControl`.
- [x] Copier la partie utile de `buttons.py` vers :
  - `src/papernestextension/controls/papernest_button_style.py`
- [x] Renommer `ButtonStyle` en `PaperNestButtonStyle`.
- [x] Importer les formes natives de Flet puisqu’elles ne nécessitent aucune modification.
- [x] Faire utiliser `PaperNestButtonStyle` par `PaperNestButton`.
- [x] Conserver `before_update()` et la fusion de `color`, `bgcolor` et `elevation` dans le style.
- [x] Conserver la validation exigeant un contenu ou une icône visible.
- [x] Conserver la méthode `focus()`.

### Flutter

- [x] Remplacer l’ancien prototype par la source Flet `button.dart` copiée vers :
  - `src/flutter/papernestextension/lib/src/controls/papernest_button.dart`
- [x] Renommer `ButtonControl` en `PaperNestButtonControl`.
- [x] Copier le parseur utile de `buttons.dart` vers :
  - `src/flutter/papernestextension/lib/src/utils/papernest_button_style.dart`
- [x] Renommer `parseButtonStyle()` en `parsePaperNestButtonStyle()`.
- [x] Faire utiliser exclusivement le parseur PaperNest copié par `PaperNestButtonControl`.
- [x] Conserver les rendus Material natifs avec et sans icône.
- [x] Conserver `FocusNode`, `focus()`, URL, click, long press, hover, focus et blur.
- [x] Conserver la restitution via `LayoutControl`.
- [x] Supprimer l’ancien prototype `papernest_button_surface.dart`.

### État volontaire après la phase 1

- Le contrôle est revenu à une base Flet renommée.
- Les ajouts de l’ancien prototype ont été retirés.
- La page d’exemple précédente n’est pas encore adaptée à cette nouvelle base ; elle sera reconstruite pendant la phase 6.
- Les exports définitifs de `PaperNestButtonStyle` seront traités pendant la phase 5.

## Phase 2 — Étude bloquante du gradient

### Question principale

Déterminer si `gradient` peut être ajouté proprement à `PaperNestButtonStyle` comme une valeur dépendante de `ControlState`.

API étudiée :

```python
PaperNestButton(
    content="Enregistrer",
    icon=ft.Icons.SAVE_ROUNDED,
    style=PaperNestButtonStyle(
        gradient={
            ft.ControlState.DEFAULT: ft.LinearGradient(...),
            ft.ControlState.HOVERED: ft.LinearGradient(...),
            ft.ControlState.FOCUSED: ft.LinearGradient(...),
        },
    ),
)
```

### Résultats de l’étude

#### Sérialisation Python

- [x] `ControlStateValue[T]` accepte soit une valeur simple, soit un dictionnaire `ControlState → T`.
- [x] Les gradients Flet sont des objets `@value`, comme les autres valeurs complexes déjà utilisées dans les styles.
- [x] Le système de valeur Flet est générique et ne limite pas `ControlStateValue` aux couleurs ou aux nombres.
- [x] Un champ `gradient: Optional[ControlStateValue[Gradient]]` est donc cohérent avec le modèle de sérialisation existant.
- [ ] Confirmer définitivement cette sérialisation par un exemple compilé pendant les phases 6 et 7.

#### Parsing Flutter

- [x] `getWidgetStateProperty<T>()` accepte un convertisseur générique pour chaque valeur d’état.
- [x] `parseGradient()` peut servir directement de convertisseur pour construire un `WidgetStateProperty<Gradient?>`.
- [x] Les clés `default`, `hovered`, `focused`, `pressed` et `disabled` sont déjà reconnues par le helper Flet.
- [x] L’ordre des états reste celui défini par l’utilisateur, avec `default` utilisé en dernier recours.

Le parseur PaperNest pourra donc utiliser le principe suivant :

```dart
final gradient = getWidgetStateProperty<Gradient?>(
  value["gradient"],
  (jsonValue) => parseGradient(jsonValue, theme),
);
```

#### Suivi des états Material

- [x] Les boutons Material Flutter acceptent un `WidgetStatesController`.
- [x] Ce contrôleur permet d’utiliser les mêmes états réels que le bouton natif au lieu de recréer séparément hover, focus, pressed et disabled.
- [x] La résolution du gradient doit donc être branchée sur le contrôleur d’états du bouton Material.

#### Relation entre gradient et `bgcolor`

- [x] Le gradient doit remplacer visuellement `bgcolor` uniquement pour les états où un gradient est résolu.
- [x] Le fond Material doit devenir transparent lorsqu’un gradient est effectivement affiché.
- [x] `bgcolor` reste le fond de secours lorsqu’aucun gradient n’est résolu.
- [x] Si le dictionnaire ne contient pas un état précis, la résolution revient à `DEFAULT`, puis à `bgcolor` si aucun gradient par défaut n’existe.
- [x] Le gradient et `bgcolor` ne doivent pas être mélangés ou superposés comme deux fonds opaques.

#### Forme, bordure et clipping

- [x] Le gradient doit suivre la `shape` actuellement résolue par `PaperNestButtonStyle`.
- [x] Une simple `BoxDecoration(borderRadius: ...)` est insuffisante, car `ButtonStyle` accepte plusieurs formes Material.
- [x] Le rendu devra utiliser la forme résolue, par exemple avec `ShapeDecoration` et un clipping basé sur `ShapeBorderClipper`.
- [x] La bordure, l’élévation, l’overlay, le ripple et le focus restent gérés par le bouton Material natif.

#### Animation entre gradients

- [x] Flutter sait interpoler nativement les gradients de même type.
- [x] Les gradients linéaires peuvent avoir des couleurs et des stops différents ; Flutter recalcule les couleurs et stops intermédiaires.
- [x] Lorsque les types de gradients diffèrent, Flutter utilise un fondu de sortie puis d’entrée autour de la moitié de l’animation.
- [x] La transition peut donc rester animée sans imposer que tous les états utilisent exactement le même type de gradient.
- [ ] Vérifier visuellement les transitions entre gradients très différents dans l’exemple.

#### Comportement Material à préserver

- [x] Le bouton Material natif reste le contrôle interactif.
- [x] Son fond est rendu transparent uniquement lorsqu’un gradient est résolu.
- [x] Le ripple et `overlay_color` doivent rester visibles au-dessus du gradient.
- [x] Le focus, le clavier, la souris, l’état disabled et l’accessibilité restent natifs.
- [x] L’enveloppe du gradient ne doit pas remplacer la logique du bouton Material.

### Décision technique proposée

#### Option A — Gradient dans `PaperNestButtonStyle`

**Option retenue par l’étude, en attente de validation utilisateur avant implémentation.**

- [x] La sérialisation par état est compatible avec le modèle Flet.
- [x] Le parsing générique par `WidgetStateProperty` est possible.
- [x] Les états Material réels peuvent être partagés avec le rendu du gradient.
- [x] L’API est cohérente avec les autres propriétés dépendantes de l’état.
- [ ] Validation explicite de l’utilisateur.
- [ ] Ajouter `gradient: Optional[ControlStateValue[Gradient]]` à `PaperNestButtonStyle` après validation.
- [ ] Ajouter `gradient` à `copy()` après validation.
- [ ] Ajouter le parsing Flutter par `WidgetState` après validation.
- [ ] Créer une structure de résultat PaperNest contenant le `ButtonStyle` natif et le gradient par état.

#### Option B — Gradient directement dans `PaperNestButton`

Option de repli uniquement si l’option A échoue pendant l’implémentation ou la compilation.

- [ ] Ne pas retenir cette option tant que l’option A n’a pas démontré une incompatibilité réelle.
- [ ] En cas d’échec confirmé, conserver le `ButtonStyle` natif de Flet.
- [ ] Ajouter directement `gradient` et `gradient_hover` à `PaperNestButton`.

Aucune des deux options n’est encore implémentée.

## Phase 3 — API supplémentaire de PaperNestButton

Cette phase ne commence qu’après validation de la décision de la phase 2.

### Gradient

- [ ] Implémenter l’option validée à la fin de la phase 2.
- [ ] Ne pas ajouter une seconde API de gradient en parallèle.

### Chargement

- [ ] Ajouter `loading`.
- [ ] Ajouter `loading_text`.
- [ ] Ajouter les propriétés strictement nécessaires au loader après validation de l’exemple.
- [ ] Lorsque `loading=True`, désactiver l’action pour empêcher les doubles clics.
- [ ] Remplacer temporairement l’icône par un indicateur de progression.
- [ ] Utiliser `loading_text` uniquement lorsqu’il est renseigné.
- [ ] Conserver les dimensions du bouton pendant le changement d’état autant que possible.

### Animation de survol

- [ ] Ajouter `hover_scale`.
- [ ] Ajouter les éventuels paramètres complémentaires réellement nécessaires : durée, courbe et légère translation.
- [ ] Ne pas modifier les contraintes du layout pendant l’animation.
- [ ] Ne pas appliquer l’animation lorsque le bouton est désactivé ou en chargement.

### Animation de clic

- [ ] Ajouter `click_scale`.
- [ ] Ajouter les éventuels paramètres complémentaires réellement nécessaires : durée, courbe et légère translation.
- [ ] Conserver le ripple et le comportement Material natif.
- [ ] Réinitialiser correctement l’état après `pointerUp` et `pointerCancel`.

### Propriétés natives à préserver

- [x] `content`.
- [x] `icon` et `icon_color`.
- [x] `color`, `bgcolor`, `elevation` et `style`.
- [x] `autofocus`, `clip_behavior` et `url`.
- [x] `on_click`, `on_long_press`, `on_hover`, `on_focus` et `on_blur`.
- [x] Validation exigeant un contenu ou une icône visible.
- [x] Méthode `focus()`.
- [x] `before_update()` et fusion des propriétés simples dans le style.

## Phase 4 — Implémentation Flutter

- [ ] Partir du code copié de `ButtonControl` sans reconstruire manuellement toute son API.
- [ ] Conserver les boutons Material natifs utilisés par la source Flet.
- [ ] Ajouter uniquement l’enveloppe nécessaire au gradient et aux animations.
- [ ] Utiliser le même `WidgetStatesController` pour le bouton Material et le gradient.
- [ ] Rendre le fond Material transparent lorsqu’un gradient résolu est affiché.
- [ ] Utiliser `bgcolor` comme fallback lorsqu’aucun gradient n’est résolu.
- [ ] Respecter la forme et le clipping issus du style.
- [ ] Conserver overlay, ripple, focus, clavier, souris et accessibilité.
- [ ] Ne coder aucune couleur ou variante PaperNest en dur dans Flutter.

## Phase 5 — Exports et enregistrement

Après validation de la compilation du contrôle :

- [ ] Vérifier l’enregistrement de `PaperNestButton` dans `Extension.createWidget()`.
- [ ] Vérifier l’export de `PaperNestButton` depuis les modules publics Python.
- [ ] Exporter `PaperNestButtonStyle` si l’option A est validée et implémentée.
- [ ] Vérifier qu’aucun ancien export ou ancien prototype ne subsiste.

## Phase 6 — Application d’exemple

Reconstruire l’exemple pour tester la nouvelle API :

- [ ] Bouton natif sans ajout PaperNest.
- [ ] Bouton avec `bgcolor` uniquement.
- [ ] Bouton avec gradient normal.
- [ ] Bouton avec gradients par état si l’option A est validée.
- [ ] Bouton avec animation de survol.
- [ ] Bouton avec animation de clic.
- [ ] Bouton en chargement avec et sans `loading_text`.
- [ ] Bouton désactivé.
- [ ] Bouton avec icône.
- [ ] Bouton sans icône.
- [ ] Bouton avec `PaperNestButtonStyle` personnalisé.
- [ ] Vérifier que tous les styles sont contrôlés depuis Python.

## Phase 7 — Validation PaperNestExtension

- [ ] Vérifier les imports Python.
- [ ] Vérifier la compilation Flutter.
- [ ] Valider `flet run`.
- [ ] Valider les gradients et leurs transitions.
- [ ] Valider le fallback vers `bgcolor`.
- [ ] Valider hover, clic, focus et clavier.
- [ ] Valider loading et disabled.
- [ ] Vérifier l’absence de décalage de layout.
- [ ] Valider le build Windows.
- [ ] Faire valider visuellement et fonctionnellement le contrôle par l’utilisateur.

## Phase 8 — Intégration PaperNest

Cette phase ne commence qu’après validation complète de PaperNestExtension.

- [ ] Auditer les boutons actuels de PaperNest.
- [ ] Définir côté Python les wrappers nécessaires à PaperNest.
- [ ] Ne créer aucune variante dans Flutter.
- [ ] Préserver les besoins existants : texte, icône, loading, compact, largeur, hauteur et expansion.
- [ ] Conserver `IconAction` et `MenuAction` hors de ce chantier.
- [ ] Migrer les usages progressivement.
- [ ] Supprimer les anciens wrappers uniquement après validation complète.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows de PaperNest.

## Hors périmètre

- PaperNestTextField.
- PaperNestAlertDialog.
- PaperNestColorPicker.
- PaperNestIconPicker.
- PaperNestDatePicker.
- PaperNestFilePicker.
- Les variantes métier de PaperNest.
- La migration des actions internes des autres contrôles.

## Critère de finalisation

`PaperNestButton` sera terminé uniquement lorsque :

- il repartira fidèlement des sources Flet copiées et renommées ;
- le gradient par état aura été validé puis intégré à `PaperNestButtonStyle`, ou abandonné uniquement après échec technique démontré ;
- gradient, chargement, hover et clic fonctionneront sans casser le comportement Material natif ;
- l’exemple et le build Windows de PaperNestExtension seront validés ;
- l’intégration et le build Windows de PaperNest seront validés ;
- la roadmap et le changelog seront à jour.
