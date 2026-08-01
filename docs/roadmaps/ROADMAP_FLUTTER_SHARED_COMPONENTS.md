# Roadmap — Architecture Flutter partagée

## État

Chantier futur identifié pendant la validation de `PaperNestAlertDialog`.

Ce chantier ne doit pas interrompre la migration actuelle des dialogues. Il sera traité dans une mise à jour dédiée après stabilisation de `PaperNestAlertDialog` et de son intégration.

## Constat

Plusieurs contrôles Flutter de PaperNestExtension reconstruisent localement des fonctions proches ou identiques :

- création des `InputBorder` selon le focus ;
- résolution des couleurs et largeurs de bordure ;
- construction des décorations de champs ;
- gestion du remplissage, des paddings et des styles ;
- variantes visuelles ;
- boutons d’action internes aux dialogues des pickers ;
- surfaces, en-têtes et actions de dialogues ;
- conversions et normalisations de valeurs répétées.

`form_field.dart` centralise déjà une partie des responsabilités liées aux champs, mais le chantier ne consiste pas à découper ce fichier pour lui-même. Le vrai principe est global : lorsqu’une même fonction existe dans plusieurs contrôles, elle doit être extraite dans un module commun regroupé par thème.

`PaperNestDialogSurface` constitue le premier composant partagé créé dans cette direction.

## Objectif

Réduire la duplication, séparer les responsabilités et garantir une apparence cohérente entre tous les contrôles sans modifier leur API publique ni leur comportement validé.

## Principes

- Extraire uniquement du code réellement dupliqué.
- Regrouper les helpers par famille cohérente de responsabilités.
- Ne jamais créer un fichier par petite fonction.
- Éviter à la fois les fichiers monolithiques et la multiplication de dizaines de helpers.
- Conserver les API Python publiques inchangées.
- Migrer et valider un contrôle à la fois.
- Ne pas mélanger ce chantier avec une migration fonctionnelle en cours.

## Organisation thématique envisagée

La structure exacte sera décidée après audit, mais les responsabilités pourront être regroupées autour de quelques familles :

- `fields` ou `inputs` : bordures, décorations et comportements communs des champs ;
- `dialogs` : surface, route, barrière, cycle de fermeture et actions internes ;
- `variants` ou `styles` : variantes visuelles partagées lorsque plusieurs contrôles les utilisent ;
- `values` : conversion et normalisation de valeurs communes ;
- `interaction` : focus, survol, clavier et curseur lorsque la logique est réellement identique.

Il ne s’agit pas d’imposer ces noms ni de créer systématiquement tous ces fichiers. Chaque module devra couvrir une responsabilité thématique suffisamment large et réellement réutilisée.

## Audit global

- [ ] Relire entièrement les widgets et helpers Flutter existants.
- [ ] Inventorier les fonctions identiques ou presque identiques dans plusieurs contrôles.
- [ ] Identifier les responsabilités déjà couvertes par `form_field.dart`.
- [ ] Comparer les méthodes `_border(...)` des ColorPicker, DatePicker et IconPicker.
- [ ] Comparer les constructions d’`InputDecoration`.
- [ ] Comparer les gestions du focus, du survol, du clavier et du curseur.
- [ ] Comparer les conversions et normalisations de valeurs.
- [ ] Inventorier les variantes actuellement définies localement.
- [ ] Déterminer les regroupements thématiques utiles avant de créer de nouveaux fichiers.

## Champs et bordures

- [ ] Créer ou étendre un module partagé de champs lorsque l’audit confirme le gain.
- [ ] Centraliser `border`, `enabledBorder`, `focusedBorder` et `disabledBorder`.
- [ ] Centraliser largeur, couleur, rayon et type de bordure.
- [ ] Réutiliser les responsabilités déjà présentes dans `form_field.dart` au lieu de les recopier.
- [ ] Centraliser les propriétés communes d’`InputDecoration` lorsque cela simplifie réellement les contrôles.
- [ ] Laisser chaque contrôle fournir son contenu, ses icônes et ses comportements spécifiques.

## Focus, survol et interaction

- [ ] Étudier un module partagé pour les interactions réellement identiques.
- [ ] Centraliser le choix du curseur interactif lorsque les règles sont communes.
- [ ] Centraliser certains raccourcis clavier si plusieurs contrôles ont exactement le même comportement.
- [ ] Ne pas forcer une abstraction commune aux contrôles ayant des interactions différentes.

## Dialogues

- [x] Créer `PaperNestDialogSurface`.
- [ ] Extraire si nécessaire un composant partagé pour la route, la barrière et le cycle de fermeture.
- [ ] Éviter de dupliquer le cycle de vie entre `PaperNestAlertDialog` et les pickers.
- [ ] Regrouper les composants internes liés aux dialogues dans une même famille thématique.

## Actions internes Flutter

- [ ] Créer un widget Flutter interne pour les actions de dialogue construites directement en Dart.
- [ ] Prévoir au minimum les styles `primary`, `secondary`, `ghost` et `danger`.
- [ ] Permettre la personnalisation du texte, de l’icône, des couleurs et de l’état désactivé.
- [ ] Conserver les contrôles Python fournis dans `actions` sans les remplacer ni les restyler.
- [ ] Évaluer séparément la création d’un contrôle public `PaperNestButton`.

## Variantes partagées

- [ ] Inventorier les variantes de dialogues, actions, validation et états existantes.
- [ ] Regrouper dans un module commun uniquement les variantes utilisées par plusieurs contrôles.
- [ ] Ne pas créer un catalogue global contenant des variantes propres à un seul contrôle.
- [ ] Garder les styles concrets dans leur famille thématique lorsque cela améliore la lisibilité.

## Décision concernant `PaperNestButton`

Un fork ou contrôle public de bouton n’est pas requis pour `PaperNestAlertDialog` : les actions fournies depuis Python sont déjà des contrôles Flet complets et restent entièrement personnalisables.

Pour les boutons créés directement dans le code Flutter des pickers, un widget interne partagé sera utilisé, sur le même principe que `PaperNestDialogSurface`.

`PaperNestButton` ne devra être créé que si un besoin applicatif plus large est confirmé :

- unifier les boutons de PaperNestExtension et PaperNest ;
- réduire les wrappers Python `PrimaryButton`, `SecondaryButton`, `GhostButton`, etc. ;
- partager exactement les mêmes variantes entre Python et les actions internes Flutter ;
- apporter une fonction absente des boutons Flet natifs.

- [ ] Auditer les wrappers de boutons actuels de PaperNest.
- [ ] Comparer leurs fonctions avec les boutons natifs Flet.
- [ ] Décider si un contrôle public apporte un gain réel.
- [ ] Créer une roadmap dédiée avant toute implémentation de `PaperNestButton`.

## Migration progressive envisagée

- [ ] Commencer par un contrôle représentatif après stabilisation des dialogues.
- [ ] Valider compilation, exemple et build Windows après chaque extraction.
- [ ] Migrer ensuite les autres contrôles utilisant exactement la même fonction.
- [ ] Supprimer les implémentations locales seulement après validation.
- [ ] Vérifier ensuite si `PaperNestTextField` et `PaperNestDropdown` peuvent réutiliser certains modules sans régression.

## Validation

- [ ] Comparer visuellement avant et après chaque extraction.
- [ ] Tester focus, survol, disabled et read-only.
- [ ] Tester les types de bordures disponibles.
- [ ] Tester les couleurs et rayons personnalisés.
- [ ] Valider `flet run`.
- [ ] Valider le build Windows.
- [ ] Vérifier qu’aucune API Python publique n’a changé.
- [ ] Vérifier que le nombre de fichiers partagés reste raisonnable et compréhensible.

## Critère de finalisation

Le chantier sera terminé lorsque les fonctions communes seront centralisées dans quelques modules thématiques cohérents, sans abstraction excessive ni prolifération de fichiers, et que tous les contrôles conserveront leur comportement, leur rendu et leur API validés.
