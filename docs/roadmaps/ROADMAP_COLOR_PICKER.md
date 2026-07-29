# Roadmap — PaperNestColorPicker

## Objectif

Créer un contrôle de sélection de couleur cohérent avec PaperNestExtension et destiné à remplacer le champ couleur actuel de PaperNest.

## Implémentation de l’extension

- [x] API Python définie.
- [x] Architecture Flutter définie.
- [x] Rendu fermé sous forme de champ Material.
- [x] Ouverture du `MaterialPicker` sur toute la surface.
- [x] Indicateur circulaire de la couleur sélectionnée.
- [x] Valeur normalisée au format `#RRGGBB`.
- [x] Suppression des valeurs publiques `#AARRGGBB`.
- [x] Gestion de la valeur initiale.
- [x] Gestion des changements programmatiques.
- [x] Gestion du focus.
- [x] Gestion du clavier avec Entrée et Espace.
- [x] Gestion de la touche Échap.
- [x] Gestion du survol.
- [x] Gestion de l’état désactivé.
- [x] Gestion de l’état `read_only`.
- [x] Implémentation de `clear_button`.
- [x] Implémentation de l’événement `on_clear`.
- [x] Compatibilité temporaire avec l’ancien événement `on_cleared`.
- [x] Implémentation de `on_change`, `on_focus`, `on_blur` et `on_escape`.
- [x] Exemple de l’extension mis à jour.

## Intégration PaperNest

- [x] Étudier précisément l’implémentation actuelle du champ couleur dans PaperNest.
- [x] Créer ou adapter `BaseColorPicker`.
- [ ] Remplacer l’ancien champ couleur par `PaperNestColorPicker`.
- [ ] Supprimer le code devenu inutile.
- [ ] Vérifier les formulaires utilisant une couleur.

## Validation

- [x] Construire l’extension sous Windows.
- [x] Tester l’ouverture du sélecteur.
- [x] Tester la sélection et la normalisation `#RRGGBB`.
- [x] Tester l’effacement et `on_clear`.
- [x] Tester le focus, le clavier, le survol, `disabled` et `read_only`.
- [x] Valider le comportement réel avec l’utilisateur.
- [ ] Mettre à jour la roadmap globale après validation.

## Critères de finalisation

Le contrôle ne sera marqué comme terminé qu’après validation du build Windows et de son intégration réelle dans PaperNest.
