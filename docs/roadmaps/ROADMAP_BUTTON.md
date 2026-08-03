# Roadmap — PaperNestButton

## État

Roadmap redéfinie avant reprise du développement.

Aucune nouvelle implémentation ne doit commencer avant validation explicite de cette roadmap.

La précédente approche est abandonnée. `PaperNestButton` doit repartir directement des sources Flet fournies, copiées et renommées, afin de conserver exactement le comportement natif de `Button` et `ButtonStyle` avant d’ajouter uniquement les besoins validés de PaperNest.

## Références obligatoires

Avant toute modification :

- [x] Lire `docs/README_DEVELOPMENT.md`.
- [x] Lire `docs/RULES.md`.
- [x] Étudier la source Python Flet `button.py`.
- [x] Étudier la source Python Flet `buttons.py` contenant `ButtonStyle`.
- [x] Étudier la source Flutter Flet `button.dart`.
- [x] Étudier la source Flutter Flet `buttons.dart` contenant `parseButtonStyle()`.
- [x] Étudier `container.dart` pour comprendre le rendu d’un gradient avec `BoxDecoration`.
- [ ] Consulter les helpers Flet complémentaires uniquement si nécessaires à l’implémentation du gradient par état.

## Principe non négociable

- Partir des sources Flet, pas d’un bouton reconstruit de zéro.
- Conserver le comportement natif de `Button` et `ButtonStyle`.
- Renommer les classes, contrôles, imports et parseurs pour PaperNestExtension.
- Ajouter uniquement les fonctionnalités demandées.
- Ne créer aucune variante métier dans Flutter.
- Ne modifier aucun autre contrôle pendant ce chantier.
- Ne migrer PaperNest qu’après validation complète de l’exemple PaperNestExtension.

## Phase 1 — Repartir des sources Flet

Copier puis renommer les quatre sources :

### Python

- [ ] Copier `button.py` vers :
  - `src/papernestextension/controls/material/papernest_button.py`
- [ ] Renommer `Button` en `PaperNestButton`.
- [ ] Enregistrer le contrôle sous le type `PaperNestButton`.
- [ ] Copier `buttons.py` vers :
  - `src/papernestextension/controls/papernest_button_style.py`
- [ ] Renommer `ButtonStyle` en `PaperNestButtonStyle` si son extension est retenue.
- [ ] Conserver toutes les formes de bordure nécessaires au style, ou importer celles de Flet lorsqu’aucune modification n’est requise.
- [ ] Faire utiliser `PaperNestButtonStyle` par `PaperNestButton` si cette classe est conservée.

### Flutter

- [ ] Copier `button.dart` vers :
  - `src/flutter/papernestextension/lib/src/controls/papernest_button.dart`
- [ ] Renommer `ButtonControl` en `PaperNestButtonControl`.
- [ ] Copier `buttons.dart` vers :
  - `src/flutter/papernestextension/lib/src/utils/papernest_button_style.dart`
- [ ] Renommer `parseButtonStyle()` en `parsePaperNestButtonStyle()` si le parseur est étendu.
- [ ] Mettre à jour les imports pour que `PaperNestButtonControl` utilise exclusivement le parseur PaperNest copié.
- [ ] Conserver les rendus Material natifs avec et sans icône.
- [ ] Conserver `FocusNode`, `focus()`, URL, click, long press, hover, focus et blur.
- [ ] Conserver la restitution via `LayoutControl`.

## Phase 2 — Étude bloquante du gradient

Cette phase doit être terminée et documentée avant de choisir l’API définitive.

### Question principale

Déterminer si `gradient` peut être ajouté proprement à `PaperNestButtonStyle` comme une valeur dépendante de `ControlState`.

API souhaitée si elle est techniquement fiable :

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

### Vérifications nécessaires

- [ ] Vérifier si `ControlStateValue[Gradient]` est sérialisable avec le système de valeurs Flet actuel.
- [ ] Étudier les helpers Flutter de `WidgetStateProperty` pour créer un parseur de gradient par état.
- [ ] Vérifier si `parseGradient()` peut être utilisé dans un `WidgetStateProperty<Gradient?>`.
- [ ] Vérifier la résolution des états `DEFAULT`, `HOVERED`, `FOCUSED`, `PRESSED` et `DISABLED`.
- [ ] Vérifier l’interpolation entre deux gradients avec `AnimatedContainer` ou une décoration animée.
- [ ] Vérifier les gradients incompatibles entre eux : type, nombre de couleurs, stops, begin/end.
- [ ] Déterminer le comportement lorsqu’un état ne possède pas de gradient : retour au gradient `DEFAULT`, puis au `bgcolor`.
- [ ] Vérifier le comportement de `bgcolor` lorsqu’un gradient est présent.
- [ ] Déterminer si le gradient remplace visuellement `bgcolor` ou si `bgcolor` reste un fond de secours.
- [ ] Vérifier que le bouton Material conserve ripple, overlay, focus, bordure, forme, élévation et état disabled.
- [ ] Vérifier que la forme et le clipping du gradient suivent exactement la `shape` résolue par `PaperNestButtonStyle`.

### Décision attendue

#### Option A — Gradient dans `PaperNestButtonStyle`

À retenir uniquement si le gradient par état est fiable et cohérent avec les autres propriétés de `ButtonStyle`.

- [ ] Ajouter `gradient: Optional[ControlStateValue[Gradient]]` à `PaperNestButtonStyle`.
- [ ] Ajouter `gradient` à `copy()`.
- [ ] Ajouter le parsing Flutter par `WidgetState`.
- [ ] Garder une API unique centralisée dans `style`.

#### Option B — Gradient dans `PaperNestButton`

À retenir si le gradient ne peut pas être intégré proprement à `PaperNestButtonStyle`.

- [ ] Ne pas conserver `PaperNestButtonStyle` si elle n’apporte aucune fonction supplémentaire.
- [ ] Continuer à utiliser le `ButtonStyle` natif de Flet.
- [ ] Ajouter directement à `PaperNestButton` :
  - `gradient`
  - `gradient_hover`
- [ ] Définir `gradient` comme état normal et fallback.
- [ ] Définir `gradient_hover` comme remplacement au survol uniquement.

Aucune des deux options ne doit être implémentée avant validation de la décision.

## Phase 3 — API supplémentaire de PaperNestButton

À ajouter à la copie du contrôle Flet, sans retirer ses propriétés natives.

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

- [ ] `content`.
- [ ] `icon` et `icon_color`.
- [ ] `color`, `bgcolor`, `elevation` et `style`.
- [ ] `autofocus`, `clip_behavior` et `url`.
- [ ] `on_click`, `on_long_press`, `on_hover`, `on_focus` et `on_blur`.
- [ ] validation exigeant un contenu ou une icône visible.
- [ ] méthode `focus()`.
- [ ] `before_update()` et la fusion des propriétés simples dans le style.

## Phase 4 — Implémentation Flutter

- [ ] Partir du code copié de `ButtonControl` sans reconstruire manuellement toute son API.
- [ ] Conserver les boutons Material natifs utilisés par la source Flet.
- [ ] Ajouter uniquement l’enveloppe nécessaire au gradient et aux animations.
- [ ] Utiliser une décoration externe pour le gradient uniquement si elle ne masque pas le style Material.
- [ ] Rendre le fond Material transparent lorsqu’un gradient résolu est affiché, si l’étude confirme cette nécessité.
- [ ] Utiliser `bgcolor` comme fallback lorsqu’aucun gradient n’est résolu.
- [ ] Respecter la forme et le clipping issus du style.
- [ ] Conserver overlay, ripple, focus, clavier, souris et accessibilité.
- [ ] Ne coder aucune couleur ou variante PaperNest en dur dans Flutter.

## Phase 5 — Exports et enregistrement

Après validation de la compilation du contrôle :

- [ ] Enregistrer `PaperNestButton` dans `Extension.createWidget()`.
- [ ] Exporter `PaperNestButton` depuis les modules publics Python.
- [ ] Exporter `PaperNestButtonStyle` uniquement si l’option A est retenue.
- [ ] Vérifier qu’aucun ancien export ou ancien prototype ne subsiste.

## Phase 6 — Application d’exemple

Créer un exemple qui teste l’API, sans recréer de variantes dans Flutter.

- [ ] Bouton natif sans ajout PaperNest.
- [ ] Bouton avec `bgcolor` uniquement.
- [ ] Bouton avec gradient normal.
- [ ] Bouton avec gradient par état si l’option A est retenue.
- [ ] Bouton avec `gradient_hover` si l’option B est retenue.
- [ ] Bouton avec animation de survol.
- [ ] Bouton avec animation de clic.
- [ ] Bouton en chargement avec et sans `loading_text`.
- [ ] Bouton désactivé.
- [ ] Bouton avec icône.
- [ ] Bouton sans icône.
- [ ] Bouton avec `ButtonStyle` ou `PaperNestButtonStyle` personnalisé.
- [ ] Vérifier que tous les styles sont contrôlés depuis Python.

## Phase 7 — Validation PaperNestExtension

- [ ] Vérifier les imports Python.
- [ ] Vérifier la compilation Flutter.
- [ ] Valider `flet run`.
- [ ] Valider les gradients et leurs transitions.
- [ ] Valider le fallback vers `bgcolor`.
- [ ] Valider le hover, le clic, le focus et le clavier.
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
- le choix entre gradient dans `PaperNestButtonStyle` ou gradient direct dans `PaperNestButton` aura été étudié, décidé et validé ;
- gradient, chargement, hover et clic fonctionneront sans casser le comportement Material natif ;
- l’exemple et le build Windows de PaperNestExtension seront validés ;
- l’intégration et le build Windows de PaperNest seront validés ;
- la roadmap et le changelog seront à jour.
