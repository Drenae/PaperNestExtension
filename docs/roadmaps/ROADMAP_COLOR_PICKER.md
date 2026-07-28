# Roadmap — PaperNestColorPicker

## Objectif

Créer un contrôle de sélection de couleur cohérent avec PaperNestExtension et destiné à remplacer le champ couleur actuel de PaperNest.

## Fait

- [x] Besoin identifié dans PaperNest.
- [x] Principe général validé.
- [x] Valeur cible définie au format `#RRGGBB`.
- [x] Intégration d’un bouton d’effacement prévue.
- [x] Événement `on_clear` prévu.

## À étudier et développer

- [ ] Étudier l’implémentation actuelle du champ couleur dans PaperNest.
- [ ] Définir précisément l’API Python.
- [ ] Définir l’architecture Flutter.
- [ ] Définir le rendu du champ fermé.
- [ ] Afficher un indicateur visuel de la couleur sélectionnée.
- [ ] Définir le comportement du sélecteur de couleur.
- [ ] Gérer la normalisation et la validation des couleurs `#RRGGBB`.
- [ ] Gérer la valeur initiale et les changements programmatiques.
- [ ] Gérer le focus.
- [ ] Gérer le clavier.
- [ ] Gérer le survol.
- [ ] Gérer les états désactivé et lecture seule si nécessaires.
- [ ] Implémenter `clear_button`.
- [ ] Implémenter `on_clear`.
- [ ] Ajouter les événements nécessaires.
- [ ] Créer ou mettre à jour l’exemple de l’extension.
- [ ] Tester le contrôle sous Windows.
- [ ] Intégrer le contrôle dans PaperNest.
- [ ] Remplacer l’ancien champ couleur devenu inutile.
- [ ] Valider le comportement réel avec l’utilisateur.
- [ ] Mettre à jour le changelog et la roadmap globale.

## Critères de finalisation

Le contrôle ne sera marqué comme terminé qu’après validation de l’API Python, de l’implémentation Flutter, de l’exemple, du build Windows et de son intégration dans PaperNest.
