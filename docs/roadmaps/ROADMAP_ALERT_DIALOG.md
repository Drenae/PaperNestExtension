# Roadmap — PaperNestAlertDialog

## État

**Phase 6 validée. Phase 7 implémentée dans PaperNest et en attente de validation applicative. Phase 8 volontairement bloquée.**

`PaperNestAlertDialog` est désormais un fork direct de `AlertDialog` Flet. Il conserve le cycle de vie natif et expose une apparence entièrement pilotée depuis Python, sans variant dans l’extension.

## Principes validés

- [x] Conserver le cycle de vie natif de Flet : route, ouverture, fermeture, barrière et événement `dismiss`.
- [x] Piloter toute l’apparence depuis Python.
- [x] Ne connaître aucun variant métier dans PaperNestExtension.
- [x] Rendre les actions comme de véritables contrôles Python.
- [x] Ne créer aucun bouton Flutter spécifique.
- [x] Ne créer aucune dépendance du dialogue vers les pickers.

## API validée

### En-tête

- [x] `header_bgcolor`, `header_padding`, `header_spacing`.
- [x] `icon`, `icon_bgcolor`, `icon_color`, `icon_size`.
- [x] `icon_container_size`, `icon_border_radius`.
- [x] `title`, `subtitle`, `title_action`.
- [x] `title_text_style`, `subtitle_text_style`.

### Surface

- [x] `width`, `max_height`, `bgcolor`, `shape`.
- [x] `shadow_color`, `elevation`, `barrier_color`.
- [x] `inset_padding`, `clip_behavior`.

### Contenu et actions

- [x] `content`, `content_padding`, `scrollable`.
- [x] `actions`, `actions_alignment`, `actions_padding`, `actions_spacing`.
- [x] Header et actions fixes lorsque le contenu défile.
- [x] Seul le contenu est placé dans `SingleChildScrollView`.

### Comportement

- [x] `modal`, `dismissible`, `open`, `on_dismiss`.

## Phase 1 — Étude des sources

- [x] Étudier `alert_dialog.py`.
- [x] Étudier `alert_dialog.dart`.
- [x] Étudier `dialog_control.py`.
- [x] Identifier les imports et comportements natifs à conserver.

## Phase 2 — Fork des sources Flet

- [x] Remplacer le contrôle Python par une copie renommée de `AlertDialog`.
- [x] Remplacer le contrôle Flutter par une copie renommée de `AlertDialogControl`.
- [x] Conserver la route propre à chaque dialogue.
- [x] Conserver la fermeture après animation.
- [x] Supprimer `PaperNestDialogVariant` et `variant` de l’extension.

## Phase 3 — API PaperNest

- [x] Ajouter l’API d’en-tête.
- [x] Ajouter les dimensions et la hauteur maximale.
- [x] Ajouter l’espacement des actions.
- [x] Conserver les propriétés natives de Flet.

## Phase 4 — Rendu Flutter

- [x] Construire le header PaperNest uniquement lorsqu’il est utilisé.
- [x] Conserver le titre natif pour un dialogue minimal.
- [x] Appliquer les styles reçus depuis Python.
- [x] Conserver le `AlertDialog` Material natif.
- [x] Maintenir le header et les actions fixes pendant le scroll.
- [x] Ne coder aucune palette dans Flutter.

## Phase 5 — Exports et exemple

- [x] Enregistrer `PaperNestAlertDialog` dans l’extension Flutter.
- [x] Exporter le contrôle côté Python.
- [x] Supprimer tous les exports de `PaperNestDialogVariant`.
- [x] Reconstruire la page d’exemple sans variants.
- [x] Tester titre, sous-titre, icône, `title_action`, formulaire et contenu long.
- [ ] Supprimer `PaperNestDialogSurface` après la refonte complète des pickers.

## Phase 6 — Validation PaperNestExtension

- [x] Vérifier les imports Python.
- [x] Compiler Flutter sans erreur.
- [x] Valider `flet run --recursive`.
- [x] Vérifier les ouvertures et fermetures successives.
- [x] Vérifier la modalité et la barrière.
- [x] Vérifier le clic extérieur.
- [x] Vérifier les actions Python.
- [x] Vérifier la hauteur naturelle.
- [x] Vérifier que seul le contenu scrollable défile.
- [x] Vérifier la forme, l’ombre, l’élévation et le clipping.
- [x] Valider le build Windows.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.

## Phase 7 — Intégration PaperNest

- [x] Faire hériter `AppDialog` du nouveau `PaperNestAlertDialog`.
- [x] Recréer `DialogVariant` uniquement dans PaperNest.
- [x] Gérer les palettes exclusivement côté Python.
- [x] Ne plus transmettre de variant à PaperNestExtension.
- [x] Conserver `ConfirmDialog`, `DangerDialog` et `FormDialog`.
- [x] Conserver les wrappers PaperNestButton dans les actions.
- [x] Conserver la compatibilité des imports applicatifs existants.
- [x] Ajouter `subtitle`, `max_height` et les nouveaux paramètres visuels au wrapper.
- [ ] Valider `flet run --recursive` dans PaperNest.
- [ ] Valider tous les dialogues applicatifs.
- [ ] Valider le build Windows de PaperNest.
- [ ] Validation visuelle et fonctionnelle par l’utilisateur.

## Phase 8 — Utilisation par les pickers

**Bloquée jusqu’à la refonte de `PaperNestColorPicker`, `PaperNestIconPicker` et `PaperNestDatePicker`.**

- [ ] Refaire `PaperNestColorPicker` comme contenu de sélection uniquement.
- [ ] Refaire `PaperNestIconPicker` comme contenu de sélection uniquement.
- [ ] Remplacer `PaperNestDatePicker` par le contrôle natif si confirmé.
- [ ] Composer les dialogues de picker côté Python.
- [ ] Utiliser `PickerTextField` pour les boutons d’ouverture.
- [ ] Supprimer `PaperNestDialogSurface` après les migrations.

## Critère de finalisation

`PaperNestAlertDialog` sera clôturé après validation de la phase 7 dans PaperNest. La phase 8 reste un chantier séparé dépendant de la refonte des pickers.
