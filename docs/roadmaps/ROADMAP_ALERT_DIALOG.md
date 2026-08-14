# Roadmap — Abandon de PaperNestAlertDialog

## État

**Nettoyage terminé : `PaperNestAlertDialog` a été remplacé par `AppDialog(ft.AlertDialog)` côté Python puis supprimé de PaperNestExtension. Rebuild Windows final à valider.**

Le fork Flutter n’apporte aucune capacité fonctionnelle indispensable par rapport à `ft.AlertDialog`. Il ajoute uniquement une composition visuelle, tout en introduisant des incompatibilités de contraintes avec les contenus extensibles, les scrolls internes et les mises en page complexes de PaperNest.

## Principe directeur

L’apparence et la composition d’un dialogue relèvent de PaperNest et doivent rester entièrement contrôlables en Python.

Architecture cible :

```text
PaperNest
└── AppDialog(ft.AlertDialog)
    ├── header Python
    ├── content Python
    ├── actions Python
    └── variants Python

PaperNestExtension
└── aucun contrôle AlertDialog personnalisé
```

## Ce qui doit rester fonctionnel

- [x] `AppDialog` hérite directement de `ft.AlertDialog`.
- [x] Header sombre PaperNest construit en Python.
- [x] Pastille d’icône construite en Python.
- [x] Titre et sous-titre contrôlables en Python.
- [x] `title_action` contrôlable en Python.
- [x] Contenu libre : `Column`, `Row`, `ListView`, `GridView`, `Tabs`, contrôles avec `expand` et scroll interne.
- [x] Actions utilisant les boutons PaperNest.
- [x] Variants `STANDARD`, `PRIMARY`, `SUCCESS`, `WARNING` et `DANGER` gérés uniquement dans `dialogs.py`.
- [x] Modalité, barrière, fermeture et événement `on_dismiss` conservés via `ft.AlertDialog`.

## Phase 1 — Reconstruction Python dans PaperNest

- [x] Reprendre l’apparence historique de `AppDialog` avant la migration vers l’extension.
- [x] Construire le header avec des contrôles Python.
- [x] Construire la surface générale sans imposer de hauteur artificielle.
- [x] Préserver les contenus avec `expand=True`.
- [x] Préserver les contenus qui gèrent leur propre scroll.
- [x] Préserver `ConfirmDialog`, `DangerDialog` et `FormDialog`.
- [x] Préserver l’enum local `DialogVariant`.
- [x] Auditer tous les appels directs à `AppDialog`.

## Phase 2 — Validation PaperNest

- [x] Tester les dialogues courts à hauteur naturelle.
- [x] Tester les formulaires extensibles.
- [x] Tester `MetadataDialog`.
- [x] Tester `CategoryEditorDialog`.
- [x] Tester les dialogues de déplacement, renommage, suppression et restauration.
- [x] Vérifier les contenus scrollables avec header et actions fixes.
- [x] Vérifier les dialogues successifs et imbriqués.
- [x] Valider `flet run --recursive`.
- [x] Valider le build Windows.
- [x] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 3 — Suppression de PaperNestExtension

Cette phase ne commence qu’après validation complète de la version Python dans PaperNest.

- [x] Supprimer `papernest_alert_dialog.py`.
- [x] Supprimer `papernest_alert_dialog.dart`.
- [x] Supprimer l’enregistrement Flutter du contrôle.
- [x] Supprimer les exports Python.
- [x] Supprimer la page d’exemple dédiée.
- [x] Supprimer `PaperNestDialogSurface` une fois les pickers migrés.
- [x] Nettoyer les imports, la documentation et les changelogs.
- [ ] Compiler et valider PaperNestExtension après nettoyage.

## Phase 4 — Clôture

- [x] Vérifier qu’aucune référence de code à `PaperNestAlertDialog` ne subsiste.
- [x] Vérifier qu’aucun picker ne dépend d’un dialogue Flutter interne.
- [x] Marquer le contrôle comme supprimé et remplacé par une composition Python.

## Critère de finalisation

La roadmap sera terminée lorsque tous les dialogues PaperNest fonctionneront avec `ft.AlertDialog`, que les contenus extensibles et scrollables seront validés, puis que `PaperNestAlertDialog` et ses dépendances auront été retirés de l’extension sans régression.
