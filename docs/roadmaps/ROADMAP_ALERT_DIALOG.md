# Roadmap — PaperNestAlertDialog

## État

Phase 3 officiellement ouverte.

Les sources Python et Flutter de `AlertDialog` pour la version Flet retenue ont été fournies et étudiées. Le contrôle public, sa surface Flutter partagée, les exports et l’enregistrement dans l’extension sont créés.

La compilation Flutter, `flet run`, le build Windows et la page d’exemple ont été testés et validés. L’API publique est jugée complète et les actions fournies depuis Python restent entièrement personnalisables.

`PaperNestColorPicker` utilise maintenant `PaperNestDialogSurface`. Cette première migration doit être reconstruite et validée avant de passer à `PaperNestIconPicker`.

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

Les contrôles placés dans `actions` depuis Python sont rendus tels quels. Les wrappers applicatifs comme `PrimaryButton`, `SecondaryButton` et `GhostButton` restent donc utilisables et personnalisables sans nécessiter un fork de bouton.

Les actions créées directement dans le code Flutter des pickers utiliseront ultérieurement un widget Flutter interne partagé. La création éventuelle d’un contrôle public `PaperNestButton` sera étudiée séparément et n’est pas nécessaire à ce chantier.

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

- [x] Créer `PaperNestAlertDialog` à partir de `DialogControl`.
- [x] Accepter `title`, `content`, `actions` et `icon` comme chaînes ou contrôles Flet selon leur nature.
- [x] Ajouter `variant` avec `standard`, `primary`, `success`, `warning` et `danger`.
- [x] Ajouter `title_action`.
- [x] Ajouter `width` et `max_height`.
- [x] Conserver `modal`, `open`, `scrollable`, `barrier_color` et `on_dismiss`.
- [x] Ajouter `dismissible` comme API explicite.
- [x] Conserver les propriétés utiles de couleurs, espacements, forme, ombre et alignement.
- [x] Ne pas recopier les propriétés natives sans usage réel dans PaperNest.

## Composant Flutter partagé

- [x] Créer `PaperNestDialogSurface`.
- [x] Construire l’en-tête sombre, l’icône, le titre et `title_action`.
- [x] Centraliser les paddings, rayons, ombres, couleurs et variantes.
- [x] Gérer une largeur contrainte et une hauteur maximale.
- [x] Gérer un contenu scrollable sans faire défiler la barre d’actions.
- [x] Gérer les petits écrans via `SafeArea` et des contraintes adaptées.
- [x] Permettre aux pickers de fournir leur propre contenu et leurs propres actions.
- [ ] Vérifier l’accessibilité et le libellé sémantique pendant les tests finaux.

## Implémentation du contrôle public

- [x] Créer le fichier Python du contrôle.
- [x] Créer le widget Flutter du contrôle.
- [x] Reprendre le cycle de vie robuste de `AlertDialogControl`.
- [x] Importer `ControlInheritedNotifier` depuis le package Flet sans dupliquer le framework.
- [x] Enregistrer le contrôle dans `Extension.createWidget()`.
- [x] Exporter le contrôle depuis les API publiques de l’extension.
- [x] Vérifier la compilation Flutter.
- [x] Vérifier `flet run`.
- [x] Vérifier le build Windows de l’application d’exemple.

## Migration des pickers

### PaperNestColorPicker

- [x] Remplacer l’`AlertDialog` Flutter local par `PaperNestDialogSurface`.
- [x] Conserver `MaterialPicker` et sa sélection temporaire.
- [x] Conserver l’annulation sans modification.
- [x] Conserver la confirmation et l’événement `change`.
- [x] Conserver les textes personnalisables `picker_title`, `cancel_text` et `confirm_text`.
- [x] Ne pas modifier le champ, les bordures, le focus ni l’API Python.
- [ ] Recompiler l’extension.
- [ ] Tester le ColorPicker dans l’application d’exemple.
- [ ] Tester le ColorPicker dans PaperNest.
- [ ] Valider le build Windows.

### Autres pickers

- [ ] Migrer `PaperNestIconPicker` vers `PaperNestDialogSurface` après validation du ColorPicker.
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

- [x] Créer une page `Dialogues` dans l’application d’exemple.
- [x] Ajouter les cinq variantes à la page.
- [x] Ajouter un exemple avec `title_action`.
- [x] Ajouter un contenu long avec `scrollable` et `max_height`.
- [x] Ajouter un dialogue modal non dismissible.
- [x] Ajouter un dialogue fermable par clic extérieur.
- [x] Tester visuellement toutes les variantes.
- [x] Tester les contenus courts, longs et scrollables.
- [x] Tester les actions personnalisées fournies depuis Python.
- [x] Tester `title_action`.
- [x] Tester la fermeture extérieure et le mode modal.
- [x] Faire valider visuellement et fonctionnellement le contrôle public par l’utilisateur.
- [ ] Tester les actions multiples et leur débordement sur petite largeur.
- [ ] Tester explicitement Échap.
- [ ] Tester plusieurs dialogues successifs et imbriqués.
- [ ] Tester les pickers après migration.
- [ ] Valider les builds Windows après les migrations des pickers et de PaperNest.

## Refactorisation future associée

La centralisation globale des fonctions Flutter partagées sera traitée dans une mise à jour distincte :

- `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`

Cette roadmap couvre l’architecture partagée de l’extension entière, avec des modules regroupés par thèmes et sans multiplication excessive de fichiers helpers.

## Critère de finalisation

Le chantier sera terminé lorsque le contrôle public et le composant Flutter partagé seront validés, que les pickers concernés utiliseront le même rendu et que `AppDialog` héritera de `PaperNestAlertDialog` sans régression dans PaperNest.
