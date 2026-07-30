# Changelog — PaperNestExtension

Les évolutions importantes du projet sont consignées dans ce fichier.

## Version finalisée

Tous les contrôles actuellement nécessaires à PaperNest sont implémentés, intégrés et validés sous Windows.

## Contrôles disponibles

- `PaperNestTextField`
- `PaperNestDropdown` avec `PaperNestDropdownOption`
- `PaperNestColorPicker`
- `PaperNestDatePicker`
- `PaperNestFilePicker`

`PaperNestDropdown` et `PaperNestDropdownOption` appartiennent au même composant fonctionnel.

## PaperNestColorPicker

- API Python et implémentation Flutter finalisées.
- Valeurs publiques normalisées au format `#RRGGBB`.
- Gestion de `read_only`, du focus, du survol, du clavier et d’Échap.
- Ajout de `clear_button` et de l’événement `on_clear`.
- Exemple, build Windows et intégration PaperNest validés.

## PaperNestDatePicker

- Contrôle autonome avec rendu Material.
- Gestion des valeurs, limites, modes, événements et méthodes asynchrones.
- Normalisation des dates civiles pour éviter les décalages de fuseau horaire.
- Exemple et interactions validés sous Windows.
- Intégration PaperNest validée via un wrapper thématique héritant directement du contrôle.

## PaperNestFilePicker

- Sélection native, bouton externe, glisser-déposer et liste interne unifiés.
- Gestion de la sélection simple ou multiple, des types, extensions, tailles et limites.
- Détection des doublons et événements typés.
- Méthodes `get_files()`, `remove_file()`, `clear_files()`, `upload()` et `get_directory_path()` validées.
- Exemple et build Windows validés.
- Intégration des parcours d’import et de restauration de PaperNest validée.

## Documentation et finalisation

- Documentation de développement et règles persistantes mises en place.
- Roadmaps détaillées des contrôles mises à jour et clôturées.
- Roadmap globale des contrôles clôturée.
- Nettoyage des anciens wrappers et dépendances dans PaperNest validé.

## Maintenance

Aucun nouveau contrôle n’est planifié. Une nouvelle fonctionnalité ne doit être ajoutée que lorsqu’un besoin concret et validé existe dans PaperNest.
