# Roadmap — PaperNestAlertDialog

## État

**Phases 1 à 5 implémentées dans PaperNestExtension. Phase 6 en attente de validation.**

L’ancienne architecture fondée sur `PaperNestDialogSurface` et les variants a été remplacée, pour le contrôle public, par un fork direct des sources Flet `AlertDialog` fournies par l’utilisateur.

## Références obligatoires

- [x] Lire `docs/README_DEVELOPMENT.md`.
- [x] Lire `docs/RULES.md`.
- [x] Étudier l’ancienne apparence PaperNest dans `src/app/theme/dialogs.py`, avant le commit `643c7bc870bd79c3060d659cfaf39aea38f2ffbf`.
- [x] Recevoir et lire intégralement la source Python Flet de `AlertDialog`.
- [x] Recevoir et lire intégralement la source Flutter Flet de `AlertDialog`.
- [x] Recevoir et étudier `dialog_control.py`.
- [x] Confirmer qu’aucun fichier `dialog_control.dart` n’existe ou n’est nécessaire.
- [x] Étudier le cycle de vie natif : ouverture, fermeture, route, modalité, barrière et événement `dismiss`.

## Principe directeur

`PaperNestAlertDialog` est un fork de `AlertDialog`, pas un système autonome composé de widgets PaperNest.

- [x] Python contrôle entièrement la composition et l’apparence.
- [x] Flutter conserve le comportement natif de Flet.
- [x] Aucun variant métier n’est connu de Flutter.
- [x] Aucun picker n’est ouvert ou construit par le dialogue.
- [x] Les actions restent de véritables contrôles Python, notamment `PaperNestButton`.

## Apparence de référence

```text
+--------------------------------------------------------------+
|  [ pastille icône ]  titre / sous-titre      [title_action] |
+--------------------------------------------------------------+
|                                                              |
|  contenu                                                     |
|                                                              |
+--------------------------------------------------------------+
|                                      [Annuler] [Confirmer]   |
+--------------------------------------------------------------+
```

### En-tête

- [x] Fond piloté par `header_bgcolor`.
- [x] Padding piloté par `header_padding`.
- [x] Pastille d’icône facultative.
- [x] Icône, couleur, fond, taille et rayon pilotés depuis Python.
- [x] Titre sous forme de chaîne ou de contrôle Python.
- [x] Sous-titre sous forme de chaîne ou de contrôle Python.
- [x] `title_action` facultatif à droite.
- [x] Aucun variant ni aucune palette codée côté Flutter.
- [ ] Valider visuellement le clipping des coins supérieurs avec la forme du dialogue.

### Contenu

- [x] Fond du dialogue personnalisable.
- [x] Largeur pilotée depuis Python.
- [x] Hauteur naturelle pour un contenu ordinaire.
- [x] Hauteur maximale facultative.
- [x] Scroll natif lorsque demandé ou lorsqu’une hauteur maximale est fournie.
- [x] Padding personnalisable.
- [ ] Valider l’absence d’espace vide artificiel.

### Actions

- [x] Liste de contrôles Python rendus tels quels.
- [x] Compatibilité avec `PaperNestButton`.
- [x] Alignement, padding et espacement pilotés depuis Python.
- [x] Actions confiées au `AlertDialog` Material natif.
- [ ] Valider que les actions restent visibles avec le contenu scrollable.

## Absence totale de variants

Supprimés de l’API et des exports :

```text
PaperNestDialogVariant
variant
standard
primary
success
warning
danger
```

Les variantes applicatives seront reconstruites uniquement dans PaperNest.

## Phase 1 — Étude des sources Flet

- [x] Lire intégralement la source Python.
- [x] Lire intégralement la source Flutter.
- [x] Identifier les imports internes indispensables.
- [x] Identifier les propriétés natives à conserver.
- [x] Identifier la sérialisation du titre, du contenu et des actions.
- [x] Identifier le mécanisme d’ouverture et de fermeture.
- [x] Identifier la gestion native de `modal`, `barrier_color`, `scrollable` et `inset_padding`.
- [x] Vérifier forme, ombre, clipping et élévation.

## Phase 2 — Copie et renommage des sources

### Python

Fichier :

```text
src/papernestextension/controls/material/papernest_alert_dialog.py
```

- [x] Remplacer l’ancienne implémentation par une copie issue de la source Flet.
- [x] Renommer le contrôle en `PaperNestAlertDialog`.
- [x] Conserver les propriétés natives de `AlertDialog`.
- [x] Hériter de `DialogControl`.
- [x] Ne reprendre aucun variant.

Commit principal :

```text
44caa1faba048c9ce9e625e8d32e7b200738565b
```

### Flutter

Fichier :

```text
src/flutter/papernestextension/lib/src/controls/papernest_alert_dialog.dart
```

- [x] Remplacer l’ancienne implémentation par une copie issue de la source Flet.
- [x] Conserver la route propre à chaque dialogue.
- [x] Conserver l’ouverture différée, la fermeture et l’attente de fin d’animation.
- [x] Conserver la barrière mise à jour en direct.
- [x] Conserver l’événement `dismiss`.
- [x] Ne créer aucune dépendance vers les pickers.

Commit principal :

```text
595f68cbc2029f5d2299f5e167a626e94fcae8af
```

## Phase 3 — API Python supplémentaire

### Header

- [x] `header_bgcolor`.
- [x] `header_padding`.
- [x] `header_spacing`.
- [x] `icon`, `icon_bgcolor`, `icon_color`, `icon_size`.
- [x] `icon_container_size`, `icon_border_radius`.
- [x] `title`, `subtitle`, `title_action`.
- [x] `title_text_style`, `subtitle_text_style`.

### Surface et dimensions

- [x] `width`, `max_height`.
- [x] `bgcolor`, `shape`, `shadow_color`, `elevation`.
- [x] `barrier_color`, `inset_padding`, `clip_behavior`.

### Contenu et actions

- [x] `content`, `content_padding`, `scrollable`.
- [x] `actions`, `actions_alignment`, `actions_padding`.
- [x] `actions_spacing`.

### Comportement

- [x] `modal`, `dismissible`, `open`, `on_dismiss`.

## Phase 4 — Rendu Flutter PaperNest

- [x] Construire un header uniquement lorsque les propriétés PaperNest sont utilisées.
- [x] Conserver le titre natif pour un dialogue minimal sans personnalisation du header.
- [x] Rendre `title`, `subtitle` et `title_action` depuis Python.
- [x] Rendre la pastille d’icône depuis Python.
- [x] Préserver le `AlertDialog` Material natif.
- [x] Préserver la hauteur naturelle du contenu.
- [x] Activer le scroll natif pour `scrollable` ou `max_height`.
- [x] Préserver ombre, élévation et clipping natifs.
- [x] Ne coder aucune palette PaperNest dans Flutter.
- [x] Ne créer aucun bouton Flutter pour les actions.

## Phase 5 — Exports et exemple PaperNestExtension

- [x] Conserver l’enregistrement existant de `PaperNestAlertDialog` dans `Extension.createWidget()`.
- [x] Exporter `PaperNestAlertDialog` depuis le package Python.
- [x] Supprimer tous les exports de `PaperNestDialogVariant`.
- [ ] Supprimer `PaperNestDialogSurface` après validation du nouveau fork et migration des pickers.
- [x] Reconstruire la page `Dialogues` sans variants.

### Cas présents dans l’exemple

- [x] Dialogue avec titre seul.
- [x] Header avec icône et titre.
- [x] Header avec titre et sous-titre.
- [x] Header avec `title_action`.
- [x] Actions `PaperNestButton` fournies depuis Python.
- [x] Contenu court.
- [x] Formulaire de hauteur naturelle.
- [x] Contenu long scrollable.
- [x] Largeur et hauteur maximale personnalisées.
- [x] Dialogue modal.
- [x] Dialogue fermable par clic extérieur.
- [x] Dialogue non fermable par clic extérieur.
- [x] Couleurs, paddings, forme, ombre et élévation personnalisés.

Commit principal de l’exemple :

```text
ca0a2b886b5c0c6d21a9341d611f5d6be5aa1d5e
```

## Phase 6 — Validation PaperNestExtension

- [ ] Vérifier les imports Python.
- [ ] Compiler Flutter.
- [ ] Valider `flet run`.
- [ ] Vérifier les ouvertures et fermetures successives.
- [ ] Vérifier la modalité et la barrière.
- [ ] Vérifier le clic extérieur.
- [ ] Vérifier les actions Python.
- [ ] Vérifier la hauteur naturelle.
- [ ] Vérifier le contenu scrollable.
- [ ] Vérifier la forme, l’ombre, l’élévation et le clipping.
- [ ] Valider le build Windows.
- [ ] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 7 — Intégration PaperNest

Cette phase ne commence qu’après validation complète dans PaperNestExtension.

- [ ] Faire hériter `AppDialog` du nouveau `PaperNestAlertDialog`.
- [ ] Reproduire les palettes et variantes uniquement côté Python.
- [ ] Conserver ou supprimer `ConfirmDialog`, `DangerDialog` et `FormDialog` après audit.
- [ ] Utiliser les wrappers `PaperNestButton` dans les actions.
- [ ] Supprimer l’ancien alias `PaperNestDialogVariant`.
- [ ] Auditer tous les dialogues applicatifs.
- [ ] Valider `flet run --recursive` et le build Windows.

## Phase 8 — Utilisation par les pickers

- [ ] `PaperNestColorPicker` ne fournit que son contenu de sélection.
- [ ] `PaperNestIconPicker` ne fournit que son contenu de sélection.
- [ ] Les dialogues de picker sont composés côté Python.
- [ ] Les boutons d’ouverture sont fournis à `PickerTextField`.
- [ ] Aucun picker n’ouvre son propre dialogue Flutter.
- [ ] Aucun picker ne crée ses propres actions Flutter.

## Hors périmètre

- Variants codés dans l’extension.
- Palettes PaperNest codées dans Flutter.
- Ouverture automatique d’un ColorPicker ou IconPicker.
- DatePicker natif.
- FilePicker natif.
- Refonte de `PaperNestTextField`.
- Refonte de `PaperNestButton`.

## Critère de finalisation

`PaperNestAlertDialog` sera terminé lorsque le fork conservera le comportement natif de Flet, reproduira l’apparence historique de PaperNest avec une API entièrement pilotée depuis Python, ne contiendra aucun variant Flutter, puis sera validé dans PaperNestExtension et PaperNest sans dépendance interne aux pickers.
