# Roadmap — PaperNestGlideRail

## État

Le contrôle `PaperNestGlideRail` est implémenté, construit, testé et validé sous Windows par l’utilisateur.

Son périmètre fonctionnel est considéré comme terminé. Aucune fonction supplémentaire n’est prévue tant qu’un besoin réel n’apparaît pas dans PaperNest.

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
- [x] Enregistrement dans `Extension.createWidget()`.

## Exemple PaperNestExtension

- [x] Exemple intégré directement dans `main.py`.
- [x] Utilisation dans le même build que les autres contrôles de l’extension.
- [x] Démonstration du `Stack` et de la largeur compacte réservée.
- [x] Test du déploiement et du repli.
- [x] Test des clics et de la sélection.
- [x] Test du padding.
- [x] Test de l’animation de survol.
- [x] Validation du build Windows.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.

## Intégration PaperNest

- [ ] Remplacer la sidebar actuelle par `PaperNestGlideRail`.
- [ ] Réserver uniquement la largeur compacte dans `MainWindow`.
- [ ] Reprendre les destinations et callbacks actuels.
- [ ] Utiliser le logo final PaperNest.
- [ ] Valider tous les parcours de navigation.
- [ ] Supprimer l’ancienne sidebar uniquement après validation complète.

## Règle d’évolution

Ne pas ajouter d’options visuelles ou fonctionnelles par anticipation. Toute évolution future devra répondre à une limite constatée pendant l’intégration réelle dans PaperNest.
