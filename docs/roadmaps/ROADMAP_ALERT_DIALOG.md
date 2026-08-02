# Roadmap — PaperNestAlertDialog

## État

Phase 3 avancée.

`PaperNestAlertDialog`, `PaperNestDialogSurface` et l’application d’exemple sont créés, compilés et validés sous Windows. Les migrations des ColorPicker, IconPicker et DatePicker sont également validées.

L’intégration de `AppDialog(PaperNestAlertDialog)` est maintenant implémentée dans PaperNest et attend sa validation applicative et son build Windows.

## Objectif

Créer un dialogue PaperNest réutilisable :

- comme contrôle public depuis Python ;
- comme rendu Flutter partagé à l’intérieur des pickers ;
- avec une identité visuelle cohérente dans PaperNest et PaperNestExtension.

## Architecture validée

- [x] Créer `PaperNestAlertDialog`, contrôle public Python.
- [x] Créer `PaperNestDialogSurface`, surface Flutter interne partagée.
- [x] Conserver le cycle de vie natif : `open`, route propre, modalité, barrière et `dismiss`.
- [x] Conserver les actions Python telles quelles.
- [x] Utiliser `Colors.grey.shade900` comme en-tête par défaut.
- [x] Prévoir `PaperNestButton` dans une roadmap distincte.

## API publique

- [x] Variantes standard, primary, success, warning et danger.
- [x] `title`, `title_action`, `icon`, `content` et `actions`.
- [x] `width`, `max_height`, `modal`, `dismissible` et `scrollable`.
- [x] Couleurs, paddings, forme, ombre, alignement et barrière personnalisables.
- [x] Exports publics et enregistrement dans l’extension.

## Pickers

### PaperNestColorPicker

- [x] Utiliser `PaperNestDialogSurface`.
- [x] Conserver la sélection temporaire, l’annulation et la confirmation.
- [x] Valider l’exemple, PaperNest et le build Windows.

### PaperNestIconPicker

- [x] Utiliser `PaperNestDialogSurface`.
- [x] Conserver la galerie responsive et toutes ses options.
- [x] Valider l’exemple, PaperNest et le build Windows.

### PaperNestDatePicker

- [x] Conserver le dialogue Material natif.
- [x] Appliquer l’identité PaperNest via `DatePickerTheme` et le `builder`.
- [x] Conserver les modes calendrier, saisie, année et jour.
- [x] Exposer les propriétés visuelles côté Python.
- [x] Valider tous les modes, PaperNest et le build Windows.

### PaperNestFilePicker

- [x] Étudier l’implémentation Flutter complète.
- [x] Confirmer qu’aucun `AlertDialog` Flutter interne n’est construit.
- [x] Conserver les fenêtres natives fournies par `file_picker` et Windows.
- [x] Ne pas forcer de migration inutile vers `PaperNestDialogSurface`.

## Intégration PaperNest

- [x] Faire hériter `AppDialog` de `PaperNestAlertDialog`.
- [x] Conserver `DialogVariant` par alias vers `PaperNestDialogVariant`.
- [x] Conserver `ConfirmDialog`, `DangerDialog` et `FormDialog`.
- [x] Conserver les boutons PaperNest dans les actions.
- [x] Supprimer la construction manuelle de l’en-tête et des palettes dans `dialogs.py`.
- [ ] Tester tous les dialogues applicatifs.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows de PaperNest.
- [ ] Faire valider la migration par l’utilisateur.

## Validation finale

- [x] Valider les variantes dans l’application d’exemple.
- [x] Tester `title_action`, modalité, fermeture extérieure et contenu scrollable.
- [x] Valider les trois pickers concernés après migration.
- [ ] Tester plusieurs dialogues successifs et superposés dans PaperNest.
- [ ] Vérifier l’accessibilité et le libellé sémantique.
- [ ] Clôturer la roadmap après validation de PaperNest.

## Refactorisations futures associées

- `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`
- `ROADMAP_BUTTON.md`

## Critère de finalisation

Le chantier sera terminé lorsque tous les dialogues PaperNest auront été validés avec `AppDialog(PaperNestAlertDialog)` et que le build Windows fonctionnera sans régression.
