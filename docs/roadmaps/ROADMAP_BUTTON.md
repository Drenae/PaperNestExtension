# Roadmap — PaperNestButton

## État

**TERMINÉ — validé dans PaperNestExtension et intégré dans PaperNest.**

`PaperNestButton` et `PaperNestButtonStyle` repartent des sources Flet `Button` et `ButtonStyle`, copiées et renommées. Le contrôle conserve le comportement Material natif et ajoute uniquement les besoins validés de PaperNest : gradient, chargement et animations.

Les tests `flet run`, la compilation Flutter, le build Windows, les gradients, les animations, le chargement et l’intégration PaperNest ont été validés par l’utilisateur.

## Références obligatoires

- [x] Lire `docs/README_DEVELOPMENT.md`.
- [x] Lire `docs/RULES.md`.
- [x] Étudier les sources Flet Python `button.py` et `buttons.py`.
- [x] Étudier les sources Flet Flutter `button.dart` et `buttons.dart`.
- [x] Étudier `container.dart` pour le rendu du gradient.
- [x] Étudier `ControlStateValue`, `WidgetStateProperty`, `parseGradient()` et l’interpolation Flutter des gradients.
- [x] Vérifier l’existence de `WidgetStatesController` sur les boutons Material.

## Principes respectés

- [x] Partir des sources Flet et conserver leur comportement natif.
- [x] Ajouter uniquement les besoins validés de PaperNest.
- [x] Ne coder aucune variante métier ou couleur PaperNest en dur dans Flutter.
- [x] Garder toute la personnalisation pilotable depuis Python.
- [x] Définir les variantes PaperNest uniquement dans les wrappers Python de l’application.
- [x] Ne migrer PaperNest qu’après validation complète dans PaperNestExtension.

## Phase 1 — Base Flet copiée et renommée

### Python

- [x] Créer `controls/material/papernest_button.py` depuis `button.py`.
- [x] Renommer `Button` en `PaperNestButton`.
- [x] Conserver `LayoutControl`, `AdaptiveControl`, la validation et `focus()`.
- [x] Créer `controls/papernest_button_style.py` depuis la partie utile de `buttons.py`.
- [x] Renommer `ButtonStyle` en `PaperNestButtonStyle`.
- [x] Conserver les formes natives de Flet sans les recopier.
- [x] Conserver `before_update()` et la fusion de `color`, `bgcolor`, `elevation` et `gradient`.

### Flutter

- [x] Créer `controls/papernest_button.dart` depuis `button.dart`.
- [x] Renommer `ButtonControl` en `PaperNestButtonControl`.
- [x] Créer `utils/papernest_button_style.dart` depuis le parseur Flet.
- [x] Renommer le parseur en `parsePaperNestButtonStyle()`.
- [x] Conserver les boutons Material avec et sans icône.
- [x] Conserver focus, URL, clic, appui long, survol et `LayoutControl`.
- [x] Supprimer l’ancien prototype `papernest_button_surface.dart`.

## Phase 2 — Gradient

### API

- [x] Ajouter `gradient` directement à `PaperNestButton`.
- [x] Ajouter `gradient: ControlStateValue[Gradient]` à `PaperNestButtonStyle`.
- [x] Ajouter `gradient` à `PaperNestButtonStyle.copy()`.
- [x] Donner la priorité au gradient direct du bouton lors de la fusion dans `before_update()`.
- [x] Ne pas créer une seconde API parallèle `gradient_hover`.

### Flutter

- [x] Parser les gradients avec `getWidgetStateProperty<Gradient?>()` et `parseGradient()`.
- [x] Utiliser les véritables états Material via `WidgetStatesController`.
- [x] Supporter notamment `DEFAULT`, `HOVERED` et `DISABLED`.
- [x] Conserver les autres états natifs Flet sans les imposer dans l’exemple.
- [x] Rendre le fond Material transparent lorsqu’un gradient est résolu.
- [x] Garder `bgcolor` comme fallback lorsqu’aucun gradient n’est résolu.
- [x] Faire suivre au gradient la `shape` résolue par le style.
- [x] Conserver ripple, overlay, bordure, focus, clavier, souris et accessibilité.
- [x] Rendre gradient et élévation compatibles sans assombrir les couleurs.
- [x] Mettre l’élévation interne Material à zéro lorsqu’un gradient est actif.
- [x] Reporter l’ombre sur une `PhysicalShape` externe avec la même forme, la même élévation et la même couleur d’ombre.

## Phase 3 — Chargement et animations

### Chargement

- [x] Ajouter `loading`.
- [x] Ajouter `loading_text`.
- [x] Ajouter `loading_indicator_color`.
- [x] Ajouter `loading_indicator_size`.
- [x] Ajouter `loading_indicator_stroke_width`.
- [x] Ajouter `set_loading()` côté Python.
- [x] Désactiver clic et appui long pendant le chargement.
- [x] Remplacer temporairement l’icône par un indicateur.
- [x] Remplacer le contenu uniquement lorsque `loading_text` est renseigné.
- [x] Valider le rendu avec et sans `loading_text`.

### Animation de survol

- [x] Ajouter `hover_scale`.
- [x] Ajouter `hover_offset_y`.
- [x] Ajouter `animation_duration` et `animation_curve`.
- [x] Piloter l’animation avec l’état Material `hovered`.
- [x] Neutraliser l’animation lorsque le bouton est désactivé ou en chargement.

### Animation de clic

- [x] Ajouter `click_scale`.
- [x] Ajouter `click_offset_y`.
- [x] Détecter directement `pointerDown`, `pointerUp` et `pointerCancel`.
- [x] Garantir une durée minimale visible même avec une souris à clic très rapide.
- [x] Ne pas retarder l’événement `on_click`.
- [x] Conserver le ripple Material natif.

## Phase 4 — Exports et exemple

- [x] Enregistrer `PaperNestButton` dans `Extension.createWidget()`.
- [x] Exporter `PaperNestButton` depuis les modules publics.
- [x] Exporter `PaperNestButtonStyle` depuis les modules publics.
- [x] Supprimer les anciens exports et prototypes.
- [x] Ajouter la page `Actions` à l’application d’exemple.
- [x] Tester un bouton natif.
- [x] Tester `bgcolor` seul.
- [x] Tester un gradient direct sur `PaperNestButton`.
- [x] Tester un gradient dans `PaperNestButtonStyle`.
- [x] Tester les gradients par état utiles.
- [x] Tester hover, clic, loading, disabled, formes, bordures et curseurs.

## Phase 5 — Validation PaperNestExtension

- [x] Vérifier les imports Python.
- [x] Compiler Flutter sans erreur.
- [x] Valider `flet run`.
- [x] Valider les gradients directs et via style.
- [x] Valider `DEFAULT`, `HOVERED` et `DISABLED`.
- [x] Valider le fallback vers `bgcolor`.
- [x] Valider l’animation hover.
- [x] Valider l’animation de clic rapide.
- [x] Valider loading et disabled.
- [x] Vérifier l’absence de décalage de layout.
- [x] Valider le build Windows.
- [x] Faire valider visuellement et fonctionnellement le contrôle par l’utilisateur.

## Phase 6 — Intégration PaperNest

- [x] Auditer les wrappers actuels de `app/theme/buttons.py`.
- [x] Faire hériter `AppButton` de `PaperNestButton`.
- [x] Préserver texte, icône, loading, compact, largeur, hauteur, expansion et tooltip.
- [x] Définir les variantes uniquement côté Python.
- [x] Ajouter les variantes foncées nécessaires dans `tokens.py`.
- [x] Centraliser les gradients avec `AppTheme.button_gradient()`.
- [x] Migrer `PrimaryButton`, `SecondaryButton`, `SuccessButton`, `DangerButton` et `OutlineButton`.
- [x] Conserver `GhostButton` transparent.
- [x] Garder `IconAction` et `MenuAction` hors de ce chantier.
- [x] Valider PaperNest avec `flet run --recursive`.
- [x] Valider le rendu des boutons dans PaperNest.
- [x] Valider gradient + élévation dans PaperNest.
- [x] Valider le build Windows de PaperNest.

## Hors périmètre

- `PaperNestTextField`.
- `PaperNestAlertDialog`.
- `PaperNestColorPicker`.
- `PaperNestIconPicker`.
- `PaperNestDatePicker`.
- `PaperNestFilePicker`.
- `IconAction` et `MenuAction`.

## Conclusion

`PaperNestButton` est officiellement terminé. Il reste une surcouche fidèle au bouton Material de Flet, entièrement configurable depuis Python, avec gradients, chargement, animations et élévation compatibles.