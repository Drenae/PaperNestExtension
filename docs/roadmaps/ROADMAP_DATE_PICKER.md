# Roadmap — PaperNestDatePicker

## État

La roadmap `PaperNestDatePicker` est terminée.

## Objectif

Fournir à PaperNest un sélecteur de date autonome, cohérent avec les autres contrôles de PaperNestExtension, puis remplacer le champ de date historique sans perdre les comportements validés.

## Implémentation de l’extension

- [x] Création de l’API Python `PaperNestDatePicker`.
- [x] Création des énumérations `PaperNestDatePickerMode` et `PaperNestDatePickerEntryMode`.
- [x] Création de l’événement `PaperNestDatePickerEntryModeChangeEvent`.
- [x] Implémentation Flutter du contrôle autonome.
- [x] Rendu fermé sous forme de champ Material non éditable.
- [x] Ouverture du calendrier sur toute la surface du champ.
- [x] Gestion de `value`, `first_date`, `last_date` et `current_date`.
- [x] Locale française et textes français par défaut.
- [x] Gestion du mode calendrier et du mode de saisie.
- [x] Gestion du libellé, du texte indicatif et de l’icône de préfixe.
- [x] Gestion de `clear_button`, `clear_icon` et `clear_tooltip`.
- [x] Gestion des styles Material et des états normal, focus, survol et désactivé.
- [x] Implémentation de `on_change`, `on_cleared`, `on_entry_mode_change`, `on_focus`, `on_blur`, `on_tap_outside` et `on_escape`.
- [x] Normalisation des dates civiles pour éviter les décalages liés au fuseau horaire.
- [x] Méthodes publiques asynchrones `focus()`, `open()` et `clear()`.
- [x] Export public depuis `papernestextension.controls` et `papernestextension`.

## Migration dans PaperNest

- [x] Étude de l’ancien `BaseDatePickerField` de `forms.py`.
- [x] Recherche de toutes ses utilisations.
- [x] Vérification des formats attendus par les formulaires et services.
- [x] Création du wrapper thématique `BaseDatePickerField` héritant directement de `PaperNestDatePicker`.
- [x] Application du thème via des `kwargs.setdefault(...)` surchargeables.
- [x] Conservation de `value` au type natif `datetime`.
- [x] Ajout de `iso_value` pour les services PaperNest attendant une date ISO.
- [x] Préservation de l’effacement et des événements attendus.
- [x] Remplacement des usages dans le dialogue des métadonnées.
- [x] Suppression de l’ancien DatePicker natif de `forms.py`.
- [x] Nettoyage des imports obsolètes.

## Validation de l’extension

- [x] Vérification de l’exemple dédié et de la valeur initiale.
- [x] Test de la sélection de date.
- [x] Test de la modification programmée de `value`.
- [x] Test des limites `first_date` et `last_date`.
- [x] Test du bouton d’effacement et de l’événement associé.
- [x] Test du focus, du survol, du clavier, d’Échap et de l’état désactivé.
- [x] Vérification de l’absence de décalage d’un jour lié au fuseau horaire.
- [x] Build et test de l’exemple sous Windows avec les versions retenues.

## Validation dans PaperNest

- [x] Test du dialogue utilisant les dates.
- [x] Vérification de la valeur initiale.
- [x] Vérification de la sélection, de la modification et de l’effacement.
- [x] Vérification des valeurs ISO envoyées aux services et enregistrées dans les modèles.
- [x] Vérification du rendu visuel sous Windows.
- [x] Validation du comportement réel par l’utilisateur.
- [x] Validation du build Windows de PaperNest.
- [x] Mise à jour de la roadmap UI et des changelogs.

## Nettoyage final

- [x] Suppression de l’ancien code de date devenu inutile.
- [x] Suppression des wrappers et imports obsolètes communs.
- [x] Vérification finale de `forms.py` après les migrations DatePicker et FilePicker.

## Critères de finalisation

`PaperNestDatePicker` est fonctionnel et validé dans l’extension comme dans PaperNest. Le build Windows, les interactions, les valeurs ISO et le nettoyage de l’ancien code sont validés.
