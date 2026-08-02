# Roadmap — PaperNestButton

## État

Chantier actif.

`PaperNestAlertDialog` est terminé. Les sources Flet de `Button` et `ButtonStyle`, côté Python et Flutter, ont été fournies et étudiées. Les wrappers actuels de PaperNest ont également été relus.

L’architecture est maintenant définie : conserver `ButtonStyle` pour les propriétés Material natives et ajouter une surface Flutter PaperNest partagée pour les gradients, les animations et les variants.

## Objectif

Créer un bouton PaperNest cohérent, personnalisable et réutilisable :

- côté Python dans PaperNest ;
- côté Flutter dans PaperNestExtension ;
- dans les actions internes des dialogues et pickers ;
- sans dupliquer variants, styles et animations.

## Sources Flet étudiées

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
- [x] Vérifier les rendus Filled, FilledTonal, Text, Outlined et Elevated.
- [x] Vérifier la construction avec ou sans icône.
- [x] Vérifier la restitution via `LayoutControl`.

### ButtonStyle

- [x] Consulter la définition Python de `ButtonStyle`.
- [x] Consulter `parseButtonStyle()` côté Flutter.
- [x] Confirmer la gestion par état de `color`, `bgcolor`, `overlay_color`, `shadow_color`, `elevation`, `padding`, `side`, `shape`, `text_style`, `icon_size`, `icon_color`, `mouse_cursor` et tailles.
- [x] Confirmer les états normal, hovered, focused, pressed et disabled via `ControlStateValue` / `WidgetStateProperty`.
- [x] Confirmer que `animation_duration` couvre les transitions Material de forme et d’élévation.
- [x] Confirmer que `ButtonStyle` ne peut pas transporter de gradient ni animer échelle ou translation.

## Audit PaperNest

- [x] Relire entièrement `app/theme/buttons.py`.
- [x] Inventorier `AppButton`, `PrimaryButton`, `SecondaryButton`, `GhostButton`, `OutlineButton`, `DangerButton` et `SuccessButton`.
- [x] Identifier le support actuel de `loading`, `compact`, `tooltip`, largeur et expansion.
- [x] Confirmer que le chargement remplace l’icône par un `ProgressRing` et désactive le bouton.
- [x] Identifier `IconAction` et `MenuAction` comme contrôles séparés, hors première migration de `PaperNestButton`.
- [ ] Recenser tous les usages applicatifs avant l’intégration finale.

## Décision d’architecture

- [x] Créer un contrôle public Python `PaperNestButton` autonome.
- [x] Conserver une propriété `style: ButtonStyle` pour tous les comportements Material natifs.
- [x] Créer un widget Flutter interne partagé, utilisé par le contrôle public et par les contrôles internes de l’extension.
- [x] Envelopper le rendu interactif dans une surface animée pour les gradients et transformations.
- [x] Ne pas recopier le parseur complet de `ButtonStyle`.
- [x] Utiliser `parseButtonStyle()` pour le style Material lorsque cela est pertinent.
- [x] Regrouper variants, styles et animations par thèmes cohérents, sans multiplier les helpers.

## API publique retenue pour la première version

- [ ] Créer `PaperNestButton`.
- [ ] Créer `PaperNestButtonVariant`.
- [ ] Variants : `primary`, `secondary`, `ghost`, `outline`, `danger`, `success`.
- [ ] Accepter `content` sous forme de chaîne ou contrôle Flet.
- [ ] Accepter une icône ou un contrôle et choisir sa position `leading` ou `trailing`.
- [ ] Gérer `loading` et `loading_text` nativement.
- [ ] Gérer `compact`, largeur, hauteur et expansion.
- [ ] Gérer `disabled`, `autofocus`, URL, tooltip et événements click, long press, hover, focus et blur.
- [ ] Conserver `style: ButtonStyle` pour couleurs, bordures, formes, paddings, typographie, élévation, ombre, curseur et tailles.
- [ ] Prévoir les états normal, hovered, focused, pressed et disabled.
- [ ] Exposer `focus()`.

## Gradients et animations

- [ ] Ajouter `gradient`.
- [ ] Ajouter `focused_gradient`.
- [ ] Ajouter `hover_gradient`, `pressed_gradient` et `disabled_gradient` si renseignés.
- [ ] Définir un ordre de résolution explicite : disabled, pressed, focused, hovered, normal.
- [ ] Ajouter une animation de survol configurable.
- [ ] Ajouter une animation de clic configurable.
- [ ] Prévoir durée, courbe, échelle et translation légère.
- [ ] Utiliser `AnimatedContainer`, `AnimatedScale` ou équivalent sans modifier les contraintes du layout.
- [ ] Conserver clavier, focus, curseur et accessibilité.
- [ ] Éviter les animations excessives dans PaperNest.

## Architecture Flutter

- [ ] Créer le widget interne partagé du bouton.
- [ ] Centraliser la résolution des variants et états dans ce widget.
- [ ] Construire le contenu, l’icône, le loader et leur ordre.
- [ ] Utiliser une surface Material transparente lorsque le gradient fournit le fond.
- [ ] Conserver l’overlay/ripple et le focus Material.
- [ ] Permettre une utilisation directe par `PaperNestAlertDialog`, `PaperNestColorPicker` et `PaperNestIconPicker`.
- [ ] Coordonner ce travail avec `ROADMAP_FLUTTER_SHARED_COMPONENTS.md`.

## Intégration PaperNest

- [ ] Créer un wrapper thématique minimal seulement s’il apporte une valeur réelle.
- [ ] Remplacer progressivement `AppButton` et ses variants.
- [ ] Préserver les API utiles : `text`, `loading`, `compact`, `set_loading` si nécessaire et styles personnalisés.
- [ ] Vérifier tous les dialogues, panneaux et barres d’actions.
- [ ] Conserver `IconAction` et `MenuAction` jusqu’à une étude séparée.
- [ ] Supprimer les anciens wrappers uniquement après validation complète.

## Application d’exemple

- [ ] Créer un panneau dédié aux boutons.
- [ ] Ajouter une page ou section `Actions` dans l’application d’exemple.
- [ ] Présenter tous les variants.
- [ ] Présenter gradients et états interactifs.
- [ ] Présenter loading, disabled, compact, icône leading/trailing et contrôle personnalisé.
- [ ] Vérifier clavier, focus, curseur et URL.

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
