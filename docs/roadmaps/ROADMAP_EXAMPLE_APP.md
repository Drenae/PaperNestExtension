# Roadmap — Application d’exemple PaperNestExtension

## État

La nouvelle application d’exemple navigable est implémentée. Les tests Windows restent à effectuer.

L’ancien écran unique a été remplacé par une petite application structurée autour de `PaperNestGlideRail`.

## Objectif

Créer une application d’exemple claire, extensible et agréable à utiliser, dans laquelle chaque nouvelle famille de contrôles peut être ajoutée à une page dédiée sans modifier toute l’application.

## Architecture

- [x] Conserver `main.py` comme point d’entrée minimal.
- [x] Créer `app/main_window.py` pour la navigation et le contenu actif.
- [x] Utiliser `PaperNestGlideRail` comme navigation principale et comme exemple réel du contrôle.
- [x] Créer une page `Accueil` présentant tous les contrôles disponibles et leur fonction.
- [x] Créer une page `Formulaires` contenant les panneaux `PaperNestTextField` et `PaperNestDropdown`.
- [x] Créer une page `Pickers` contenant les panneaux `PaperNestColorPicker`, `PaperNestDatePicker`, `PaperNestFilePicker` et `PaperNestIconPicker`.
- [x] Créer un panneau dédié pour `PaperNestIconPicker`.
- [x] Prévoir une structure permettant d’ajouter plus tard d’autres pages par famille de contrôles.

## Organisation réalisée

```text
examples/papernestextension_example/src/
    main.py
    app/
        __init__.py
        main_window.py
        pages/
            __init__.py
            home_page.py
            forms_page.py
            pickers_page.py
    panels/
        papernest_iconpicker_panel.py
        ...
```

## Comportement attendu

- [x] Une seule page d’exemple affichée à la fois.
- [x] Contenu réservé uniquement à la largeur compacte de `PaperNestGlideRail`.
- [x] Déploiement de la rail en superposition.
- [x] Pages indépendantes avec leur propre défilement.
- [x] Navigation Accueil, Formulaires et Pickers.
- [ ] Vérifier la présentation réelle sur Windows.

## Nettoyage

- [x] Déplacer les fonctions d’exemple hors de `main.py`.
- [x] Conserver les panneaux spécialisés existants.
- [x] Supprimer les anciens imports et fonctions de `main.py`.
- [x] Vérifier que chaque contrôle public actuel apparaît dans l’application d’exemple.

## Validation

- [ ] Lancer l’exemple avec `flet run`.
- [ ] Tester toutes les destinations.
- [ ] Tester tous les contrôles existants.
- [ ] Vérifier le comportement responsive des pages.
- [ ] Valider le build Windows.
- [ ] Faire valider visuellement et fonctionnellement l’application par l’utilisateur.

## Critère de finalisation

Le chantier sera terminé après validation du lancement, de la navigation, de tous les contrôles et du build Windows.
