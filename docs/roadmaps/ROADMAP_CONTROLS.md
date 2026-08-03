# Roadmap des contrôles — PaperNestExtension

## État

`PaperNestFilePicker`, `PaperNestGlideRail` et les contrôles de formulaire validés restent stables.

`PaperNestButton` est le chantier actif. Une refonte Python-first des pickers et dialogues suivra ensuite pour retirer les responsabilités métier inutilement placées côté Flutter.

## Contrôles stables

- [x] `PaperNestTextField` — une extension picker sera ajoutée sans casser l’API actuelle.
- [x] `PaperNestDropdown` + `PaperNestDropdownOption`.
- [x] `PaperNestFilePicker`.
- [x] `PaperNestGlideRail` + `PaperNestGlideRailDestination`.

## Chantier actif

### PaperNestButton

- [ ] `PaperNestButton`

Règles :

- styles et variantes exclusivement côté Python ;
- `ButtonStyle` reste la source de vérité Material ;
- Flutter gère uniquement gradient, gradient de survol, animation hover, animation clic et loading ;
- aucune dépendance imposée aux dialogues ou pickers.

Roadmap détaillée :

- `ROADMAP_BUTTON.md`

## Refonte planifiée des Pickers

Les implémentations actuelles de `PaperNestAlertDialog`, `PaperNestColorPicker`, `PaperNestIconPicker` et `PaperNestDatePicker` seront réévaluées selon une architecture Python-first.

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

- [ ] Centraliser uniquement les fonctions réellement dupliquées.
- [ ] Regrouper les helpers par thèmes cohérents.
- [ ] Ne pas déplacer la composition ou les variantes métier côté Flutter.

Roadmap détaillée :

- `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`

## Application d’exemple

- [x] Petite application navigable avec GlideRail.
- [x] Page Actions créée.
- [ ] Revalider PaperNestButton après la suppression des variantes Flutter.
- [ ] Adapter les pages Pickers pendant la refonte Python-first.

## Règles de suivi

- Python contrôle la composition, les variantes, le thème et les dialogues.
- Flutter ne contient que le rendu impossible à obtenir proprement côté Python.
- Aucun contrôle ne doit entraîner une chaîne de dépendances entre picker, dialogue et bouton.
- Les migrations sont effectuées contrôle par contrôle avec validation Windows.
- Le code historique n’est supprimé qu’après validation de son remplacement.
