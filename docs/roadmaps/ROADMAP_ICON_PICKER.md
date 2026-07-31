# Roadmap — PaperNestIconPicker

## État

`PaperNestIconPicker` est implémenté, construit, testé et validé sous Windows dans PaperNestExtension.

Le curseur interactif a également été reconstruit, testé et validé. L’intégration dans PaperNest est maintenant en place : un wrapper thématique dédié a été créé et l’éditeur des classeurs utilise le nouveau contrôle. La suppression de l’ancien `BaseIconField` reste volontairement différée jusqu’à validation finale dans PaperNest.

## Objectif

Créer un sélecteur d’icône autonome dans PaperNestExtension, cohérent avec les autres pickers de l’extension, puis remplacer le contrôle historique `BaseIconField` de PaperNest après validation complète sous Windows.

## Étude de l’existant dans PaperNest

- [x] Identifier l’unique usage actuel de `BaseIconField` dans l’éditeur des classeurs.
- [x] Relire l’implémentation complète de `BaseIconField` dans `src/app/theme/forms.py`.
- [x] Inventorier l’aperçu, la galerie responsive, la sélection temporaire, l’annulation, la validation et l’état désactivé.
- [x] Confirmer que la valeur métier enregistrée est le nom Material de l’icône sous forme de chaîne.
- [x] Confirmer que les options actuelles sont un dictionnaire `libellé -> nom Material`.
- [x] Confirmer que l’unique fallback actuel est `FOLDER_ROUNDED`.
- [ ] Vérifier les valeurs réellement présentes dans les données existantes pendant la validation PaperNest.

## Décisions de conception

- [x] Conserver `value` comme chaîne contenant le nom Material enregistré.
- [x] Créer une option structurée contenant `label`, `value` et l’icône Flet à afficher.
- [x] Séparer la valeur métier de la représentation visuelle pour éviter une table de correspondance Flutter fragile.
- [x] Prévoir un fallback sûr lorsque la valeur chargée est inconnue.
- [x] Ne pas ajouter de recherche : les options actuelles restent lisibles dans une galerie responsive.
- [x] Ne pas ajouter de bouton d’effacement : une catégorie doit toujours conserver une icône valide.
- [x] Conserver la sélection temporaire et la validation explicite.
- [x] Conserver l’annulation sans modification de la valeur.
- [x] Garder une API autonome ne dépendant ni de `Page` ni des composants PaperNest.

## API Python

- [x] Créer `PaperNestIconPicker`.
- [x] Créer `PaperNestIconPickerOption`.
- [x] Ajouter `options`, `value` et `fallback_value`.
- [x] Ajouter `label`, `hint_text`, `picker_title`, `picker_description`, `cancel_text` et `confirm_text`.
- [x] Ajouter `disabled`, `read_only` et `autofocus`.
- [x] Ajouter les styles du champ, de la galerie et de l’état sélectionné.
- [x] Ajouter `on_change`, `on_focus`, `on_blur` et `on_escape`.
- [x] Ajouter les méthodes programmatiques `focus()` et `open()`.
- [x] Normaliser une valeur inconnue vers `fallback_value`, puis vers la première option disponible.

## Implémentation Flutter

- [x] Créer le contrôle Flutter autonome.
- [x] Construire un champ Material fermé affichant l’icône, le libellé et un chevron.
- [x] Ouvrir un dialogue contenant une galerie responsive.
- [x] Afficher l’icône, son libellé et l’état sélectionné.
- [x] Conserver une sélection temporaire jusqu’à validation.
- [x] Gérer l’annulation sans modifier la valeur publique.
- [x] Gérer une valeur inconnue avec le fallback défini.
- [x] Gérer une modification programmée de `value`.
- [x] Gérer le clavier, le focus, le survol, `disabled` et `read_only`.
- [x] Utiliser `SystemMouseCursors.click` sur le champ et les options interactives.
- [x] Conserver `SystemMouseCursors.basic` pour les états non interactifs.
- [x] Synchroniser la valeur entre Flutter et Python.
- [x] Enregistrer le contrôle dans `Extension.createWidget()`.
- [x] Exporter le contrôle depuis `papernestextension.controls` et `papernestextension`.

## Exemple et validation de l’extension

- [x] Ajouter l’exemple directement dans l’application d’exemple principale.
- [x] Utiliser un ensemble représentatif des icônes de PaperNest.
- [x] Afficher la valeur métier sélectionnée dans l’exemple.
- [x] Vérifier la compilation Flutter.
- [x] Tester la valeur initiale.
- [x] Tester la sélection et la validation.
- [x] Tester l’annulation.
- [x] Tester une modification programmée de `value`.
- [x] Tester une valeur inconnue et le fallback.
- [x] Tester `disabled` et `read_only`.
- [x] Tester le clavier et le focus.
- [x] Construire et tester l’exemple sous Windows avec Flet 0.85.3.
- [x] Faire valider visuellement et fonctionnellement le contrôle par l’utilisateur.
- [x] Revalider le curseur interactif après reconstruction de l’extension.

## Intégration dans PaperNest

- [x] Créer `src/app/theme/icon_picker.py`.
- [x] Créer un wrapper thématique léger héritant directement de `PaperNestIconPicker`.
- [x] Convertir `AVAILABLE_ICONS` vers des `PaperNestIconPickerOption`.
- [x] Remplacer `BaseIconField` dans l’éditeur des classeurs.
- [x] Préserver les noms d’icônes enregistrés et la prévisualisation existante.
- [x] Préserver le fallback `FOLDER_ROUNDED` pour une valeur inconnue.
- [ ] Vérifier les catégories utilisant une ancienne valeur inconnue.
- [ ] Valider la création et la modification d’un classeur sous Windows.
- [ ] Valider le build Windows de PaperNest.
- [ ] Supprimer l’ancien `BaseIconField` après validation.
- [ ] Nettoyer les imports et le code devenus inutiles dans `forms.py`.
- [ ] Mettre à jour les changelogs des deux projets.
- [ ] Marquer le contrôle comme entièrement terminé.

## Critère de finalisation

Le contrôle sera considéré comme entièrement terminé après validation dans PaperNest, conservation des valeurs existantes, gestion sûre des valeurs inconnues, suppression de `BaseIconField`, nettoyage de `forms.py`, validation du build Windows et validation explicite par l’utilisateur.
