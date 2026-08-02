# Roadmap — PaperNestButton

## État

Première implémentation créée dans PaperNestExtension, en attente de compilation et de validation sous Windows.

Les sources Flet de `Button` et `ButtonStyle`, côté Python et Flutter, ont été étudiées. L’architecture conserve `ButtonStyle` pour les propriétés Material natives et utilise une surface Flutter PaperNest partagée pour les gradients, le chargement et les transformations animées.

## Objectif

Créer un bouton PaperNest cohérent, personnalisable et réutilisable :

- côté Python dans PaperNest ;
- côté Flutter dans PaperNestExtension ;
- dans les actions internes des dialogues et pickers ;
- sans dupliquer variants, styles et animations.

## Sources Flet étudiées

- [x] Étudier `Button` côté Python.
- [x] Étudier `ButtonControl` côté Flutter.
- [x] Étudier `ButtonStyle` côté Python.
- [x] Étudier `parseButtonStyle()` côté Flutter.
- [x] Confirmer la gestion Material par état.
- [x] Confirmer que les gradients, l’échelle et la translation exigent un rendu complémentaire.

## Audit PaperNest

- [x] Relire `app/theme/buttons.py`.
- [x] Inventorier `AppButton`, `PrimaryButton`, `SecondaryButton`, `GhostButton`, `OutlineButton`, `DangerButton` et `SuccessButton`.
- [x] Identifier `loading`, `compact`, tooltip, largeur et expansion.
- [x] Laisser `IconAction` et `MenuAction` hors de la première migration.
- [ ] Recenser tous les usages applicatifs avant l’intégration finale.

## API Python

- [x] Créer `PaperNestButton`.
- [x] Créer `PaperNestButtonVariant`.
- [x] Ajouter `primary`, `secondary`, `ghost`, `outline`, `danger` et `success`.
- [x] Accepter un contenu chaîne ou contrôle Flet.
- [x] Accepter une icône leading et une icône trailing.
- [x] Conserver `style: ButtonStyle`.
- [x] Ajouter `color`, `bgcolor` et `elevation`.
- [x] Ajouter `loading`, `loading_text` et les propriétés du loader.
- [x] Ajouter les gradients normal, hover, focus, pressed et disabled.
- [x] Ajouter les paramètres d’échelle, translation, durée et courbe.
- [x] Conserver URL, autofocus, clip et les événements usuels.
- [x] Exposer `focus()` et `set_loading()`.
- [x] Exporter le contrôle depuis les API publiques.
- [ ] Vérifier la compatibilité exacte des types pendant la compilation.

## Architecture Flutter

- [x] Créer `PaperNestButtonSurface` comme widget partagé.
- [x] Créer `PaperNestButtonControl`.
- [x] Réutiliser `parseButtonStyle()` au lieu de recopier son parseur.
- [x] Résoudre les variants dans la surface partagée.
- [x] Résoudre les gradients dans l’ordre disabled, pressed, focused, hovered, normal.
- [x] Conserver le ripple et le focus Material.
- [x] Ajouter `AnimatedContainer`, `AnimatedScale` et `AnimatedSlide`.
- [x] Gérer le loader sans modification des contraintes du layout.
- [x] Gérer les événements click, long press, hover, focus et blur.
- [x] Enregistrer le contrôle dans `Extension.createWidget()`.
- [ ] Compiler l’extension et corriger les incompatibilités éventuelles.
- [ ] Extraire les palettes/variants dans un module thématique seulement si leur réutilisation le justifie.

## Application d’exemple

- [x] Créer une page `Actions` indépendante.
- [x] Ajouter la destination dans `PaperNestGlideRail`.
- [x] Présenter toutes les variantes.
- [x] Présenter gradients normal, hover et pressed.
- [x] Présenter une icône trailing.
- [x] Présenter loading et disabled.
- [ ] Ajouter un exemple compact après validation de l’API.
- [ ] Ajouter un contrôle personnalisé comme contenu.
- [ ] Tester clavier, focus, curseur et URL.

## Intégration Flutter interne

- [ ] Utiliser la surface partagée dans les actions internes du ColorPicker.
- [ ] Utiliser la surface partagée dans les actions internes de l’IconPicker.
- [ ] Étudier son usage dans les autres contrôles Flutter.
- [ ] Ne migrer ces actions qu’après validation du contrôle public.

## Intégration PaperNest

- [ ] Créer un wrapper thématique minimal si nécessaire.
- [ ] Remplacer progressivement `AppButton` et ses variantes.
- [ ] Préserver `text`, `loading`, `compact`, `set_loading` et les styles personnalisés.
- [ ] Vérifier tous les dialogues, panneaux et barres d’actions.
- [ ] Conserver `IconAction` et `MenuAction` jusqu’à une étude séparée.
- [ ] Supprimer les anciens wrappers uniquement après validation complète.

## Validation

- [ ] Valider les imports Python.
- [ ] Valider la compilation Flutter.
- [ ] Valider `flet run`.
- [ ] Tester toutes les variantes.
- [ ] Tester les gradients par état.
- [ ] Tester hover, pressed, focus, clavier et curseur.
- [ ] Tester loading et disabled.
- [ ] Vérifier l’absence de décalage de layout.
- [ ] Valider le build Windows de l’exemple.
- [ ] Valider l’intégration PaperNest.
- [ ] Valider le build Windows de PaperNest.
- [ ] Faire valider visuellement et fonctionnellement le contrôle par l’utilisateur.

## Critère de finalisation

Le chantier sera terminé lorsque `PaperNestButton` remplacera proprement les wrappers nécessaires de PaperNest, que ses variants et animations seront partagés avec les actions Flutter internes, et que les deux projets auront été validés sous Windows sans régression.
