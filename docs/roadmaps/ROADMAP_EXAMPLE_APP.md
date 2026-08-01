# Roadmap — Application d’exemple PaperNestExtension

## État

Chantier ouvert après finalisation de `PaperNestIconPicker`.

L’exemple actuel rassemble tous les panneaux sur une seule longue page. Il doit devenir une petite application de démonstration structurée, navigable avec `PaperNestGlideRail`.

## Objectif

Créer une application d’exemple claire, extensible et agréable à utiliser, dans laquelle chaque nouvelle famille de contrôles peut être ajoutée à une page dédiée sans modifier toute l’application.

## Architecture prévue

- [ ] Conserver `main.py` comme point d’entrée minimal.
- [ ] Créer une fenêtre principale dédiée à la navigation et au cycle de vie des pages.
- [ ] Utiliser `PaperNestGlideRail` comme navigation principale et comme exemple réel du contrôle.
- [ ] Créer une page `Accueil` présentant tous les contrôles disponibles et leur fonction.
- [ ] Créer une page `Formulaires` contenant les panneaux `PaperNestTextField` et `PaperNestDropdown`.
- [ ] Créer une page `Pickers` contenant les panneaux `PaperNestColorPicker`, `PaperNestDatePicker`, `PaperNestFilePicker` et `PaperNestIconPicker`.
- [ ] Prévoir une structure simple permettant d’ajouter plus tard d’autres pages par famille de contrôles.

## Organisation proposée

```text
examples/papernestextension_example/src/
    main.py
    app/
        main_window.py
        navigation.py
        pages/
            home_page.py
            forms_page.py
            pickers_page.py
    panels/
        ...
```

## Comportement attendu

- [ ] Aucun grand écran unique nécessitant de faire défiler tous les exemples.
- [ ] Une seule page d’exemple affichée à la fois.
- [ ] Navigation fluide sans recréer inutilement toute l’application.
- [ ] Contenu réservé uniquement à la largeur compacte de `PaperNestGlideRail`.
- [ ] Déploiement de la rail en superposition.
- [ ] Présentation cohérente sur Windows.

## Nettoyage

- [ ] Déplacer les fonctions d’exemple encore présentes dans `main.py` vers les pages ou panneaux appropriés.
- [ ] Conserver les panneaux spécialisés déjà utiles.
- [ ] Supprimer les imports et fonctions devenus inutiles.
- [ ] Vérifier que chaque contrôle public apparaît dans l’application d’exemple.

## Validation

- [ ] Lancer l’exemple avec `flet run`.
- [ ] Tester toutes les destinations.
- [ ] Tester tous les contrôles existants.
- [ ] Valider le build Windows.
- [ ] Faire valider visuellement et fonctionnellement l’application par l’utilisateur.

## Critère de finalisation

Le chantier sera terminé lorsque l’exemple sera une petite application navigable, que toutes les familles de contrôles auront leur page dédiée, que `main.py` sera réduit au point d’entrée et que le build Windows aura été validé.
