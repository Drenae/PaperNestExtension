# Roadmap — PaperNestFilePicker

## Objectif

Fournir à PaperNest un contrôle unique pour la sélection, le dépôt, la validation et la gestion interne de fichiers, puis remplacer les mécanismes historiques de sélection de fichiers sans dupliquer l’état entre l’extension et l’application.

## Implémentation de l’extension

- [x] Création de l’API Python `PaperNestFilePicker`.
- [x] Implémentation Flutter du contrôle.
- [x] Regroupement de la sélection native, du glisser-déposer et de la liste interne des fichiers.
- [x] Création de `PaperNestFilePickerFile` pour représenter les fichiers sélectionnés.
- [x] Création de `PaperNestFilePickerUploadFile` pour les envois.
- [x] Création des états visuels `NORMAL`, `HOVER`, `DRAG_OVER`, `SUCCESS`, `ERROR` et `DISABLED`.
- [x] Création des types de fichiers `ANY`, `MEDIA`, `IMAGE`, `VIDEO`, `AUDIO` et `CUSTOM`.
- [x] Gestion des extensions autorisées.
- [x] Gestion de la sélection simple ou multiple.
- [x] Gestion du titre de la fenêtre de sélection.
- [x] Gestion optionnelle des données binaires avec `with_data`.
- [x] Gestion d’une zone personnalisée ou d’une zone PaperNest par défaut.
- [x] Gestion du glisser-déposer.
- [x] Gestion de l’ouverture de l’explorateur par clic.
- [x] Gestion de l’affichage intégré de la liste des fichiers.
- [x] Gestion de l’affichage de la taille des fichiers.
- [x] Gestion des icônes et des couleurs par type de fichier.
- [x] Gestion de `max_file_size` et `max_files`.
- [x] Gestion de l’affichage des contraintes.
- [x] Détection des doublons.
- [x] Validation des extensions, de la taille et du nombre maximal de fichiers.
- [x] Création des événements typés de dépôt, changement, ajout, suppression, doublon, validation et envoi.
- [x] Méthode publique `get_files()`.
- [x] Méthode publique `remove_file()`.
- [x] Méthode publique `clear_files()`.
- [x] Méthode publique `upload()`.
- [x] Méthode publique `get_directory_path()` pour les plateformes compatibles.
- [x] Export public depuis `papernestextension.controls` et `papernestextension`.

## État actuel dans PaperNest

- [ ] Inventorier précisément tous les mécanismes actuels de sélection de fichiers et de dossiers.
- [ ] Identifier les usages de `ft.FilePicker`, de `flet-dropzone` et des wrappers présents dans `forms.py` ou ailleurs.
- [ ] Identifier les écrans utilisant une sélection simple, multiple, un dossier ou un glisser-déposer.
- [ ] Vérifier les formats de fichiers et les contraintes réellement utilisés par PaperNest.
- [ ] Vérifier comment PaperNest conserve actuellement les chemins, les octets et les métadonnées.
- [ ] Le contrôle de l’extension n’est pas encore utilisé dans PaperNest.

## Préparation de la migration

- [ ] Comparer l’API réelle de `PaperNestFilePicker` avec chaque usage existant dans PaperNest.
- [ ] Déterminer si un wrapper thématique léger est nécessaire.
- [ ] Ne conserver que les propriétés utiles aux besoins réels de PaperNest.
- [ ] Définir clairement la source de vérité de la sélection pour éviter une seconde liste parallèle dans PaperNest.
- [ ] Prévoir le traitement des chemins Windows et des données binaires selon les usages réels.
- [ ] Vérifier la compatibilité avec les traitements PDF et les services d’import de PaperNest.

## Migration dans PaperNest

- [ ] Remplacer progressivement les sélecteurs historiques par `PaperNestFilePicker`.
- [ ] Migrer les usages de sélection simple.
- [ ] Migrer les usages de sélection multiple.
- [ ] Migrer les usages de glisser-déposer concernés.
- [ ] Migrer la sélection de dossier uniquement lorsqu’elle est réellement utilisée.
- [ ] Adapter les événements aux services existants sans dupliquer l’état des fichiers.
- [ ] Préserver les messages d’erreur et retours utilisateur déjà validés.
- [ ] Préserver les contraintes d’extensions, de taille et de nombre de fichiers.
- [ ] Ne supprimer l’ancien code qu’après validation de chaque parcours.
- [ ] Retirer `flet-dropzone` du projet uniquement s’il n’est plus utilisé après la migration complète.

## Validation dans l’extension

- [ ] Vérifier l’exemple fonctionnel du contrôle.
- [ ] Tester la sélection par clic.
- [ ] Tester le glisser-déposer.
- [ ] Tester la sélection simple et multiple.
- [ ] Tester l’ajout, la suppression et l’effacement complet.
- [ ] Tester la détection des doublons.
- [ ] Tester les extensions interdites.
- [ ] Tester la limite de taille.
- [ ] Tester le nombre maximal de fichiers.
- [ ] Tester les états visuels et l’état désactivé.
- [ ] Tester `get_files()`, `remove_file()` et `clear_files()`.
- [ ] Tester la sélection de dossier sur Windows lorsqu’elle est nécessaire.
- [ ] Construire et tester l’extension sous Windows avec les versions actuellement retenues.

## Validation dans PaperNest

- [ ] Tester chaque écran utilisant des fichiers ou dossiers.
- [ ] Vérifier les chemins transmis aux services.
- [ ] Vérifier les données binaires lorsqu’elles sont demandées.
- [ ] Vérifier l’import et le traitement des PDF.
- [ ] Vérifier les erreurs de validation et les doublons.
- [ ] Vérifier le rendu visuel sous Windows.
- [ ] Vérifier que la sélection interne du contrôle reste la seule source de vérité lorsque cela est prévu.
- [ ] Faire valider chaque parcours réel par l’utilisateur.
- [ ] Mettre à jour la roadmap UI de PaperNest après validation.
- [ ] Mettre à jour le changelog de PaperNestExtension et celui de PaperNest.

## Nettoyage après validation

- [ ] Supprimer les anciens wrappers et contrôles de sélection devenus inutiles.
- [ ] Supprimer les imports obsolètes.
- [ ] Retirer les dépendances devenues inutiles uniquement après vérification globale.
- [ ] Vérifier l’ensemble de `forms.py` après les migrations DatePicker et FilePicker.
- [ ] Effectuer le nettoyage global commun seulement à la fin des deux migrations.

## Critères de finalisation

La migration est terminée uniquement lorsque tous les parcours réels de sélection et de dépôt de fichiers de PaperNest utilisent le nouveau contrôle de manière fiable, que le build Windows est validé, que les traitements existants fonctionnent encore et que les anciens wrappers, imports et dépendances devenus inutiles ont été supprimés après validation complète.
