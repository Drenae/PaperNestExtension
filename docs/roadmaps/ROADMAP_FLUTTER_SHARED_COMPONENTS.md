# Roadmap — Architecture Flutter partagée

## Statut final

**Roadmap clôturée sans extraction supplémentaire.**

Cette roadmap avait été créée lorsque `PaperNestAlertDialog`, `PaperNestColorPicker`, `PaperNestIconPicker` et `PaperNestDatePicker` dupliquaient plusieurs responsabilités Flutter : surfaces de dialogue, bordures, actions internes et cycles de fermeture.

La refonte Python-first a supprimé ces quatre contrôles ainsi que `PaperNestDialogSurface`. La majorité des duplications identifiées n’existe donc plus et la création de nouveaux helpers Flutter partagés n’apporterait aucun gain réel.

## Décision retenue

- [x] Supprimer les contrôles à l’origine des duplications au lieu d’ajouter une couche d’abstraction.
- [x] Conserver `form_field.dart` pour les contrôles de formulaire qui l’utilisent réellement.
- [x] Conserver `PaperNestButton`, finalisé dans sa roadmap dédiée.
- [x] Conserver `PaperNestTextField` et `PaperNestDropdown` stables.
- [x] Ne créer aucun widget d’action ou de dialogue Flutter devenu inutile.
- [x] Ne pas extraire des helpers sans duplication concrète restante.
- [x] Valider le fonctionnement et le build Windows après le nettoyage.

## Règle de maintenance

Une nouvelle abstraction Flutter ne sera créée que si une même responsabilité est réellement dupliquée dans plusieurs contrôles encore actifs et si son extraction simplifie clairement leur maintenance sans changer leur API ni leur rendu.
