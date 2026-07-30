# Roadmap — PaperNestColorPicker

## État

La roadmap `PaperNestColorPicker` est terminée.

## Objectif

Créer un contrôle de sélection de couleur cohérent avec PaperNestExtension et remplacer le champ couleur historique de PaperNest.

## Implémentation de l’extension

- [x] API Python définie.
- [x] Architecture Flutter définie.
- [x] Rendu fermé sous forme de champ Material.
- [x] Ouverture du `MaterialPicker` sur toute la surface.
- [x] Indicateur circulaire de la couleur sélectionnée.
- [x] Valeur normalisée au format `#RRGGBB`.
- [x] Suppression des valeurs publiques `#AARRGGBB`.
- [x] Gestion de la valeur initiale et des changements programmatiques.
- [x] Gestion du focus, du clavier, d’Échap et du survol.
- [x] Gestion des états `disabled` et `read_only`.
- [x] Implémentation de `clear_button` et de l’événement `on_clear`.
- [x] Compatibilité temporaire avec l’ancien événement `on_cleared`.
- [x] Implémentation de `on_change`, `on_focus`, `on_blur` et `on_escape`.
- [x] Exemple de l’extension mis à jour.

## Intégration dans PaperNest

- [x] Étude de l’ancien champ couleur.
- [x] Création de `BaseColorPicker` héritant directement de `PaperNestColorPicker`.
- [x] Application du thème avec des `kwargs.setdefault(...)` surchargeables.
- [x] Remplacement de l’ancien champ couleur.
- [x] Suppression du code et des imports devenus inutiles.
- [x] Vérification des formulaires utilisant une couleur.

## Validation

- [x] Build de l’extension sous Windows.
- [x] Test de l’ouverture du sélecteur.
- [x] Test de la sélection et de la normalisation `#RRGGBB`.
- [x] Test de l’effacement et de `on_clear`.
- [x] Test du focus, du clavier, du survol, de `disabled` et de `read_only`.
- [x] Validation du rendu et du comportement dans PaperNest.
- [x] Validation du build Windows de PaperNest.
- [x] Validation avec l’utilisateur.
- [x] Mise à jour de la roadmap globale et des changelogs.

## Critères de finalisation

`PaperNestColorPicker` est implémenté, intégré et validé sous Windows. L’ancien champ couleur a été supprimé et le contrôle est utilisé dans tous les parcours réels de PaperNest.
