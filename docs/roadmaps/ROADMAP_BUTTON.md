# Roadmap — PaperNestButton

## État

Chantier actif.

`PaperNestAlertDialog` est terminé. Les sources Flet de `Button` côté Python et Flutter ont été fournies et constituent la base officielle de l’étude.

Les sources de `ButtonStyle` côté Python et Dart sont encore nécessaires avant de figer l’architecture et l’API : elles permettront de distinguer ce qui doit rester géré par le style Material de ce qui justifie une implémentation propre à PaperNest.

## Objectif

Créer un bouton PaperNest cohérent, personnalisable et réutilisable :

- côté Python dans PaperNest ;
- côté Flutter dans PaperNestExtension ;
- dans les actions de `PaperNestAlertDialog` et des pickers ;
- sans dupliquer les variants, styles et animations entre Python et Flutter.

## Sources Flet

### Button Python

- [x] Consulter la classe `Button` et son héritage `LayoutControl` / `AdaptiveControl`.
- [x] Recenser `content`, `icon`, `icon_color`, `color`, `bgcolor`, `elevation`, `style`, `autofocus`, `clip_behavior`, `url` et les événements.
- [x] Vérifier la validation exigeant au minimum un contenu ou une icône visible.
- [x] Vérifier la fusion de `color`, `bgcolor` et `elevation` dans `ButtonStyle` via `before_update()`.
- [x] Vérifier la méthode `focus()`.

### Button Flutter

- [x] Consulter `ButtonControl` et son `FocusNode`.
- [x] Vérifier les événements click, long press, hover, focus et blur.
- [x] Vérifier l’utilisation de `parseButtonStyle()`.
- [x] Vérifier les rendus FilledButton, FilledTonalButton, TextButton, OutlinedButton et ElevatedButton.
- [x] Vérifier la construction avec ou sans icône.
- [x] Vérifier la restitution via `LayoutControl`.

### ButtonStyle

- [ ] Consulter la définition Python de `ButtonStyle`.
- [ ] Consulter le parseur et les modèles Dart associés.
- [ ] Inventorier les propriétés Material déjà gérées par état.
- [ ] Vérifier la sérialisation des valeurs normales, hovered, focused, pressed et disabled.
- [ ] Déterminer quelles animations peuvent utiliser le style natif et lesquelles exigent un widget PaperNest.

## Audit PaperNest

- [ ] Relire entièrement `app/theme/buttons.py`.
- [ ] Inventorier `PrimaryButton`, `SecondaryButton`, `GhostButton`, `DangerButton`, `SuccessButton` et leurs usages.
- [ ] Recenser les propriétés réellement utilisées dans les dialogues, panneaux et barres d’actions.
- [ ] Étudier les états loading et disabled actuels.
- [ ] Identifier les comportements absents des boutons Flet natifs.

## API publique envisagée

- [ ] Créer `PaperNestButton`.
- [ ] Créer `PaperNestButtonVariant`.
- [ ] Prévoir au minimum `primary`, `secondary`, `ghost`, `danger` et `success`.
- [ ] Accepter un texte ou un contrôle Flet comme contenu.
- [ ] Accepter une icône ou un contrôle avant ou après le contenu.
- [ ] Gérer `disabled`, `autofocus`, URL, tooltip et événements usuels.
- [ ] Préserver la personnalisation des couleurs, bordures, rayons, paddings, typographie, élévation et ombre.
- [ ] Prévoir les états normal, hovered, focused, pressed et disabled.
- [ ] Étudier un état loading natif au contrôle.

## Effets visuels

- [ ] Ajouter `gradient`.
- [ ] Ajouter `focused_gradient`.
- [ ] Étudier `hover_gradient`, `pressed_gradient` et `disabled_gradient`.
- [ ] Ajouter une animation de survol configurable.
- [ ] Ajouter une animation de clic configurable.
- [ ] Prévoir durée, courbe, échelle et éventuellement une translation légère.
- [ ] Empêcher tout décalage de layout pendant les animations.
- [ ] Respecter clavier, focus, disabled et accessibilité.
- [ ] Éviter les animations excessives dans PaperNest.

## Architecture Flutter

- [ ] Déterminer si le contrôle peut s’appuyer sur les boutons Material natifs enveloppés dans une surface animée.
- [ ] Créer un widget Flutter interne partagé pour le rendu et les variants.
- [ ] Utiliser ce widget dans le contrôle public `PaperNestButton`.
- [ ] Permettre son utilisation directe dans les contrôles Flutter internes de l’extension.
- [ ] Utiliser progressivement ce rendu pour les actions internes des dialogues et pickers.
- [ ] Regrouper variants, styles et animations par thèmes cohérents sans multiplier les helpers.
- [ ] Coordonner ce travail avec `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`.

## Intégration PaperNest

- [ ] Créer un wrapper thématique minimal seulement s’il apporte une valeur réelle.
- [ ] Remplacer progressivement les wrappers de `app/theme/buttons.py`.
- [ ] Préserver leurs API utiles ou fournir une migration claire.
- [ ] Vérifier tous les dialogues, panneaux et barres d’actions.
- [ ] Supprimer les anciens wrappers uniquement après validation complète.

## Application d’exemple

- [ ] Créer un panneau dédié aux boutons.
- [ ] Ajouter une page ou section `Actions` dans l’application d’exemple.
- [ ] Présenter tous les variants.
- [ ] Présenter gradients et états interactifs.
- [ ] Présenter disabled et loading si retenu.
- [ ] Vérifier clavier, focus et curseur.

## Validation

- [ ] Valider l’API Python.
- [ ] Valider le widget Flutter interne.
- [ ] Valider les animations sous Windows.
- [ ] Vérifier l’absence de décalage de layout.
- [ ] Vérifier les actions des dialogues et pickers.
- [ ] Valider l’intégration PaperNest.
- [ ] Valider `flet run`.
- [ ] Valider les builds Windows des deux projets.
- [ ] Faire valider visuellement et fonctionnellement le contrôle par l’utilisateur.

## Critère de finalisation

Le chantier sera terminé lorsque `PaperNestButton` remplacera proprement les wrappers nécessaires de PaperNest, que ses variants et animations seront partagés avec les actions Flutter internes, et que les deux projets auront été validés sous Windows sans régression.
