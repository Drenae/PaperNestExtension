# Roadmap — PaperNestIconPicker

## État

`PaperNestIconPicker` est officiellement terminé.

Le contrôle a été implémenté, construit, testé et validé sous Windows dans PaperNestExtension, puis intégré et validé dans PaperNest. La création, la modification, la prévisualisation, la conservation des valeurs existantes et le build Windows de PaperNest ont été validés par l’utilisateur.

## Objectif validé

Créer un sélecteur d’icône autonome dans PaperNestExtension, cohérent avec les autres pickers de l’extension, puis remplacer le contrôle historique `BaseIconField` de PaperNest.

## Étude de l’existant

- [x] Identifier l’unique usage de `BaseIconField`.
- [x] Relire son implémentation complète.
- [x] Inventorier l’aperçu, la galerie responsive, la sélection temporaire, l’annulation, la validation et l’état désactivé.
- [x] Confirmer que la valeur métier enregistrée est le nom Material sous forme de chaîne.
- [x] Confirmer le fallback `FOLDER_ROUNDED`.
- [x] Vérifier le comportement avec les catégories existantes pendant la validation PaperNest.

## API Python

- [x] `PaperNestIconPicker`.
- [x] `PaperNestIconPickerOption`.
- [x] `options`, `value` et `fallback_value`.
- [x] Textes et styles du champ et du dialogue.
- [x] `disabled`, `read_only` et `autofocus`.
- [x] Événements et méthodes programmatiques utiles.
- [x] Fallback sûr pour les valeurs inconnues.

## Implémentation Flutter

- [x] Champ Material fermé avec icône, libellé et chevron.
- [x] Galerie responsive.
- [x] Sélection temporaire, annulation et validation explicite.
- [x] Synchronisation Python/Flutter.
- [x] Clavier, focus, survol, curseurs et états non interactifs.
- [x] Enregistrement et exports publics.

## Exemple PaperNestExtension

- [x] Exemple intégré à l’application principale.
- [x] Compilation et build Windows.
- [x] Valeur initiale, modification programmée et fallback.
- [x] Annulation et validation.
- [x] `disabled`, `read_only`, clavier et focus.
- [x] Validation visuelle et fonctionnelle par l’utilisateur.

## Intégration PaperNest

- [x] Wrapper thématique dédié.
- [x] Conversion des options existantes.
- [x] Remplacement de `BaseIconField` dans l’éditeur.
- [x] Préservation des valeurs enregistrées et du fallback.
- [x] Validation de la création et de la modification des classeurs.
- [x] Validation du build Windows.
- [ ] Supprimer définitivement la définition historique de `BaseIconField` pendant la passe de nettoyage globale.
- [ ] Nettoyer les imports devenus inutiles dans `forms.py` pendant la même passe.

## Règle d’évolution

Le contrôle est fonctionnellement fermé. Toute évolution future devra répondre à un besoin réel constaté dans PaperNest.
