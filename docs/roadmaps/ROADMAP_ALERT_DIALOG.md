# Roadmap — PaperNestAlertDialog

## État

Terminé, intégré et validé sous Windows.

`PaperNestAlertDialog`, `PaperNestDialogSurface`, les migrations des pickers compatibles et l’intégration `AppDialog(PaperNestAlertDialog)` dans PaperNest ont été testés et validés. La correction de hauteur naturelle des contenus ordinaires et l’attribution explicite des variants dans PaperNest sont également validées.

## Objectif atteint

Créer un dialogue PaperNest réutilisable :

- comme contrôle public depuis Python ;
- comme surface Flutter partagée dans les contrôles internes ;
- avec une identité visuelle cohérente dans PaperNest et PaperNestExtension.

## Architecture validée

- [x] Créer `PaperNestAlertDialog`, contrôle public Python.
- [x] Créer `PaperNestDialogSurface`, surface Flutter interne partagée.
- [x] Conserver le cycle de vie natif : `open`, route propre, modalité, barrière et `dismiss`.
- [x] Conserver les actions Python telles quelles.
- [x] Utiliser `Colors.grey.shade900` comme en-tête par défaut.
- [x] Conserver une hauteur naturelle pour les contenus non scrollables et sans `max_height`.
- [x] Réserver `Flexible` aux contenus scrollables ou explicitement limités en hauteur.
- [x] Prévoir `PaperNestButton` dans une roadmap distincte.

## API publique validée

- [x] Variantes standard, primary, success, warning et danger.
- [x] `title`, `title_action`, `icon`, `content` et `actions`.
- [x] `width`, `max_height`, `modal`, `dismissible` et `scrollable`.
- [x] Couleurs, paddings, forme, ombre, alignement et barrière personnalisables.
- [x] Exports publics et enregistrement dans l’extension.

## Pickers

- [x] `PaperNestColorPicker` utilise `PaperNestDialogSurface`.
- [x] `PaperNestIconPicker` utilise `PaperNestDialogSurface`.
- [x] `PaperNestDatePicker` conserve le dialogue Material natif avec un thème PaperNest injecté par `builder`.
- [x] `PaperNestFilePicker` conserve les fenêtres natives de `file_picker` et de Windows.
- [x] Tous les pickers concernés ont été testés et validés avec leurs builds Windows.

## Intégration PaperNest

- [x] Faire hériter `AppDialog` de `PaperNestAlertDialog`.
- [x] Conserver `DialogVariant` par alias vers `PaperNestDialogVariant`.
- [x] Conserver `ConfirmDialog`, `DangerDialog` et `FormDialog`.
- [x] Conserver les boutons PaperNest dans les actions.
- [x] Supprimer la construction manuelle de l’en-tête et des palettes dans `dialogs.py`.
- [x] Auditer tous les appels directs à `AppDialog`.
- [x] Attribuer un variant explicite aux dialogues applicatifs selon leur rôle.
- [x] Valider les contenus courts, les formulaires, les contenus scrollables et `title_action`.
- [x] Valider `flet run --recursive` et le build Windows de PaperNest.
- [x] Faire valider visuellement et fonctionnellement la migration par l’utilisateur.

## Refactorisations futures associées

- `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`
- `ROADMAP_BUTTON.md`

## Critère de finalisation

Atteint : tous les dialogues PaperNest utilisent l’architecture validée sans régression, les variants sont correctement appliqués et les builds Windows fonctionnent.
