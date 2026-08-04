# Roadmap — PaperNestButton

## État

Phases 1 à 6 implémentées dans PaperNestExtension.

Le contrôle repart des sources Flet `Button` et `ButtonStyle`, copiées et renommées. Le gradient appartient à `PaperNestButtonStyle` et peut dépendre des états Material.

La compilation Flutter des phases 2 à 4 a été effectuée avec succès. Les exports publics sont à jour et la page `Actions` a été reconstruite pour tester exclusivement la nouvelle API.

La phase 7 reste à valider par l’utilisateur avant toute intégration dans PaperNest.

## Références obligatoires

- [x] Lire `docs/README_DEVELOPMENT.md`.
- [x] Lire `docs/RULES.md`.
- [x] Étudier les sources Flet Python `button.py` et `buttons.py`.
- [x] Étudier les sources Flet Flutter `button.dart` et `buttons.dart`.
- [x] Étudier `container.dart` pour le rendu du gradient.
- [x] Étudier `ControlStateValue`, `WidgetStateProperty`, `parseGradient()` et l’interpolation Flutter des gradients.
- [x] Vérifier l’existence de `WidgetStatesController` sur les boutons Material.

## Principes non négociables

- Partir des sources Flet et conserver leur comportement natif.
- Ajouter uniquement les besoins validés de PaperNest.
- Ne coder aucune variante métier ou couleur PaperNest en dur dans Flutter.
- Garder toute la personnalisation pilotable depuis Python.
- Ne modifier aucun autre contrôle pendant ce chantier.
- Ne migrer PaperNest qu’après validation complète dans PaperNestExtension.

## Phase 1 — Base Flet copiée et renommée

### Python

- [x] Créer `controls/material/papernest_button.py` depuis `button.py`.
- [x] Renommer `Button` en `PaperNestButton`.
- [x] Conserver `LayoutControl`, `AdaptiveControl`, la validation et `focus()`.
- [x] Créer `controls/papernest_button_style.py` depuis la partie utile de `buttons.py`.
- [x] Renommer `ButtonStyle` en `PaperNestButtonStyle`.
- [x] Conserver les formes natives de Flet sans les recopier.
- [x] Conserver `before_update()` et la fusion de `color`, `bgcolor` et `elevation`.

### Flutter

- [x] Créer `controls/papernest_button.dart` depuis `button.dart`.
- [x] Renommer `ButtonControl` en `PaperNestButtonControl`.
- [x] Créer `utils/papernest_button_style.dart` depuis le parseur Flet.
- [x] Renommer le parseur en `parsePaperNestButtonStyle()`.
- [x] Conserver les boutons Material avec et sans icône.
- [x] Conserver focus, URL, clic, appui long, survol et `LayoutControl`.
- [x] Supprimer l’ancien prototype `papernest_button_surface.dart`.

## Phase 2 — Gradient par état

### API retenue

```python
PaperNestButton(
    content="Enregistrer",
    icon=ft.Icons.SAVE_ROUNDED,
    style=PaperNestButtonStyle(
        gradient={
            ft.ControlState.DEFAULT: ft.LinearGradient(...),
            ft.ControlState.HOVERED: ft.LinearGradient(...),
            ft.ControlState.FOCUSED: ft.LinearGradient(...),
            ft.ControlState.PRESSED: ft.LinearGradient(...),
            ft.ControlState.DISABLED: ft.LinearGradient(...),
        },
    ),
)
```

### Python

- [x] Ajouter `gradient: Optional[ControlStateValue[Gradient]]`.
- [x] Ajouter `gradient` à `PaperNestButtonStyle.copy()`.
- [x] Ne pas ajouter une seconde API `gradient_hover` dans `PaperNestButton`.

### Flutter

- [x] Parser le gradient avec `getWidgetStateProperty<Gradient?>()` et `parseGradient()`.
- [x] Créer `ParsedPaperNestButtonStyle` contenant le `ButtonStyle` natif et le gradient par état.
- [x] Utiliser les états réels du bouton via `WidgetStatesController`.
- [x] Résoudre `DEFAULT`, `HOVERED`, `FOCUSED`, `PRESSED` et `DISABLED` avec le mécanisme Flet existant.
- [x] Rendre le fond Material transparent uniquement lorsqu’un gradient est résolu.
- [x] Garder `bgcolor` comme fallback lorsqu’aucun gradient n’est résolu.
- [x] Faire suivre au gradient la `shape` résolue par le style.
- [x] Garder ripple, overlay, bordure, élévation, focus et accessibilité sur le bouton Material natif.
- [x] Confirmer la sérialisation par compilation Flutter réussie.
- [ ] Vérifier visuellement les transitions entre gradients compatibles et différents.
- [ ] Vérifier visuellement le fallback gradient → `bgcolor`.

## Phase 3 — API supplémentaire

### Chargement

- [x] Ajouter `loading`.
- [x] Ajouter `loading_text`.
- [x] Ajouter `loading_indicator_color`.
- [x] Ajouter `loading_indicator_size`.
- [x] Ajouter `loading_indicator_stroke_width`.
- [x] Ajouter `set_loading()` côté Python.
- [x] Désactiver le clic et l’appui long pendant le chargement.
- [x] Remplacer temporairement l’icône par un indicateur.
- [x] Remplacer le contenu par `loading_text` uniquement lorsqu’il est renseigné.
- [ ] Vérifier la stabilité des dimensions dans l’exemple.

### Animations

- [x] Ajouter `hover_scale` et `hover_offset_y`.
- [x] Ajouter `click_scale` et `click_offset_y`.
- [x] Ajouter `animation_duration` et `animation_curve`.
- [x] Piloter les animations avec les véritables états `hovered` et `pressed`.
- [x] Neutraliser les animations lorsque le bouton est désactivé ou en chargement.
- [x] Conserver le ripple et le comportement Material natif.

### Propriétés natives préservées

- [x] `content`, `icon`, `icon_color`.
- [x] `color`, `bgcolor`, `elevation`, `style`.
- [x] `autofocus`, `clip_behavior`, `url`.
- [x] `on_click`, `on_long_press`, `on_hover`, `on_focus`, `on_blur`.
- [x] Validation du contenu ou de l’icône.
- [x] `focus()` et `before_update()`.

## Phase 4 — Implémentation Flutter

- [x] Conserver la structure issue de `ButtonControl`.
- [x] Conserver les constructeurs Material natifs avec et sans icône.
- [x] Partager un seul `WidgetStatesController` entre le bouton, le gradient et les animations.
- [x] Ajouter une `ShapeDecoration` animée autour du bouton.
- [x] Garder cette surface présente avec ou sans gradient pour permettre les transitions.
- [x] Utiliser `AnimatedContainer`, `AnimatedScale` et `AnimatedSlide`.
- [x] Ne modifier aucune contrainte de layout directement.
- [x] Ne coder aucune variante ou palette en dur.
- [x] Compiler Flutter sans erreur.
- [ ] Vérifier visuellement que la forme, le clipping et le ripple coïncident parfaitement.
- [ ] Vérifier focus clavier, souris, disabled et accessibilité.

## Phase 5 — Exports et enregistrement

- [x] Vérifier l’enregistrement de `PaperNestButton` dans `Extension.createWidget()`.
- [x] Vérifier l’export public de `PaperNestButton`.
- [x] Exporter `PaperNestButtonStyle` depuis `controls.material`, `controls` et le package principal.
- [x] Vérifier que l’ancien `PaperNestButtonVariant` n’est plus exporté.
- [x] Vérifier que l’ancien prototype Flutter a été supprimé.

## Phase 6 — Application d’exemple

La page `Actions` utilise uniquement des propriétés Python et `PaperNestButtonStyle`.

- [x] Bouton natif sans ajout PaperNest.
- [x] Bouton avec `bgcolor` uniquement.
- [x] Bouton avec gradient linéaire unique.
- [x] Bouton avec gradient radial unique.
- [x] Bouton avec gradients `DEFAULT`, `HOVERED`, `FOCUSED` et `PRESSED`.
- [x] Bouton avec gradient `DISABLED`.
- [x] Bouton avec animation de survol.
- [x] Bouton avec animation de clic.
- [x] Bouton combinant gradient, hover et clic.
- [x] Bouton en chargement avec `loading_text`.
- [x] Bouton en chargement sans `loading_text`.
- [x] Bouton désactivé.
- [x] Boutons avec et sans icône.
- [x] Boutons avec forme, padding, bordure et curseur personnalisés.
- [x] Vérifier dans le code que tout le style est défini côté Python.

## Phase 7 — Validation PaperNestExtension

- [ ] Vérifier les imports Python après export de `PaperNestButtonStyle`.
- [x] Vérifier la compilation Flutter des phases 2 à 4.
- [ ] Valider `flet run` avec la nouvelle page `Actions`.
- [ ] Valider les gradients et leurs transitions.
- [ ] Valider le fallback vers `bgcolor`.
- [ ] Valider hover, clic, focus, clavier et curseur.
- [ ] Valider loading et disabled.
- [ ] Vérifier l’absence de décalage de layout.
- [ ] Valider le build Windows avec la nouvelle page d’exemple.
- [ ] Faire valider visuellement et fonctionnellement le contrôle par l’utilisateur.

## Phase 8 — Intégration PaperNest

Cette phase ne commence qu’après validation complète de PaperNestExtension.

- [ ] Auditer les boutons actuels de PaperNest.
- [ ] Définir les wrappers et variantes uniquement côté Python.
- [ ] Préserver texte, icône, loading, compact, largeur, hauteur et expansion.
- [ ] Garder `IconAction` et `MenuAction` hors de ce chantier.
- [ ] Migrer progressivement les usages.
- [ ] Supprimer les anciens wrappers uniquement après validation.
- [ ] Valider `flet run --recursive` et le build Windows de PaperNest.

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

`PaperNestButton` sera terminé uniquement lorsque les gradients par état, le chargement et les animations fonctionneront sans casser le comportement Material natif, que l’exemple et les builds Windows seront validés, puis que l’intégration PaperNest aura été testée et approuvée.
