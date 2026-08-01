# Roadmap — PaperNestButton

## État

Chantier planifié.

`PaperNestButton` sera un contrôle public Python + Flutter dédié à PaperNestExtension et PaperNest. Il devra également fournir une base Flutter réutilisable par les contrôles internes de l’extension, notamment les actions des dialogues des pickers.

Ce chantier ne doit pas interrompre la migration actuelle de `PaperNestAlertDialog` et des pickers. Il commencera après stabilisation de cette migration.

## Objectif

Créer un bouton PaperNest cohérent, personnalisable et réutilisable :

- côté Python dans PaperNest ;
- côté Flutter dans PaperNestExtension ;
- dans les actions de `PaperNestAlertDialog` et des pickers ;
- sans dupliquer les variantes et les animations entre Python et Flutter.

## Étude préalable

- [ ] Consulter l’API Python des boutons Flet pour la version retenue.
- [ ] Consulter les implémentations Flutter correspondantes.
- [ ] Auditer les wrappers actuels de PaperNest : `PrimaryButton`, `SecondaryButton`, `GhostButton`, boutons danger et actions avec icône.
- [ ] Recenser les propriétés réellement utilisées dans PaperNest.
- [ ] Identifier les comportements absents des boutons Flet natifs.
- [ ] Choisir le contrôle Flet le plus pertinent comme base ou décider d’un contrôle autonome.

## API publique envisagée

- [ ] Créer `PaperNestButton`.
- [ ] Créer une enum `PaperNestButtonVariant`.
- [ ] Prévoir au minimum les variantes : `primary`, `secondary`, `ghost`, `danger` et `success` si un besoin réel est confirmé.
- [ ] Accepter un texte ou un contrôle Flet comme contenu.
- [ ] Accepter une icône avant ou après le texte.
- [ ] Gérer `disabled`, `autofocus`, tooltip, données et événements usuels.
- [ ] Préserver la personnalisation complète des couleurs, bordures, rayons, paddings et typographie.
- [ ] Prévoir les états normal, focused, hovered, pressed et disabled.

## Effets visuels

- [ ] Ajouter `gradient`.
- [ ] Ajouter `focused_gradient`.
- [ ] Étudier `hover_gradient` et `pressed_gradient` uniquement s’ils apportent un gain réel.
- [ ] Ajouter une animation de survol configurable.
- [ ] Ajouter une animation de clic configurable.
- [ ] Prévoir au minimum durée, courbe, échelle et éventuellement translation légère.
- [ ] Respecter les états désactivés et l’accessibilité.
- [ ] Éviter les animations excessives dans PaperNest.

## Architecture Flutter

- [ ] Créer un widget Flutter interne partagé pour le rendu et les variantes.
- [ ] Utiliser ce widget dans le contrôle public `PaperNestButton`.
- [ ] Permettre son utilisation directe par les contrôles Flutter internes de l’extension.
- [ ] Utiliser ce rendu pour les actions internes de `PaperNestAlertDialog`, `PaperNestColorPicker` et `PaperNestIconPicker` lorsque la migration sera prête.
- [ ] Regrouper variantes, styles et animations par thèmes cohérents, sans multiplier les petits fichiers helpers.
- [ ] Intégrer ce travail à l’architecture suivie par `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`.

## Intégration PaperNest

- [ ] Créer un wrapper thématique minimal si nécessaire.
- [ ] Remplacer progressivement `PrimaryButton`, `SecondaryButton`, `GhostButton` et les variantes danger.
- [ ] Préserver les API applicatives utiles ou fournir une migration claire.
- [ ] Vérifier tous les dialogues, panneaux et barres d’actions.
- [ ] Supprimer les anciens wrappers uniquement après validation complète.

## Application d’exemple

- [ ] Créer un panneau dédié aux boutons.
- [ ] Ajouter une page ou une section `Actions` dans l’application d’exemple.
- [ ] Présenter toutes les variantes.
- [ ] Présenter les gradients normal et focused.
- [ ] Présenter les états hover, click, disabled et loading si ce dernier est retenu.
- [ ] Vérifier le clavier, le focus et le curseur.

## Validation

- [ ] Valider l’API Python.
- [ ] Valider le widget Flutter interne.
- [ ] Valider les animations sous Windows.
- [ ] Vérifier l’absence de décalage de layout pendant les animations.
- [ ] Vérifier les actions des dialogues et pickers.
- [ ] Valider l’intégration PaperNest.
- [ ] Valider `flet run`.
- [ ] Valider les builds Windows de PaperNestExtension et PaperNest.
- [ ] Faire valider visuellement et fonctionnellement le contrôle par l’utilisateur.

## Critère de finalisation

Le chantier sera terminé lorsque `PaperNestButton` remplacera proprement les wrappers nécessaires de PaperNest, que ses variantes et animations seront partagées avec les actions Flutter internes, et que les deux projets auront été validés sous Windows sans régression.
