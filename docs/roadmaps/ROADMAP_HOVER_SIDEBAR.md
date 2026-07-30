# Roadmap — Sidebar déployable au survol

## État

Étude ouverte. Le contrôle sera développé dans PaperNestExtension à partir du besoin réel de PaperNest.

Le `NavigationDrawer` natif Flet n’est pas retenu comme base directe : son fonctionnement modal par ouverture et fermeture ne correspond pas à une rail d’icônes permanente qui s’agrandit au survol.

## Objectif

Créer un contrôle de navigation latérale qui reste toujours visible sous forme compacte, s’agrandit avec une animation lorsque la souris entre dans sa zone, se replie lorsque la souris en sort et se superpose au contenu sans modifier sa largeur.

## Comportement attendu

### État replié

- [ ] Afficher uniquement le logo compact PaperNest.
- [ ] Afficher un séparateur.
- [ ] Afficher uniquement les icônes des destinations principales.
- [ ] Conserver un espace extensible entre les destinations principales et l’administration.
- [ ] Afficher un séparateur avant l’administration.
- [ ] Afficher uniquement l’icône Administration.
- [ ] Conserver une largeur compacte fixe.
- [ ] Réserver uniquement cette largeur compacte dans la mise en page PaperNest.

### État déployé

- [ ] Agrandir la sidebar horizontalement avec une animation fluide.
- [ ] Afficher le logo PaperNest complet.
- [ ] Afficher les icônes et les libellés des destinations.
- [ ] Conserver les séparateurs et l’administration en bas.
- [ ] Superposer la partie déployée au contenu.
- [ ] Ne jamais redimensionner ni déplacer le contenu pendant l’animation.
- [ ] Ajouter une ombre ou une séparation visuelle sur le bord droit.

### Interaction souris

- [ ] Déployer le contrôle lorsque la souris entre n’importe où dans la sidebar compacte.
- [ ] Maintenir le contrôle ouvert tant que la souris reste dans toute la zone déployée.
- [ ] Replier le contrôle lorsque la souris quitte entièrement la zone déployée.
- [ ] Éviter les ouvertures et fermetures répétées lors du passage entre les destinations.
- [ ] Garantir que les clics sur les destinations restent fiables pendant et après l’animation.

## API Python à définir

- [ ] Définir le nom public final du contrôle.
- [ ] Définir une classe de destination typée.
- [ ] Définir `selected_index`.
- [ ] Définir `collapsed_width` et `expanded_width`.
- [ ] Définir `animation_duration` et la courbe d’animation.
- [ ] Définir les contrôles ou assets de logo compact et complet.
- [ ] Définir les couleurs, espacements, arrondis, ombre et indicateur sélectionné.
- [ ] Définir les événements `on_change`, `on_expand` et `on_collapse`.
- [ ] Prévoir `disabled` pour les destinations.
- [ ] Permettre des contrôles libres tels que séparateurs, en-têtes et espaces extensibles si nécessaire.

## Architecture Flutter

- [ ] Construire le contrôle avec un `MouseRegion` englobant toute la surface animée.
- [ ] Utiliser un conteneur animé pour passer de la largeur compacte à la largeur déployée.
- [ ] Conserver une zone compacte permanente dans le layout parent.
- [ ] Afficher l’extension de largeur dans une couche superposée.
- [ ] Utiliser un `Stack` ou une structure équivalente pour empêcher le redimensionnement du contenu.
- [ ] Animer l’apparition des libellés sans provoquer de débordement.
- [ ] Conserver les destinations principales en haut et l’administration en bas.
- [ ] Synchroniser l’état sélectionné depuis Python et depuis les clics Flutter.
- [ ] Gérer correctement le survol pendant l’animation.

## Étude de `NavigationDrawer`

- [x] Vérifier le fonctionnement Python du contrôle natif.
- [x] Vérifier l’implémentation Dart du contrôle natif.
- [x] Confirmer qu’il repose sur une ouverture modale et non sur une rail permanente au survol.
- [x] Confirmer l’absence d’API native pour l’expansion automatique au survol.
- [x] Décider de ne pas forker immédiatement `NavigationDrawer`.
- [ ] Réutiliser seulement ses idées utiles de destinations, d’index sélectionné et de personnalisation visuelle.

## Exemple PaperNestExtension

- [ ] Créer un exemple dédié avec les cinq destinations de PaperNest.
- [ ] Tester le déploiement au survol.
- [ ] Tester le repli à la sortie de la souris.
- [ ] Tester les clics pendant et après l’animation.
- [ ] Tester la sélection programmée.
- [ ] Tester différentes largeurs.
- [ ] Tester le logo compact et le logo complet.
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