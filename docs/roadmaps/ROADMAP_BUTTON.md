# Roadmap — PaperNestButton

## État

Architecture corrigée après la première validation visuelle.

Le contrôle Flutter ne gère plus aucune variante métier. Les styles `primary`, `secondary`, `ghost`, `outline`, `danger` et `success` sont construits exclusivement côté Python avec `bgcolor`, `color` et `ButtonStyle`.

Flutter reste limité aux fonctions impossibles à réaliser proprement en Python : gradient, gradient de survol, animation de survol, animation de clic et rendu du chargement.

## Principes

- [x] Garder `ButtonStyle` comme source de vérité des styles Material.
- [x] Gérer toutes les variantes côté Python.
- [x] Supprimer `PaperNestButtonVariant` de l’API publique.
- [x] Supprimer toute palette codée en dur dans Flutter.
- [x] Ne pas utiliser PaperNestButton pour imposer le style des autres contrôles.
- [x] Limiter Flutter au rendu technique complémentaire.

## API Python

- [x] Créer `PaperNestButton`.
- [x] Accepter un contenu texte ou contrôle Flet.
- [x] Accepter une icône leading et une icône trailing.
- [x] Conserver `color`, `bgcolor`, `elevation` et `style`.
- [x] Conserver `gradient` et `hover_gradient` uniquement.
- [x] Supprimer `focused_gradient`, `pressed_gradient` et `disabled_gradient`.
- [x] Conserver `hover_scale` et `click_scale`.
- [x] Conserver `hover_offset_y` et `click_offset_y`.
- [x] Conserver durée et courbe d’animation.
- [x] Conserver `loading`, `loading_text` et le loader personnalisable.
- [x] Conserver URL, autofocus, clip, focus et événements usuels.
- [x] Exposer `focus()` et `set_loading()`.

## Architecture Flutter

- [x] Créer `PaperNestButtonControl`.
- [x] Créer `PaperNestButtonSurface`.
- [x] Réutiliser `parseButtonStyle()`.
- [x] Supprimer la résolution des variantes côté Flutter.
- [x] Supprimer les gradients focus, pressed et disabled.
- [x] Résoudre uniquement `hover_gradient` puis `gradient`.
- [x] Conserver le ripple, le focus et les états Material natifs.
- [x] Ajouter l’animation de survol.
- [x] Ajouter l’animation de clic.
- [x] Gérer le loader sans dépendre d’un autre contrôle PaperNest.

## Chargement

`loading=True` sert à :

- désactiver temporairement le clic pendant une opération asynchrone ;
- remplacer l’icône par un indicateur de progression ;
- afficher éventuellement `loading_text` ;
- éviter les doubles soumissions dans les formulaires et dialogues.

## Application d’exemple

- [x] Créer la page `Actions`.
- [x] Construire toutes les variantes côté Python.
- [x] Présenter des couleurs réellement différentes.
- [x] Présenter gradient et gradient de survol.
- [x] Présenter animation de survol et animation de clic.
- [x] Présenter loading, disabled et icône trailing.
- [ ] Valider le rendu sous Windows.
- [ ] Valider le focus clavier et le curseur.
- [ ] Valider le build Windows.

## Intégration PaperNest

- [ ] Créer les wrappers Python thématiques dans `app/theme/buttons.py`.
- [ ] Remplacer progressivement `AppButton` et ses variantes.
- [ ] Préserver `text`, `loading`, `compact`, largeur, hauteur et expansion.
- [ ] Conserver `IconAction` et `MenuAction` hors de cette migration.
- [ ] Supprimer les anciens wrappers seulement après validation complète.

## Hors périmètre

- Les variantes ne doivent jamais être résolues dans Flutter.
- Les actions des pickers ne doivent pas imposer PaperNestButton.
- PaperNestAlertDialog ne doit pas dépendre de PaperNestButton.
- Les autres contrôles restent composés côté Python.

## Validation

- [ ] Valider les imports Python.
- [ ] Valider `flet run`.
- [ ] Tester les styles Python.
- [ ] Tester gradient et hover_gradient.
- [ ] Tester hover et clic.
- [ ] Tester loading et disabled.
- [ ] Vérifier l’absence de décalage de layout.
- [ ] Valider le build Windows de l’exemple.
- [ ] Valider l’intégration et le build Windows de PaperNest.

## Critère de finalisation

Le chantier sera terminé lorsque PaperNestButton offrira uniquement les capacités techniques complémentaires attendues, que toutes les variantes seront contrôlées depuis Python et que l’intégration PaperNest sera validée sous Windows.
