# Roadmap — PaperNestGlideRail

## État

`PaperNestGlideRail` est officiellement terminé.

Le contrôle a été implémenté, construit, testé et validé sous Windows dans l’exemple PaperNestExtension puis dans l’application PaperNest. L’évolution ciblée permettant à `brand_title` et `brand_subtitle` d’accepter des contrôles Flet personnalisés a également été reconstruite, testée et validée.

Aucune évolution supplémentaire n’est prévue tant qu’un besoin réel n’apparaît pas.

## Objectif validé

Créer une rail de navigation compacte qui reste visible en permanence, se déploie au survol, se replie lorsque la souris quitte sa zone et recouvre le contenu sans modifier sa largeur.

## Comportement

- [x] Rail compacte affichant uniquement la marque et les icônes.
- [x] Déploiement automatique au survol.
- [x] Repli automatique à la sortie de la souris.
- [x] Animation fluide de largeur.
- [x] Apparition progressive des libellés.
- [x] Superposition au contenu avec un `Stack` parent.
- [x] Destinations principales en haut.
- [x] Destinations secondaires ancrées en bas.
- [x] État sélectionné synchronisé entre Python et Flutter.
- [x] Effet de survol coloré et animation légère de mise à l’échelle.
- [x] Tooltips lorsque la rail est repliée.
- [x] Padding général et padding des destinations.
- [x] Support des icônes Flet et des contrôles personnalisés, notamment `ft.Image` pour les PNG et SVG.

## API publique

- [x] `PaperNestGlideRail`.
- [x] `PaperNestGlideRailDestination`.
- [x] `destinations` et `secondary_destinations`.
- [x] `selected_index`.
- [x] `collapsed_width` et `expanded_width`.
- [x] Paramètres d’animation de la rail et du survol.
- [x] Bloc de marque personnalisable.
- [x] `brand_title` accepte une chaîne ou un contrôle Flet tel que `ft.Text`.
- [x] `brand_subtitle` accepte une chaîne ou un contrôle Flet tel que `ft.Text`.
- [x] Compatibilité conservée avec les chaînes utilisées par l’API initiale.
- [x] Couleurs, espacements, arrondis, ombre et indicateur sélectionné.
- [x] Événements `on_change`, `on_expand` et `on_collapse`.
- [x] Méthodes `expand_rail()` et `collapse_rail()`.
- [x] État `disabled` sur la rail et ses destinations.

## Implémentation Flutter

- [x] `MouseRegion` sur toute la surface animée.
- [x] `AnimatedContainer` pour la largeur.
- [x] `AnimatedOpacity` pour les libellés.
- [x] `AnimatedScale` pour le survol des destinations.
- [x] `Spacer` pour les destinations secondaires.
- [x] Gestion du padding sans casser l’alignement compact.
- [x] Support des contrôles d’icône personnalisés avec `buildIconOrWidget()`.
- [x] Support des contrôles personnalisés pour le titre et le sous-titre de marque.
- [x] Enregistrement dans `Extension.createWidget()`.

## Exemple PaperNestExtension

- [x] Exemple intégré directement dans `main.py`.
- [x] Utilisation dans le même build que les autres contrôles de l’extension.
- [x] Démonstration du `Stack` et de la largeur compacte réservée.
- [x] Démonstration de `brand_title=ft.Text(...)`.
- [x] Démonstration de `brand_subtitle=ft.Text(...)`.
- [x] Test du déploiement et du repli.
- [x] Test des clics et de la sélection.
- [x] Test du padding.
- [x] Test de l’animation de survol.
- [x] Validation du build Windows après toutes les évolutions.
- [x] Validation visuelle et fonctionnelle finale par l’utilisateur.

## Intégration PaperNest

- [x] Remplacer la sidebar historique par `PaperNestGlideRail`.
- [x] Réserver uniquement la largeur compacte dans la mise en page.
- [x] Reprendre toutes les destinations et tous les callbacks.
- [x] Centraliser la navigation dans `src/app/navigation/navigation.py`.
- [x] Utiliser le symbole final PaperNest.
- [x] Utiliser des `ft.Text` personnalisés pour le titre et le sous-titre de marque.
- [x] Valider tous les parcours de navigation.
- [x] Supprimer l’ancienne sidebar après validation complète.

## Critère de finalisation

- [x] Exemple Windows validé.
- [x] Intégration PaperNest validée.
- [x] API finale validée.
- [x] Build Windows validé.
- [x] Validation explicite par l’utilisateur.

## Règle de maintenance

Le contrôle est clos. Ne pas ajouter d’options par anticipation. Toute évolution future devra répondre à une limite concrète rencontrée dans une application réelle.