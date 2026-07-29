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
- [x] Identification de son fonctionnement actuel : champ en lecture seule, calendrier Flet natif, valeur ISO et bouton d’effacement séparé.
- [x] Confirmation que la migration doit utiliser l’API réelle de `PaperNestDatePicker`.
- [ ] Le contrôle de l’extension n’est pas encore utilisé dans PaperNest.

## Migration dans PaperNest

- [ ] Rechercher toutes les utilisations de `BaseDatePickerField`.
- [ ] Vérifier les formats de valeur attendus par chaque formulaire et service.
- [ ] Créer un wrapper thématique léger autour de `PaperNestDatePicker` uniquement si nécessaire.
- [ ] Reproduire les couleurs, dimensions, bordures, espacements et styles validés de PaperNest.
- [ ] Préserver le format public attendu par PaperNest, notamment les dates ISO lorsque les services les utilisent.
- [ ] Préserver le comportement d’effacement et les événements attendus par les formulaires.
- [ ] Remplacer progressivement les utilisations de l’ancien champ.
- [ ] Ne supprimer `BaseDatePickerField` qu’après validation complète du remplacement.
- [ ] Nettoyer uniquement les imports directement devenus inutiles à cause de cette migration.

## Validation dans l’extension

- [ ] Vérifier que l’exemple dédié couvre la valeur initiale.
- [ ] Tester une sélection de date.
- [ ] Tester une modification programmée de `value`.
- [ ] Tester les limites `first_date` et `last_date`.
- [ ] Tester le bouton d’effacement et l’événement associé.
- [ ] Tester le focus, le survol, le clavier, Échap et l’état désactivé.
- [ ] Vérifier l’absence de décalage d’un jour lié au fuseau horaire.
- [ ] Construire et tester l’extension sous Windows avec les versions actuellement retenues.

## Validation dans PaperNest

- [ ] Tester chaque formulaire utilisant une date.
- [ ] Vérifier l’affichage de la valeur initiale.
- [ ] Vérifier la sélection, la modification et l’effacement.
- [ ] Vérifier les dates minimales et maximales lorsqu’elles sont configurées.
- [ ] Vérifier les valeurs envoyées aux services et enregistrées dans les modèles.
- [ ] Vérifier le rendu visuel sous Windows.
- [ ] Faire valider le comportement réel par l’utilisateur.
- [ ] Mettre à jour la roadmap UI de PaperNest après validation.
- [ ] Mettre à jour le changelog de PaperNestExtension et celui de PaperNest.

## Nettoyage après validation

- [ ] Supprimer l’ancien code de date devenu inutile dans PaperNest.
- [ ] Supprimer les wrappers et imports obsolètes uniquement après la migration de `PaperNestFilePicker` si le nettoyage est commun.
- [ ] Vérifier l’ensemble de `forms.py` seulement après les migrations DatePicker et FilePicker.

## Critères de finalisation

La migration est terminée uniquement lorsque `PaperNestDatePicker` est fonctionnel dans tous les usages réels de PaperNest, que le build Windows est validé, que les comportements existants sont préservés et que l’ancien code devenu inutile a été supprimé sans nettoyage prématuré des éléments communs.
