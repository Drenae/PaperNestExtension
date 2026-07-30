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

- [x] Inventaire complet des mécanismes de sélection de fichiers et de dossiers.
- [x] Identification des usages historiques de `ft.FilePicker`, `flet-dropzone`, `BaseFilePicker` et `FileDropZone`.
- [x] Identification des parcours de sélection multiple, glisser-déposer et sélection simple ZIP.
- [x] Vérification des formats et contraintes réellement utilisés.
- [x] Vérification de l’utilisation des chemins locaux sans `with_data`.
- [x] Utilisation effective de `PaperNestFilePicker` dans PaperNest.

### Inventaire confirmé

- `UploadPanel` utilise une sélection multiple, le glisser-déposer et un bouton externe appelant `pick_files()`.
- `BackupPanel` utilise une sélection simple limitée aux sauvegardes `zip` via son bouton `restore_button`.
- Les parcours utilisent les chemins locaux des fichiers ; `with_data` n’est pas requis.
- Les métadonnées applicatives par fichier, notamment le classeur cible, restent gérées par PaperNest et sont reliées aux identifiants du contrôle.

## Préparation de la migration

- [x] Comparaison de l’API réelle de `PaperNestFilePicker` avec chaque usage existant.
- [x] Lecture et vérification de l’exemple fonctionnel de l’extension.
- [x] Création du wrapper thématique léger `BaseFilePicker` héritant directement de `PaperNestFilePicker`.
- [x] Conservation uniquement des propriétés utiles aux besoins réels de PaperNest.
- [x] Définition de la sélection interne du contrôle comme source de vérité.
- [x] Prévision du traitement des chemins Windows et des données binaires selon les usages réels.
- [x] Vérification de la compatibilité avec les traitements PDF et les services d’import de PaperNest.

## Migration dans PaperNest

- [x] Remplacement des sélecteurs historiques par `PaperNestFilePicker`.
- [x] Migration de la sélection simple des sauvegardes ZIP.
- [x] Migration de la sélection multiple de documents.
- [x] Migration du glisser-déposer dans le tableau de bord.
- [x] Conservation du bouton « Ajouter des fichiers » appelant explicitement `pick_files()`.
- [x] Adaptation des événements aux services existants sans dupliquer l’état de sélection.
- [x] Préservation des messages d’erreur et retours utilisateur validés.
- [x] Préservation de la contrainte d’extension `zip` dans l’administration.
- [x] Suppression du `BaseFilePicker` historique fondé sur `ft.FilePicker`.
- [x] Suppression du `FileDropZone` historique fondé sur `flet-dropzone`.
- [x] Suppression de la dépendance `flet-dropzone` du projet PaperNest.
- [x] Nettoyage des imports obsolètes liés aux anciens sélecteurs.
- [x] La sélection de dossier n’est pas utilisée par les parcours actuels et n’a pas été migrée inutilement.

## Validation dans l’extension

- [x] Vérification de l’exemple fonctionnel et de son bouton externe `pick_files()`.
- [ ] Tester la sélection par clic dans l’exemple dédié.
- [ ] Tester le glisser-déposer dans l’exemple dédié.
- [ ] Tester la sélection simple et multiple dans l’exemple dédié.
- [ ] Tester l’ajout, la suppression et l’effacement complet dans l’exemple dédié.
- [ ] Tester la détection des doublons dans l’exemple dédié.
- [ ] Tester les extensions interdites dans l’exemple dédié.
- [ ] Tester la limite de taille dans l’exemple dédié.
- [ ] Tester le nombre maximal de fichiers dans l’exemple dédié.
- [ ] Tester les états visuels et l’état désactivé dans l’exemple dédié.
- [ ] Tester `get_files()`, `remove_file()` et `clear_files()` dans l’exemple dédié.
- [ ] Tester la sélection de dossier sur Windows uniquement lorsqu’un besoin réel apparaîtra.
- [ ] Construire et tester l’exemple de l’extension sous Windows avec les versions actuellement retenues.

## Validation dans PaperNest

- [x] Test du tableau de bord avec sélection par clic.
- [x] Test du glisser-déposer.
- [x] Test de la sélection multiple.
- [x] Test de l’ajout, de la suppression et de l’effacement complet.
- [x] Test de la détection des doublons.
- [x] Test du bouton externe « Ajouter des fichiers ».
- [x] Test du parcours de restauration depuis `restore_button`.
- [x] Vérification des chemins transmis aux services.
- [x] Vérification de l’import et du traitement des PDF.
- [x] Vérification du rendu visuel sous Windows.
- [x] Vérification que la sélection interne du contrôle reste la source de vérité.
- [x] Validation de chaque parcours réel par l’utilisateur.
- [x] Validation du build Windows de PaperNest.
- [x] Mise à jour de la roadmap UI de PaperNest.
- [ ] Mise à jour du changelog de PaperNestExtension et de celui de PaperNest.

## Nettoyage après validation

- [x] Suppression des anciens wrappers et contrôles de sélection devenus inutiles.
- [x] Suppression des imports obsolètes.
- [x] Retrait de la dépendance `flet-dropzone` devenue inutile.
- [x] Vérification de l’ensemble de `forms.py` après les migrations DatePicker et FilePicker.
- [x] Nettoyage global commun effectué après validation des deux migrations.

## Critères de finalisation

La migration dans PaperNest est terminée : tous les parcours réels utilisent `PaperNestFilePicker`, le bouton externe et le glisser-déposer alimentent la même sélection interne, l’administration utilise le nouveau contrôle pour les sauvegardes ZIP, le build Windows est validé et les anciens wrappers, imports et dépendances ont été supprimés. Les tests exhaustifs de l’exemple dédié de PaperNestExtension restent suivis séparément.
