# Roadmap — PaperNestAlertDialog

## État

Étude ouverte.

Les pickers actuels ouvrent leurs dialogues directement dans leur implémentation Flutter. PaperNest possède parallèlement un `AppDialog` Python dérivé de `ft.AlertDialog`, avec une identité visuelle propre. Ces deux systèmes doivent être rapprochés sans créer de dépendance circulaire entre Python et Flutter.

## Objectif

Créer un dialogue PaperNest réutilisable :

- comme contrôle public depuis Python ;
- comme rendu Flutter partagé à l’intérieur des pickers ;
- avec une identité visuelle cohérente dans PaperNest et PaperNestExtension.

## Décision d’architecture

Un contrôle Python `PaperNestAlertDialog` ne peut pas être instancié directement depuis le code Dart interne d’un picker.

L’architecture retenue doit donc séparer :

1. `PaperNestAlertDialog`, contrôle public utilisable depuis Python ;
2. un composant Flutter interne partagé, par exemple `PaperNestDialogSurface` ou `PaperNestDialogBuilder` ;
3. l’utilisation de ce composant interne par `PaperNestAlertDialog` et par les dialogues des pickers.

Cette structure garantit le même rendu sans dupliquer le code visuel.

## Étude de Flet

- [ ] Relire l’API Python de `AlertDialog` pour la version Flet retenue.
- [ ] Relire l’implémentation Flutter de `AlertDialog`.
- [ ] Inventorier les propriétés réellement utiles dans `AppDialog`.
- [ ] Identifier les limites qui justifient un contrôle autonome plutôt qu’un simple thème.
- [ ] Vérifier les comportements de fermeture, modalité, barrière, clavier et focus.

## API Python envisagée

- [ ] Créer `PaperNestAlertDialog`.
- [ ] Accepter `title`, `content`, `actions` et `icon` comme contrôles Flet.
- [ ] Prévoir les variantes `standard`, `primary`, `success`, `warning` et `danger`.
- [ ] Prévoir `title_action`.
- [ ] Prévoir la largeur, le mode modal, la fermeture extérieure et le défilement.
- [ ] Prévoir les propriétés de couleurs, espacements, forme, ombre et barrière.
- [ ] Conserver les événements et comportements utiles de `AlertDialog`.
- [ ] Éviter d’ajouter des propriétés sans usage réel dans PaperNest.

## Composant Flutter partagé

- [ ] Créer un composant interne pour l’en-tête, le contenu, les actions et la surface du dialogue.
- [ ] Centraliser les paddings, rayons, ombres et couleurs.
- [ ] Gérer les variantes visuelles.
- [ ] Gérer une largeur contrainte et un contenu scrollable.
- [ ] Gérer le clavier et les petits écrans.
- [ ] Permettre aux pickers de fournir leur propre contenu et leurs propres actions.

## Migration des pickers

- [ ] Migrer `PaperNestColorPicker` vers le composant partagé.
- [ ] Migrer `PaperNestDatePicker` vers le composant partagé lorsque le dialogue natif le permet sans perdre ses fonctions.
- [ ] Migrer `PaperNestIconPicker` vers le composant partagé.
- [ ] Étudier séparément `PaperNestFilePicker`, dont l’interface n’est pas nécessairement un dialogue classique.
- [ ] Vérifier que chaque picker conserve sa sélection temporaire, son annulation et sa validation.

## Intégration PaperNest

- [ ] Créer `AppDialog(PaperNestAlertDialog)`.
- [ ] Reproduire les variantes actuelles de `dialogs.py`.
- [ ] Migrer `ConfirmDialog`, `DangerDialog` et `FormDialog` sans régression.
- [ ] Supprimer l’héritage direct de `ft.AlertDialog` après validation.
- [ ] Valider tous les dialogues existants dans PaperNest.

## Validation

- [ ] Créer une page dédiée dans l’application d’exemple.
- [ ] Tester toutes les variantes.
- [ ] Tester les contenus courts, longs et scrollables.
- [ ] Tester les actions multiples et leur débordement.
- [ ] Tester la fermeture extérieure, le mode modal et Échap.
- [ ] Tester les pickers après migration.
- [ ] Valider les builds Windows de PaperNestExtension et PaperNest.

## Critère de finalisation

Le chantier sera terminé lorsque le contrôle public et le composant Flutter partagé seront validés, que les pickers concernés utiliseront le même rendu et que `AppDialog` héritera de `PaperNestAlertDialog` sans régression dans PaperNest.
