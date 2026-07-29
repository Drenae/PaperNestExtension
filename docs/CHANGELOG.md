# Changelog — PaperNestExtension

Les évolutions importantes du projet sont consignées dans ce fichier.

## En cours

### PaperNestColorPicker

- API Python finalisée.
- Ajout de `read_only`.
- Ajout de l’événement public `on_clear` avec compatibilité temporaire pour `on_cleared`.
- Normalisation systématique des valeurs au format `#RRGGBB`.
- Suppression des valeurs publiques au format `#AARRGGBB`.
- Gestion du focus, du survol et du clavier.
- Ouverture par Entrée ou Espace.
- Gestion de la touche Échap.
- Bouton d’effacement désactivé en lecture seule.
- Exemple de l’extension mis à jour.

### Documentation

- Mise en place de la documentation de développement.
- Création des règles et roadmaps persistantes.

## Contrôles existants

- `PaperNestTextField`
- `PaperNestDropdown` avec `PaperNestDropdownOption`
- `PaperNestDatePicker`
- `PaperNestFilePicker`
- `PaperNestColorPicker` — implémentation terminée, validation Windows et intégration PaperNest restantes.

`PaperNestDropdown` et `PaperNestDropdownOption` appartiennent au même composant fonctionnel.
