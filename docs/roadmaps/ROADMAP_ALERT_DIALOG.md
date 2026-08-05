# Roadmap — Abandon de PaperNestAlertDialog

## État

**Décision validée : `PaperNestAlertDialog` doit être supprimé de PaperNestExtension.**

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

- [ ] `AppDialog` hérite directement de `ft.AlertDialog`.
- [ ] Header sombre PaperNest construit en Python.
- [ ] Pastille d’icône construite en Python.
- [ ] Titre et sous-titre contrôlables en Python.
- [ ] `title_action` contrôlable en Python.
- [ ] Contenu libre : `Column`, `Row`, `ListView`, `GridView`, `Tabs`, contrôles avec `expand` et scroll interne.
- [ ] Actions utilisant les boutons PaperNest.
- [ ] Variants `STANDARD`, `PRIMARY`, `SUCCESS`, `WARNING` et `DANGER` gérés uniquement dans `dialogs.py`.
- [ ] Modalité, barrière, fermeture et événement `on_dismiss` conservés via `ft.AlertDialog`.

## Phase 1 — Reconstruction Python dans PaperNest

- [ ] Reprendre l’apparence historique de `AppDialog` avant la migration vers l’extension.
- [ ] Construire le header avec des contrôles Python.
- [ ] Construire la surface générale sans imposer de hauteur artificielle.
- [ ] Préserver les contenus avec `expand=True`.
- [ ] Préserver les contenus qui gèrent leur propre scroll.
- [ ] Préserver `ConfirmDialog`, `DangerDialog` et `FormDialog`.
- [ ] Préserver l’enum local `DialogVariant`.
- [ ] Auditer tous les appels directs à `AppDialog`.

## Phase 2 — Validation PaperNest

- [ ] Tester les dialogues courts à hauteur naturelle.
- [ ] Tester les formulaires extensibles.
- [ ] Tester `MetadataDialog`.
- [ ] Tester `CategoryEditorDialog`.
- [ ] Tester les dialogues de déplacement, renommage, suppression et restauration.
- [ ] Vérifier les contenus scrollables avec header et actions fixes.
- [ ] Vérifier les dialogues successifs et imbriqués.
- [ ] Valider `flet run --recursive`.
- [ ] Valider le build Windows.
- [ ] Faire valider visuellement et fonctionnellement par l’utilisateur.

## Phase 3 — Suppression de PaperNestExtension

Cette phase ne commence qu’après validation complète de la version Python dans PaperNest.

- [ ] Supprimer `papernest_alert_dialog.py`.
- [ ] Supprimer `papernest_alert_dialog.dart`.
- [ ] Supprimer l’enregistrement Flutter du contrôle.
- [ ] Supprimer les exports Python.
- [ ] Supprimer la page d’exemple dédiée ou la remplacer par un exemple Python natif si utile.
- [ ] Supprimer `PaperNestDialogSurface` une fois les pickers migrés.
- [ ] Nettoyer les imports, la documentation et les changelogs.
- [ ] Compiler et valider PaperNestExtension après nettoyage.

## Phase 4 — Clôture

- [ ] Vérifier qu’aucune référence à `PaperNestAlertDialog` ne subsiste.
- [ ] Vérifier qu’aucun picker ne dépend d’un dialogue Flutter interne.
- [ ] Marquer le contrôle comme supprimé et remplacé par une composition Python.

## Critère de finalisation

La roadmap sera terminée lorsque tous les dialogues PaperNest fonctionneront avec `ft.AlertDialog`, que les contenus extensibles et scrollables seront validés, puis que `PaperNestAlertDialog` et ses dépendances auront été retirés de l’extension sans régression.
