# Roadmap — PaperNestDatePicker

## Objectif

Fournir à PaperNest un sélecteur de date autonome, cohérent avec les autres contrôles de PaperNestExtension, puis remplacer le champ de date historique de PaperNest sans perdre les comportements déjà validés.

## Implémentation de l’extension

- [x] Création de l’API Python `PaperNestDatePicker`.
- [x] Création des énumérations `PaperNestDatePickerMode` et `PaperNestDatePickerEntryMode`.
- [x] Création de l’événement `PaperNestDatePickerEntryModeChangeEvent`.
- [x] Implémentation Flutter du contrôle autonome.
- [x] Rendu fermé sous forme de champ Material non éditable.
- [x] Ouverture du calendrier sur toute la surface du champ.
- [x] Gestion de `value`, `first_date`, `last_date` et `current_date`.
- [x] Locale française par défaut.
- [x] Textes français pour la confirmation, l’annulation et les erreurs.
- [x] Gestion du mode calendrier et du mode de saisie.
- [x] Gestion du libellé, du texte indicatif et de l’icône de préfixe.
- [x] Gestion de `clear_button`, `clear_icon` et `clear_tooltip`.
- [x] Gestion des styles de champ Material.
- [x] Gestion des états normal, focus, survol et désactivé.
- [x] Implémentation de `on_change`, `on_cleared`, `on_entry_mode_change`, `on_focus`, `on_blur`, `on_tap_outside` et `on_escape`.
- [x] Normalisation des dates civiles pour éviter les décalages liés au fuseau horaire.
- [x] Méthodes publiques asynchrones `focus()`, `open()` et `clear()`.
- [x] Export public depuis `papernestextension.controls` et `papernestextension`.

## État actuel dans PaperNest

- [x] Étude du champ historique `BaseDatePickerField` dans `forms.py`.
- [x] Identification de son fonctionnement historique : champ en lecture seule, calendrier Flet natif, valeur ISO et bouton d’effacement séparé.
- [x] Confirmation que la migration utilise l’API réelle de `PaperNestDatePicker`.
- [x] Utilisation effective de `PaperNestDatePicker` dans PaperNest.

## Migration dans PaperNest

- [x] Recherche de toutes les utilisations de `BaseDatePickerField`.
- [x] Vérification des formats de valeur attendus par les formulaires et services.
- [x] Création du wrapper thématique léger `BaseDatePickerField` héritant directement de `PaperNestDatePicker`.
- [x] Reproduction des couleurs, bordures, espacements et styles validés de PaperNest via des valeurs par défaut surchargeables.
- [x] Conservation de `value` au type natif `datetime` de l’extension.
- [x] Ajout de `iso_value` pour les services PaperNest attendant une date ISO.
- [x] Préservation du comportement d’effacement et des événements attendus.
- [x] Remplacement des utilisations de l’ancien champ dans le dialogue des métadonnées.
- [x] Suppression de l’ancien `BaseDatePickerField` natif de `forms.py`.
- [x] Nettoyage des imports directement devenus inutiles.

## Validation dans l’extension

- [x] Vérification de l’exemple dédié et de la valeur initiale.
- [ ] Tester une sélection de date dans l’exemple dédié.
- [ ] Tester une modification programmée de `value` dans l’exemple dédié.
- [ ] Tester les limites `first_date` et `last_date` dans l’exemple dédié.
- [ ] Tester le bouton d’effacement et l’événement associé dans l’exemple dédié.
- [ ] Tester le focus, le survol, le clavier, Échap et l’état désactivé dans l’exemple dédié.
- [ ] Vérifier l’absence de décalage d’un jour lié au fuseau horaire dans l’exemple dédié.
- [ ] Construire et tester l’exemple de l’extension sous Windows avec les versions actuellement retenues.

## Validation dans PaperNest

- [x] Test du dialogue utilisant les dates.
- [x] Vérification de l’affichage de la valeur initiale.
- [x] Vérification de la sélection, de la modification et de l’effacement.
- [x] Vérification des valeurs ISO envoyées aux services et enregistrées dans les modèles.
- [x] Vérification du rendu visuel sous Windows.
- [x] Validation du comportement réel par l’utilisateur.
- [x] Validation du build Windows de PaperNest.
- [x] Mise à jour de la roadmap UI de PaperNest.
- [ ] Mise à jour du changelog de PaperNestExtension et de celui de PaperNest.

## Nettoyage après validation

- [x] Suppression de l’ancien code de date devenu inutile dans PaperNest.
- [x] Suppression des wrappers et imports obsolètes communs après la migration de `PaperNestFilePicker`.
- [x] Vérification de `forms.py` après les migrations DatePicker et FilePicker.

## Critères de finalisation

La migration dans PaperNest est terminée : `PaperNestDatePicker` est utilisé dans tous les parcours réels, le rendu et le build Windows ont été validés, les valeurs ISO sont transmises explicitement aux services et l’ancien code a été supprimé. Les tests exhaustifs de l’exemple dédié de PaperNestExtension restent suivis séparément.
