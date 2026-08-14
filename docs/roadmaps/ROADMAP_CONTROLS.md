# Roadmap des contrôles — PaperNestExtension

## État

Tous les contrôles conservés dans PaperNestExtension sont terminés, stables et validés sous Windows.

La refonte Python-first des pickers et dialogues est terminée. Les anciens contrôles devenus inutiles ont été supprimés.

## Contrôles stables

- [x] `PaperNestTextField`, avec mode picker validé.
- [x] `PaperNestDropdown` + `PaperNestDropdownOption`.
- [x] `PaperNestFilePicker`.
- [x] `PaperNestGlideRail` + `PaperNestGlideRailDestination`.

## Contrôle finalisé

### PaperNestButton

- [x] `PaperNestButton`

Règles :

- styles et variantes exclusivement côté Python ;
- `ButtonStyle` reste la source de vérité Material ;
- Flutter gère uniquement gradient, gradient de survol, animation hover, animation clic et loading ;
- aucune dépendance imposée aux dialogues ou pickers.

Roadmap détaillée :

- `ROADMAP_BUTTON.md`

## Refonte terminée des pickers

`PaperNestAlertDialog`, `PaperNestColorPicker`, `PaperNestIconPicker` et `PaperNestDatePicker` ont été remplacés par des compositions Python ou des contrôles Flet natifs, puis supprimés de l’extension.

Ordre retenu :

1. PaperNestButton ;
2. PaperNestTextField avec bouton picker ;
3. simplification de PaperNestAlertDialog ;
4. ColorPicker limité à l’affichage ;
5. IconPicker limité à l’affichage ;
6. remplacement de PaperNestDatePicker par le contrôle natif ;
7. migration progressive de PaperNest.

Roadmap détaillée :

- `ROADMAP_PICKER_ARCHITECTURE_RESET.md`

## Architecture Flutter partagée

- [x] Supprimer les duplications avec les anciens contrôles devenus inutiles.
- [x] Conserver uniquement les helpers encore réellement partagés.
- [x] Ne pas déplacer la composition ou les variantes métier côté Flutter.

Roadmap détaillée :

- `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`

## Application d’exemple

- [x] Petite application navigable avec GlideRail.
- [x] Page Actions créée.
- [x] Revalider PaperNestButton après la suppression des variantes Flutter.
- [x] Adapter les pages Pickers pendant la refonte Python-first.

## Règles de suivi

- Python contrôle la composition, les variantes, le thème et les dialogues.
- Flutter ne contient que le rendu impossible à obtenir proprement côté Python.
- Aucun contrôle ne doit entraîner une chaîne de dépendances entre picker, dialogue et bouton.
- Les migrations sont effectuées contrôle par contrôle avec validation Windows.
- Le code historique n’est supprimé qu’après validation de son remplacement.
