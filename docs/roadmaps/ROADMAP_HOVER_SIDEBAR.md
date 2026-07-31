# Roadmap — PaperNestHoverSidebar

## État

Première implémentation Python et Flutter créée. Le contrôle est exporté publiquement et un exemple isolé en `Stack` permet désormais de préparer les tests Windows. Aucun résultat de build ou test visuel n’est encore considéré comme validé.

Le `NavigationDrawer` natif Flet n’est pas retenu comme base directe : son fonctionnement modal ne correspond pas à une rail d’icônes permanente qui s’agrandit au survol.

## Objectif

Créer un contrôle de navigation latérale qui reste toujours visible sous forme compacte, s’agrandit avec une animation lorsque la souris entre dans sa zone, se replie lorsque la souris en sort et se superpose au contenu sans modifier sa largeur.

## Comportement attendu

### État replié

- [x] Afficher uniquement le logo ou l’icône de marque compacte.
- [x] Afficher un séparateur.
- [x] Afficher uniquement les icônes des destinations principales.
- [x] Conserver un espace extensible entre les destinations principales et l’administration.
- [x] Afficher un séparateur avant l’administration.
- [x] Afficher uniquement l’icône Administration.
- [x] Conserver une largeur compacte fixe.
- [x] Documenter dans l’exemple la réservation de cette largeur compacte dans la mise en page.

### État déployé

- [x] Agrandir la sidebar horizontalement avec un `AnimatedContainer`.
- [x] Afficher le titre et le sous-titre de marque.
- [x] Afficher les icônes et les libellés des destinations.
- [x] Conserver les séparateurs et l’administration en bas.
- [x] Prévoir la superposition de la partie déployée au contenu via un `Stack` parent.
- [x] Ne pas redimensionner le contenu dans l’exemple d’intégration.
- [x] Ajouter une ombre sur le bord droit.

### Interaction souris

- [x] Déployer le contrôle avec un `MouseRegion` englobant toute la sidebar.
- [x] Maintenir le contrôle ouvert tant que la souris reste dans la zone déployée.
- [x] Replier le contrôle lorsque la souris quitte la zone déployée.
- [x] Éviter les changements d’état lors du passage entre les destinations.
- [ ] Tester la fiabilité des clics pendant et après l’animation sous Windows.

## API Python

- [x] Nom public : `PaperNestHoverSidebar`.
- [x] Classe typée : `PaperNestHoverSidebarDestination`.
- [x] Définir `destinations` et `secondary_destinations`.
- [x] Définir `selected_index`.
- [x] Définir `collapsed_width` et `expanded_width`.
- [x] Définir `animation_duration` et la courbe d’animation.
- [x] Définir le bloc de marque avec `brand_icon`, `brand_title` et `brand_subtitle`.
- [x] Définir les couleurs, espacements, arrondis, ombre et état sélectionné.
- [x] Définir `on_change`, `on_expand` et `on_collapse`.
- [x] Utiliser l’état `disabled` natif sur chaque destination.
- [x] Ajouter les méthodes publiques `expand_sidebar()` et `collapse_sidebar()`.
- [x] Exporter le contrôle depuis `papernestextension.controls` et `papernestextension`.

## Architecture Flutter

- [x] Construire le contrôle avec un `MouseRegion` englobant toute la surface animée.
- [x] Utiliser un `AnimatedContainer` pour les largeurs compacte et déployée.
- [x] Prévoir une zone compacte permanente dans le layout parent.
- [x] Documenter l’intégration superposée avec un `Stack`.
- [x] Animer l’apparition des libellés avec `AnimatedOpacity` et `ClipRect`.
- [x] Conserver les destinations principales en haut et les destinations secondaires en bas.
- [x] Synchroniser l’index sélectionné depuis Python et depuis les clics Flutter.
- [x] Enregistrer le contrôle dans `Extension.createWidget()`.
- [ ] Vérifier le comportement réel de tous les paramètres avec Flet 0.85.3.

## Étude de `NavigationDrawer`

- [x] Vérifier le fonctionnement Python du contrôle natif.
- [x] Vérifier l’implémentation Dart du contrôle natif.
- [x] Confirmer qu’il repose sur une ouverture modale et non sur une rail permanente au survol.
- [x] Confirmer l’absence d’API native pour l’expansion automatique au survol.
- [x] Décider de construire un contrôle dédié plutôt que de forker immédiatement `NavigationDrawer`.

## Exemple PaperNestExtension

- [x] Créer `hover_sidebar_example.py` avec les cinq destinations de PaperNest.
- [x] Placer le contrôle au-dessus du contenu dans un `Stack`.
- [x] Réserver uniquement la largeur compacte dans le contenu.
- [ ] Tester le déploiement au survol.
- [ ] Tester le repli à la sortie de la souris.
- [ ] Tester les clics pendant et après l’animation.
- [ ] Tester la sélection programmée.
- [ ] Tester différentes largeurs.
- [ ] Tester le futur logo compact et complet.
- [ ] Tester le comportement sous Windows.
- [ ] Valider le build Windows de l’exemple.

## Intégration PaperNest

- [ ] Créer un wrapper thématique léger uniquement si nécessaire.
- [ ] Réserver la largeur compacte dans la structure principale.
- [ ] Superposer la largeur supplémentaire au contenu.
- [ ] Reprendre les destinations et callbacks actuels de `MainWindow`.
- [ ] Conserver `navigate_to`, la destruction des vues et leur rafraîchissement.
- [ ] Utiliser le futur logo PaperNest.
- [ ] Comparer le rendu à la sidebar actuelle.
- [ ] Supprimer l’ancienne sidebar seulement après validation complète.

## Validation finale

- [ ] Valider visuellement l’état replié.
- [ ] Valider visuellement l’état déployé.
- [ ] Confirmer que le contenu ne bouge jamais.
- [ ] Confirmer que la sidebar recouvre correctement le contenu.
- [ ] Confirmer le comportement de toutes les destinations.
- [ ] Valider le comportement réel avec l’utilisateur.
- [ ] Valider le build Windows de PaperNest.
- [ ] Mettre à jour les roadmaps et changelogs des deux projets.

## Critère de finalisation

Le contrôle sera terminé lorsque la rail compacte restera visible en permanence, que son déploiement et son repli au survol seront fluides, que la partie ouverte se superposera au contenu sans le redimensionner et que tous les parcours PaperNest seront validés sous Windows.
