# Roadmap — Refonte Python-first des Pickers

## État

Refonte planifiée après validation de PaperNestButton.

## Principe directeur

La composition des contrôles, les variantes, le thème, l’ouverture des dialogues et la logique applicative doivent rester côté Python.

Flutter ne doit contenir que le rendu ou le comportement impossible à obtenir proprement avec les contrôles Flet composés côté Python.

## Ordre des chantiers

1. [ ] Finaliser PaperNestButton.
2. [ ] Ajouter le mode picker à PaperNestTextField.
3. [ ] Simplifier PaperNestAlertDialog.
4. [ ] Réduire PaperNestColorPicker à l’affichage du picker.
5. [ ] Réduire PaperNestIconPicker à l’affichage de la galerie.
6. [ ] Supprimer PaperNestDatePicker après migration vers le DatePicker natif.
7. [ ] Migrer PaperNest progressivement et supprimer le code devenu inutile.

## PaperNestTextField

- [ ] Ajouter `picker: bool`.
- [ ] Ajouter un bouton texte `CHOISIR` dans le champ.
- [ ] Ajouter `picker_bgcolor`.
- [ ] Ajouter `picker_color`.
- [ ] Ajouter `picker_border_radius`.
- [ ] Ajouter un événement dédié `on_picker_click` ou `picker_on_click`.
- [ ] Vérifier l’interaction avec `on_click`, `on_change`, `on_submit` et `clear_button`.
- [ ] Conserver le comportement normal lorsque `picker=False`.
- [ ] Permettre la composition Python `PickerTextField(BaseTextField)` dans PaperNest.

## PaperNestAlertDialog

- [ ] Limiter le contrôle à la structure du dialogue.
- [ ] Header : title, subtitle et title_action.
- [ ] Content.
- [ ] Footer/actions.
- [ ] Supprimer `variant` de l’API publique.
- [ ] Supprimer toute résolution de variante côté Flutter.
- [ ] Appliquer les palettes et styles uniquement depuis Python.
- [ ] Ne dépendre d’aucun picker ni de PaperNestButton.

## PaperNestColorPicker

- [ ] Supprimer le champ d’ouverture intégré.
- [ ] Supprimer l’ouverture du dialogue Flutter.
- [ ] Supprimer les actions Flutter du dialogue.
- [ ] Conserver uniquement l’affichage et les événements du picker.
- [ ] Étudier le remplacement par `flet-color-pickers`.
- [ ] Composer le TextField, le dialogue et le picker côté Python.

## PaperNestIconPicker

- [ ] Supprimer le champ d’ouverture intégré.
- [ ] Supprimer l’ouverture du dialogue Flutter.
- [ ] Supprimer les actions Flutter du dialogue.
- [ ] Conserver uniquement la galerie, la sélection et les événements.
- [ ] Composer le TextField, le dialogue et le picker côté Python.

## PaperNestDatePicker

- [ ] Recenser les fonctionnalités encore utiles.
- [ ] Migrer le thème vers la configuration Python du DatePicker natif.
- [ ] Migrer la localisation française côté Python/application.
- [ ] Migrer la normalisation de date côté Python.
- [ ] Remplacer les usages par le DatePicker natif.
- [ ] Supprimer PaperNestDatePicker après validation.

## PaperNestFilePicker

- [x] Conserver le contrôle sans modification.
- [x] Conserver son drag-and-drop, ses événements et son intégration native.

## Migration PaperNest

- [ ] Créer `PickerTextField(BaseTextField)` dans `forms.py`.
- [ ] Composer ColorPicker et IconPicker avec AppDialog côté Python.
- [ ] Utiliser directement le DatePicker natif.
- [ ] Migrer écran par écran.
- [ ] Valider `flet run --recursive` après chaque étape.
- [ ] Valider le build Windows après chaque contrôle.
- [ ] Supprimer les anciens wrappers seulement après validation.

## Critère de finalisation

La refonte sera terminée lorsque Python contrôlera entièrement la composition et le thème des pickers, que Flutter ne contiendra plus de dialogues ou variantes métier inutiles et que PaperNest fonctionnera sous Windows sans dépendances circulaires entre contrôles.
