# Roadmap — Composants Flutter partagés

## État

Chantier futur identifié pendant la validation de `PaperNestAlertDialog`.

Ce chantier ne doit pas interrompre la migration actuelle des dialogues. Il sera traité dans une mise à jour dédiée après stabilisation de `PaperNestAlertDialog` et de son intégration.

## Constat

Plusieurs contrôles Flutter de PaperNestExtension reconstruisent localement des comportements déjà proches ou identiques :

- création des `InputBorder` selon le focus ;
- résolution des couleurs de bordure ;
- décoration des champs ;
- gestion du remplissage, des paddings et des styles ;
- boutons d’action internes aux dialogues des pickers ;
- surfaces, en-têtes et actions de dialogues.

`form_field.dart` centralise déjà une partie de ces responsabilités, mais `PaperNestColorPicker`, `PaperNestDatePicker` et `PaperNestIconPicker` possèdent encore leur propre méthode `_border(...)` et plusieurs portions de décoration redondantes.

`PaperNestDialogSurface` constitue le premier composant partagé créé dans cette direction.

## Objectif

Réduire la duplication, séparer les responsabilités et garantir une apparence cohérente entre tous les contrôles sans modifier leur API publique ni leur comportement validé.

## Principes

- Ne pas refactorer plusieurs contrôles en même temps sans tests intermédiaires.
- Extraire uniquement du code réellement dupliqué.
- Conserver les API Python publiques inchangées.
- Préférer de petits composants ou helpers spécialisés à un fichier monolithique.
- Valider chaque extraction sous Windows avant de supprimer les implémentations locales.
- Ne pas mélanger ce chantier avec une migration fonctionnelle en cours.

## Étude de `form_field.dart`

- [ ] Relire entièrement le fork actuel de `form_field.dart`.
- [ ] Inventorier les responsabilités déjà couvertes.
- [ ] Identifier les API internes réutilisables par les pickers.
- [ ] Vérifier si le fichier doit rester un widget complet ou être séparé en plusieurs helpers.
- [ ] Comparer les méthodes `_border(...)` des ColorPicker, DatePicker et IconPicker.
- [ ] Identifier les différences réelles qui doivent rester propres à chaque contrôle.

## Composants envisagés

### Champ et bordures

- [ ] Créer un helper partagé de résolution des bordures.
- [ ] Centraliser `border`, `enabledBorder`, `focusedBorder` et `disabledBorder`.
- [ ] Centraliser largeur, couleur, rayon et type de bordure.
- [ ] Centraliser les propriétés communes d’`InputDecoration` lorsque cela apporte un vrai gain.
- [ ] Laisser chaque contrôle fournir son contenu, ses icônes et ses comportements spécifiques.

### Focus, survol et interaction

- [ ] Étudier un composant partagé pour `FocusNode`, survol et raccourcis clavier.
- [ ] Centraliser le choix du curseur interactif.
- [ ] Éviter d’imposer un composant trop abstrait aux contrôles ayant des comportements différents.

### Dialogues

- [x] Créer `PaperNestDialogSurface`.
- [ ] Extraire si nécessaire un builder partagé pour la route, la barrière et le cycle de fermeture.
- [ ] Éviter de dupliquer le cycle de vie entre `PaperNestAlertDialog` et les pickers.

### Actions internes Flutter

- [ ] Créer un composant Flutter interne pour les actions de dialogue des pickers.
- [ ] Prévoir au minimum les styles `primary`, `secondary`, `ghost` et `danger`.
- [ ] Permettre la personnalisation du texte, de l’icône, des couleurs et de l’état désactivé.
- [ ] Conserver les contrôles Python fournis dans `actions` sans les remplacer ni les restyler.
- [ ] Évaluer séparément la création d’un contrôle public `PaperNestButton`.

## Décision concernant `PaperNestButton`

Un fork ou contrôle public de bouton n’est pas requis pour `PaperNestAlertDialog` : les actions fournies depuis Python sont déjà des contrôles Flet complets et restent entièrement personnalisables.

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

- [ ] Refactorer `PaperNestColorPicker` en premier.
- [ ] Valider compilation, exemple et build Windows.
- [ ] Refactorer `PaperNestIconPicker`.
- [ ] Valider compilation, exemple et build Windows.
- [ ] Refactorer `PaperNestDatePicker` uniquement après stabilisation de son dialogue.
- [ ] Vérifier que `PaperNestTextField` et `PaperNestDropdown` peuvent réutiliser certains helpers sans régression.
- [ ] Supprimer les méthodes locales devenues inutiles.

## Validation

- [ ] Comparer visuellement avant et après chaque extraction.
- [ ] Tester focus, survol, disabled et read-only.
- [ ] Tester les types de bordures disponibles.
- [ ] Tester les couleurs et rayons personnalisés.
- [ ] Valider `flet run`.
- [ ] Valider le build Windows.
- [ ] Vérifier qu’aucune API Python publique n’a changé.

## Critère de finalisation

Le chantier sera terminé lorsque les responsabilités communes seront centralisées sans abstraction excessive, que les duplications de bordures et de décoration auront disparu des pickers concernés, que les actions Flutter internes partageront un rendu cohérent et que tous les contrôles conserveront leur comportement et leur API validés.
