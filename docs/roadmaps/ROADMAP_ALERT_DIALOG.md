# Roadmap — PaperNestAlertDialog

## État

**Nouvelle architecture à valider avant implémentation.**

L’implémentation actuelle doit être abandonnée et remplacée par un véritable fork de `AlertDialog`, construit à partir des sources Flet Python et Flutter fournies par l’utilisateur.

Aucun code ne doit être modifié avant :

1. réception et étude des sources Flet ;
2. validation de cette roadmap ;
3. validation de l’API définitive.

## Références obligatoires

- [x] Lire `docs/README_DEVELOPMENT.md`.
- [x] Lire `docs/RULES.md`.
- [x] Étudier l’ancienne apparence PaperNest dans `src/app/theme/dialogs.py`, avant le commit `643c7bc870bd79c3060d659cfaf39aea38f2ffbf`.
- [ ] Recevoir la source Python Flet de `AlertDialog`.
- [ ] Recevoir la source Flutter Flet de `AlertDialog`.
- [ ] Recevoir les éventuels fichiers complémentaires réellement requis par ces sources.
- [ ] Étudier le cycle de vie natif : ouverture, fermeture, route, modalité, barrière, focus et événements.

## Principe directeur

`PaperNestAlertDialog` doit être un fork de `AlertDialog`, pas un système de dialogue autonome construit autour de plusieurs widgets PaperNest.

- Python contrôle entièrement la composition et l’apparence.
- Flutter conserve le comportement natif de Flet et ajoute uniquement la structure visuelle impossible à obtenir proprement avec l’API native.
- Aucun variant métier n’est connu de Flutter.
- Aucun picker n’est ouvert ou construit par `PaperNestAlertDialog`.
- Les actions restent de véritables contrôles Python, notamment `PaperNestButton`.

## Apparence de référence

Le rendu doit reproduire l’ancien `AppDialog` PaperNest :

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

- fond sombre ;
- coins supérieurs suivant la forme du dialogue ;
- padding horizontal et vertical personnalisable ;
- pastille d’icône facultative ;
- icône, couleur, fond, taille et rayon pilotés depuis Python ;
- titre sous forme de chaîne ou de contrôle Python ;
- sous-titre facultatif sous forme de chaîne ou de contrôle Python ;
- `title_action` facultatif à droite ;
- aucun variant ni aucune palette codée côté Flutter.

### Contenu

- fond du dialogue personnalisable ;
- largeur pilotée depuis Python ;
- hauteur naturelle pour un contenu ordinaire ;
- hauteur maximale facultative ;
- scroll uniquement lorsqu’il est demandé ou nécessaire ;
- padding personnalisable ;
- aucun espace vide artificiel entre le contenu et les actions.

### Actions

- liste de contrôles Python rendus tels quels ;
- compatibilité complète avec `PaperNestButton` et ses wrappers ;
- alignement, espacement et padding pilotés depuis Python ;
- actions placées juste sous le contenu lorsque celui-ci utilise sa hauteur naturelle ;
- actions maintenues visibles lorsque le contenu est scrollable.

## Absence totale de variants

À supprimer de l’API et du Flutter :

```text
PaperNestDialogVariant
variant
standard
primary
success
warning
danger
```

Les variantes applicatives seront construites uniquement dans PaperNest, par exemple :

```python
class DangerDialog(AppDialog):
    def __init__(self, **kwargs):
        kwargs.setdefault("icon_bgcolor", AppColors.ERROR)
        kwargs.setdefault("icon_color", AppColors.TEXT_LIGHT)
        super().__init__(**kwargs)
```

`PaperNestAlertDialog` ne doit jamais savoir qu’un dialogue est « danger », « succès » ou « principal ».

## Phase 1 — Étude des sources Flet

Après réception des fichiers :

- [ ] Lire intégralement la source Python.
- [ ] Lire intégralement la source Flutter.
- [ ] Identifier les imports internes indispensables.
- [ ] Identifier les propriétés natives à conserver sans modification.
- [ ] Identifier la sérialisation du titre, du contenu, des actions et des événements.
- [ ] Identifier le mécanisme d’ouverture et de fermeture.
- [ ] Identifier la gestion native de `modal`, `barrier_color`, `dismissible`, `scrollable` et `inset_padding`.
- [ ] Vérifier comment la forme, l’ombre, le clipping et l’élévation sont appliqués.
- [ ] Ne commencer aucun fork avant la conclusion de cette étude.

## Phase 2 — Copie et renommage des sources

Les chemins exacts seront confirmés après étude des sources.

### Python

Créer une copie renommée, prévue sous :

```text
src/papernestextension/controls/material/papernest_alert_dialog.py
```

- [ ] Copier la source Flet sans supprimer de comportement natif.
- [ ] Renommer le contrôle en `PaperNestAlertDialog`.
- [ ] Conserver les propriétés natives de `AlertDialog`.
- [ ] Conserver les événements et méthodes natives.
- [ ] Ne pas reprendre l’ancienne API de variants.

### Flutter

Créer une copie renommée, prévue sous :

```text
src/flutter/papernestextension/lib/src/controls/papernest_alert_dialog.dart
```

- [ ] Copier la source Flet sans reconstruire son cycle de vie.
- [ ] Renommer le contrôle Flutter.
- [ ] Conserver route, modalité, barrière, focus, fermeture et événements.
- [ ] Ne créer aucune dépendance vers les pickers.
- [ ] Supprimer l’ancienne architecture `PaperNestDialogSurface` une fois le remplacement validé.

## Phase 3 — API Python supplémentaire

L’API définitive devra être figée après étude des sources. Les besoins validés sont les suivants.

### Header

```python
header_bgcolor
header_padding
icon
icon_bgcolor
icon_color
icon_size
icon_container_size
icon_border_radius
title
subtitle
title_action
title_text_style
subtitle_text_style
header_spacing
```

### Surface et dimensions

```python
width
max_height
bgcolor
shape
shadow_color
elevation
barrier_color
inset_padding
clip_behavior
```

### Contenu et actions

```python
content
content_padding
scrollable
actions
actions_alignment
actions_padding
actions_spacing
```

### Comportement

Conserver les propriétés natives pertinentes, notamment :

```python
modal
dismissible
open
on_dismiss
```

Les noms exacts devront rester cohérents avec la source Flet fournie.

## Phase 4 — Rendu Flutter PaperNest

- [ ] Construire un header interne uniquement lorsque les propriétés de header sont utilisées.
- [ ] Rendre `title`, `subtitle` et `title_action` à partir des contrôles Python.
- [ ] Rendre la pastille d’icône avec les valeurs Python.
- [ ] Faire suivre au header les coins supérieurs de la forme du dialogue.
- [ ] Préserver la hauteur naturelle du contenu.
- [ ] Réserver `Flexible` ou `Expanded` aux cas explicitement scrollables ou limités.
- [ ] Maintenir les actions visibles avec un contenu scrollable.
- [ ] Préserver l’ombre, l’élévation et le clipping natifs.
- [ ] Ne coder aucune couleur ou dimension PaperNest en dur, sauf fallback neutre validé.
- [ ] Ne créer aucun bouton Flutter spécifique pour les actions.

## Phase 5 — Exports et exemple PaperNestExtension

- [ ] Enregistrer `PaperNestAlertDialog` dans `Extension.createWidget()`.
- [ ] Exporter le contrôle depuis le package Python.
- [ ] Supprimer les exports de `PaperNestDialogVariant`.
- [ ] Supprimer les restes de l’ancienne architecture après validation.
- [ ] Reconstruire la page `Dialogues` de l’application d’exemple.

### Cas d’exemple obligatoires

- [ ] Dialogue natif minimal.
- [ ] Header avec titre seul.
- [ ] Header avec icône et titre.
- [ ] Header avec titre et sous-titre.
- [ ] Header avec `title_action`.
- [ ] Actions `PaperNestButton` fournies depuis Python.
- [ ] Contenu court.
- [ ] Formulaire de hauteur naturelle.
- [ ] Contenu long scrollable.
- [ ] Largeur et hauteur maximale personnalisées.
- [ ] Dialogue modal.
- [ ] Dialogue fermable par clic extérieur.
- [ ] Dialogue non fermable par clic extérieur.
- [ ] Couleurs, paddings, forme, ombre et élévation personnalisés.

## Phase 6 — Validation PaperNestExtension

- [ ] Compilation Flutter.
- [ ] `flet run`.
- [ ] Vérification des ouvertures et fermetures successives.
- [ ] Vérification du focus et du clavier.
- [ ] Vérification de la modalité et de la barrière.
- [ ] Vérification du clic extérieur.
- [ ] Vérification des actions Python.
- [ ] Vérification de la hauteur naturelle.
- [ ] Vérification du contenu scrollable.
- [ ] Build Windows.
- [ ] Validation visuelle et fonctionnelle par l’utilisateur.

## Phase 7 — Intégration PaperNest

Cette phase ne commence qu’après validation complète dans PaperNestExtension.

- [ ] Faire hériter `AppDialog` du nouveau `PaperNestAlertDialog`.
- [ ] Reproduire dans `dialogs.py` la palette et les variantes uniquement côté Python.
- [ ] Conserver `ConfirmDialog`, `DangerDialog` et `FormDialog` si leur utilité est confirmée.
- [ ] Utiliser les wrappers `PaperNestButton` dans les actions.
- [ ] Supprimer l’alias `PaperNestDialogVariant`.
- [ ] Auditer tous les dialogues applicatifs.
- [ ] Valider les formulaires, confirmations, suppressions et restaurations.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows.

## Phase 8 — Utilisation par les pickers

Cette phase est séparée de l’intégration générale.

- [ ] `PaperNestColorPicker` ne doit fournir que son contenu de sélection.
- [ ] `PaperNestIconPicker` ne doit fournir que son contenu de sélection.
- [ ] Les dialogues de picker seront composés côté Python avec `PaperNestAlertDialog`.
- [ ] Les boutons d’ouverture seront fournis à `PickerTextField` côté Python.
- [ ] Aucun picker ne doit ouvrir son propre dialogue Flutter.
- [ ] Aucun picker ne doit créer ses propres boutons d’action Flutter.

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