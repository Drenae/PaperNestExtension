# Roadmap — PaperNestIconPicker

## État

Étude démarrée. Le contrôle doit remplacer `BaseIconField` uniquement s’il simplifie réellement PaperNest sans ajouter de complexité inutile.

## Objectif

Créer un sélecteur d’icône autonome dans PaperNestExtension, cohérent avec les autres pickers de l’extension, puis remplacer le contrôle historique `BaseIconField` de PaperNest après validation complète sous Windows.

## Étude de l’existant dans PaperNest

- [x] Identifier l’unique usage actuel de `BaseIconField` dans l’éditeur des classeurs.
- [x] Inventorier les comportements actuels : aperçu, galerie responsive, sélection temporaire, annulation, validation, état désactivé et événement de changement.
- [x] Confirmer que la valeur métier enregistrée est le nom Material de l’icône sous forme de chaîne.
- [ ] Vérifier toutes les valeurs d’icônes déjà présentes dans les données existantes.
- [ ] Définir le comportement attendu lorsqu’une valeur inconnue est chargée.

## Conception de l’API Python

- [ ] Définir `PaperNestIconPicker`.
- [ ] Définir une représentation claire des options, probablement `PaperNestIconPickerOption`.
- [ ] Conserver une propriété publique `value` contenant le nom Material enregistré par PaperNest.
- [ ] Prévoir `label`, `hint_text`, `picker_title`, `cancel_text` et `confirm_text`.
- [ ] Prévoir `disabled` et `read_only`.
- [ ] Prévoir `on_change`, `on_focus`, `on_blur` et `on_escape` uniquement si ces événements sont réellement utiles.
- [ ] Décider si un bouton d’effacement est pertinent pour le besoin réel de PaperNest.
- [ ] Éviter toute fonction de recherche ou de filtrage tant qu’un besoin utilisateur concret n’est pas démontré.

## Implémentation Flutter

- [ ] Créer le contrôle Flutter autonome.
- [ ] Reproduire le rendu fermé validé de PaperNest.
- [ ] Ouvrir un dialogue contenant une galerie responsive.
- [ ] Afficher l’icône, son libellé et l’état sélectionné.
- [ ] Conserver une sélection temporaire jusqu’à validation.
- [ ] Gérer l’annulation sans modifier la valeur publique.
- [ ] Gérer le clavier, le focus, le survol et l’état désactivé de façon cohérente avec les autres contrôles.
- [ ] Exporter le contrôle depuis `papernestextension.controls` et `papernestextension`.

## Exemple et validation de l’extension

- [ ] Ajouter un exemple dédié.
- [ ] Tester la valeur initiale.
- [ ] Tester la sélection et la validation.
- [ ] Tester l’annulation.
- [ ] Tester une modification programmée de `value`.
- [ ] Tester les valeurs inconnues.
- [ ] Tester `disabled` et `read_only`.
- [ ] Construire et tester l’exemple sous Windows avec les versions retenues par le projet.

## Intégration dans PaperNest

- [ ] Créer un wrapper thématique léger héritant directement de `PaperNestIconPicker`.
- [ ] Remplacer `BaseIconField` dans l’éditeur des classeurs.
- [ ] Préserver les noms d’icônes enregistrés et la prévisualisation existante.
- [ ] Supprimer l’ancien `BaseIconField` après validation.
- [ ] Nettoyer les imports et le code devenus inutiles.
- [ ] Valider le rendu et le comportement sous Windows avec l’utilisateur.
- [ ] Valider le build Windows de PaperNest.
- [ ] Mettre à jour les roadmaps et changelogs des deux projets.

## Critère de finalisation

Le contrôle ne sera considéré comme terminé qu’après validation de l’exemple Windows, intégration réelle dans l’éditeur des classeurs, conservation des valeurs existantes, suppression de l’ancien contrôle et validation explicite par l’utilisateur.