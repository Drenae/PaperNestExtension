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

- [ ] Étudier précisément l’implémentation actuelle du champ couleur dans PaperNest.
- [ ] Créer ou adapter `BaseColorPicker`.
- [ ] Remplacer l’ancien champ couleur par `PaperNestColorPicker`.
- [ ] Supprimer le code devenu inutile.
- [ ] Vérifier les formulaires utilisant une couleur.

## Validation

- [ ] Construire l’extension sous Windows.
- [ ] Tester l’ouverture du sélecteur.
- [ ] Tester la sélection et la normalisation `#RRGGBB`.
- [ ] Tester l’effacement et `on_clear`.
- [ ] Tester le focus, le clavier, le survol, `disabled` et `read_only`.
- [ ] Valider le comportement réel avec l’utilisateur.
- [ ] Mettre à jour la roadmap globale après validation.

## Critères de finalisation

Le contrôle ne sera marqué comme terminé qu’après validation du build Windows et de son intégration réelle dans PaperNest.
