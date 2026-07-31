# Roadmap — PaperNestIconPicker

## État

Le chantier `PaperNestIconPicker` est officiellement ouvert.

Le contrôle doit remplacer `BaseIconField` dans PaperNest uniquement s’il conserve le comportement actuel tout en simplifiant l’architecture. L’objectif n’est pas d’ajouter un explorateur d’icônes généraliste, mais de créer un picker autonome, cohérent avec les autres contrôles de PaperNestExtension.

## Objectif

Créer un sélecteur d’icône autonome dans PaperNestExtension, cohérent avec les autres pickers de l’extension, puis remplacer le contrôle historique `BaseIconField` de PaperNest après validation complète sous Windows.

## Étude de l’existant dans PaperNest

- [x] Identifier l’unique usage actuel de `BaseIconField` dans l’éditeur des classeurs.
- [x] Relire l’implémentation complète de `BaseIconField` dans `src/app/theme/forms.py`.
- [x] Inventorier les comportements actuels : aperçu, galerie responsive, sélection temporaire, annulation, validation, état désactivé et événement de changement.
- [x] Confirmer que la valeur métier enregistrée est le nom Material de l’icône sous forme de chaîne.
- [x] Confirmer que les options actuelles sont un dictionnaire `libellé -> nom Material`.
- [x] Confirmer que le champ fermé affiche l’icône, son libellé et un chevron.
- [x] Confirmer que la galerie utilise une sélection temporaire jusqu’au bouton de validation.
- [x] Confirmer que l’annulation ne modifie pas la valeur publique.
- [x] Confirmer que l’unique fallback actuel est `FOLDER_ROUNDED`.
- [ ] Vérifier toutes les valeurs d’icônes déjà présentes dans les données existantes.

## Décisions de conception initiales

- [x] Conserver `value` comme chaîne contenant le nom Material enregistré.
- [x] Conserver une option structurée avec un `label` et une `value`.
- [x] Prévoir un fallback sûr lorsque la valeur chargée est inconnue.
- [x] Ne pas ajouter de recherche ou de filtrage : les vingt icônes actuelles restent lisibles dans une galerie responsive.
- [x] Ne pas ajouter de bouton d’effacement : une catégorie doit toujours avoir une icône valide.
- [x] Conserver la sélection temporaire et la validation explicite.
- [x] Conserver l’annulation sans modification de la valeur.
- [x] Prévoir `disabled` et `read_only`.
- [x] Garder une API autonome ne dépendant ni de `Page` ni des composants PaperNest.

## API Python proposée

### Contrôles publics

- [ ] `PaperNestIconPicker`.
- [ ] `PaperNestIconPickerOption`.

### `PaperNestIconPickerOption`

- [ ] `label: str`.
- [ ] `value: str` — nom Material, par exemple `FOLDER_ROUNDED`.
- [ ] `icon` optionnel uniquement si un besoin réel de contrôle personnalisé apparaît.

### `PaperNestIconPicker`

- [ ] `options: list[PaperNestIconPickerOption]`.
- [ ] `value: Optional[str]`.
- [ ] `fallback_value: Optional[str]`.
- [ ] `label` acceptant une chaîne ou un contrôle Flet.
- [ ] `hint_text`.
- [ ] `picker_title`.
- [ ] `picker_description`.
- [ ] `cancel_text`.
- [ ] `confirm_text`.
- [ ] `prefix_icon` ou aperçu intégré cohérent avec les autres champs.
- [ ] `disabled`.
- [ ] `read_only`.
- [ ] `on_change`.
- [ ] Styles du champ fermé cohérents avec les autres contrôles de l’extension.
- [ ] Styles de la galerie et de l’état sélectionné configurables sans multiplier les propriétés inutiles.

## Implémentation Flutter

- [ ] Créer le contrôle Flutter autonome.
- [ ] Reproduire le rendu fermé validé de PaperNest.
- [ ] Ouvrir un dialogue contenant une galerie responsive.
- [ ] Afficher l’icône, son libellé et l’état sélectionné.
- [ ] Conserver une sélection temporaire jusqu’à validation.
- [ ] Gérer l’annulation sans modifier la valeur publique.
- [ ] Gérer une valeur inconnue avec le fallback défini.
- [ ] Gérer une modification programmée de `value`.
- [ ] Gérer le clavier, le focus, le survol et l’état désactivé de façon cohérente avec les autres contrôles.
- [ ] Enregistrer le contrôle dans `Extension.createWidget()`.
- [ ] Exporter le contrôle depuis `papernestextension.controls` et `papernestextension`.

## Exemple et validation de l’extension

- [ ] Ajouter l’exemple directement dans l’application d’exemple principale.
- [ ] Tester la valeur initiale.
- [ ] Tester la sélection et la validation.
- [ ] Tester l’annulation.
- [ ] Tester une modification programmée de `value`.
- [ ] Tester une valeur inconnue.
- [ ] Tester le fallback.
- [ ] Tester `disabled`.
- [ ] Tester `read_only`.
- [ ] Construire et tester l’exemple sous Windows avec les versions retenues par le projet.
- [ ] Faire valider visuellement et fonctionnellement le contrôle par l’utilisateur.

## Intégration dans PaperNest

- [ ] Créer un wrapper thématique léger héritant directement de `PaperNestIconPicker`.
- [ ] Convertir `AVAILABLE_ICONS` vers des `PaperNestIconPickerOption`.
- [ ] Remplacer `BaseIconField` dans l’éditeur des classeurs.
- [ ] Préserver les noms d’icônes enregistrés et la prévisualisation existante.
- [ ] Vérifier les catégories utilisant une ancienne valeur inconnue.
- [ ] Supprimer l’ancien `BaseIconField` après validation.
- [ ] Nettoyer les imports et le code devenus inutiles dans `forms.py`.
- [ ] Valider le rendu et le comportement sous Windows avec l’utilisateur.
- [ ] Valider le build Windows de PaperNest.
- [ ] Mettre à jour les roadmaps et changelogs des deux projets.

## Critère de finalisation

Le contrôle ne sera considéré comme terminé qu’après :

- [ ] validation de l’exemple Windows ;
- [ ] intégration réelle dans l’éditeur des classeurs ;
- [ ] conservation des valeurs existantes ;
- [ ] gestion sûre des valeurs inconnues ;
- [ ] suppression de `BaseIconField` ;
- [ ] validation du build Windows de PaperNest ;
- [ ] validation explicite par l’utilisateur.