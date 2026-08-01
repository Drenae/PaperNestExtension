# Roadmap — PaperNestAlertDialog

## État

Phase 3 officiellement ouverte.

Les sources Python et Flutter de `AlertDialog` pour la version Flet retenue ont été fournies et étudiées. L’architecture est maintenant figée : un contrôle public `PaperNestAlertDialog` partagera un composant Flutter interne avec les dialogues des pickers.

## Objectif

Créer un dialogue PaperNest réutilisable :

- comme contrôle public depuis Python ;
- comme rendu Flutter partagé à l’intérieur des pickers ;
- avec une identité visuelle cohérente dans PaperNest et PaperNestExtension.

## Décision d’architecture

Un contrôle Python `PaperNestAlertDialog` ne peut pas être instancié directement depuis le code Dart interne d’un picker.

L’architecture retenue sépare donc :

1. `PaperNestAlertDialog`, contrôle public utilisable depuis Python ;
2. `PaperNestDialogSurface`, composant Flutter interne partagé ;
3. l’utilisation de cette surface par le contrôle public et les dialogues internes des pickers.

Le contrôle public conserve le cycle de vie natif de `AlertDialog` : propriété `open`, route propre au contrôle, barrière, modalité, fermeture extérieure et événement `dismiss` après la fin de l’animation.

## Étude de Flet

- [x] Relire l’API Python de `AlertDialog` pour la version Flet retenue.
- [x] Relire l’implémentation Flutter de `AlertDialog`.
- [x] Inventorier les propriétés réellement utiles dans `AppDialog`.
- [x] Identifier les limites qui justifient un contrôle autonome plutôt qu’un simple thème.
- [x] Vérifier les comportements de fermeture, modalité, barrière, clavier et focus.
- [x] Conserver la route propre au dialogue afin de ne pas fermer un dialogue voisin.
- [x] Conserver l’événement `dismiss` après la fin de l’animation de fermeture.
- [x] Conserver une barrière dessinée dans le widget pour permettre sa mise à jour dynamique.

## API Python retenue

- [ ] Créer `PaperNestAlertDialog` à partir de `DialogControl`.
- [ ] Accepter `title`, `content`, `actions` et `icon` comme chaînes ou contrôles Flet selon leur nature.
- [ ] Ajouter `variant` avec `standard`, `primary`, `success`, `warning` et `danger`.
- [ ] Ajouter `title_action`.
- [ ] Ajouter `width` et `max_height`.
- [ ] Conserver `modal`, `open`, `scrollable`, `barrier_color` et `on_dismiss`.
- [ ] Ajouter `dismissible` comme API explicite, convertie vers le comportement modal de la route.
- [ ] Conserver les propriétés utiles de couleurs, espacements, forme, ombre et alignement.
- [ ] Ne pas recopier les propriétés natives sans usage réel dans PaperNest.

## Composant Flutter partagé

- [ ] Créer `PaperNestDialogSurface`.
- [ ] Construire l’en-tête sombre, l’icône, le titre et `title_action`.
- [ ] Centraliser les paddings, rayons, ombres, couleurs et variantes.
- [ ] Gérer une largeur contrainte et une hauteur maximale.
- [ ] Gérer un contenu scrollable sans faire défiler la barre d’actions.
- [ ] Gérer les petits écrans via `SafeArea` et des contraintes adaptées.
- [ ] Permettre aux pickers de fournir leur propre contenu et leurs propres actions.
- [ ] Préserver l’accessibilité et le libellé sémantique.

## Implémentation du contrôle public

- [ ] Créer le fichier Python du contrôle.
- [ ] Créer le widget Flutter du contrôle.
- [ ] Reprendre le cycle de vie robuste de `AlertDialogControl`.
- [ ] Enregistrer le contrôle dans `Extension.createWidget()`.
- [ ] Exporter le contrôle depuis les API publiques de l’extension.

## Migration des pickers

- [ ] Migrer `PaperNestColorPicker` vers `PaperNestDialogSurface`.
- [ ] Migrer `PaperNestIconPicker` vers `PaperNestDialogSurface`.
- [ ] Étudier `PaperNestDatePicker` avec le paramètre `builder` de `showDatePicker()`.
- [ ] Utiliser la nouvelle identité sur le DatePicker uniquement si toutes les fonctions natives sont conservées.
- [ ] Conserver le DatePicker Material natif si l’enveloppe partagée entraîne une régression.
- [ ] Étudier séparément `PaperNestFilePicker`, dont l’interface principale n’est pas un dialogue classique.
- [ ] Vérifier que chaque picker conserve sa sélection temporaire, son annulation et sa validation.

## Intégration PaperNest

- [ ] Créer `AppDialog(PaperNestAlertDialog)`.
- [ ] Reproduire les variantes actuelles de `dialogs.py`.
- [ ] Migrer `ConfirmDialog`, `DangerDialog` et `FormDialog` sans régression.
- [ ] Supprimer l’héritage direct de `ft.AlertDialog` après validation.
- [ ] Valider tous les dialogues existants dans PaperNest.

## Exemple et validation

- [ ] Créer une page `Dialogues` dans l’application d’exemple.
- [ ] Tester toutes les variantes.
- [ ] Tester les contenus courts, longs et scrollables.
- [ ] Tester les actions multiples et leur débordement.
- [ ] Tester la fermeture extérieure, le mode modal et Échap.
- [ ] Tester plusieurs dialogues successifs et imbriqués.
- [ ] Tester les pickers après migration.
- [ ] Valider les builds Windows de PaperNestExtension et PaperNest.

## Critère de finalisation

Le chantier sera terminé lorsque le contrôle public et le composant Flutter partagé seront validés, que les pickers concernés utiliseront le même rendu et que `AppDialog` héritera de `PaperNestAlertDialog` sans régression dans PaperNest.
