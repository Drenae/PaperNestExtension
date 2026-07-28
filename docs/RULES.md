# Règles de développement — PaperNestExtension

## Finalité

PaperNestExtension existe uniquement pour servir les besoins concrets de PaperNest. Ce n’est pas une bibliothèque générique destinée à être distribuée largement ou à concurrencer Flet.

## Règles obligatoires

- Ne jamais ajouter un contrôle sans besoin réel identifié dans PaperNest.
- Étudier l’API existante avant toute modification.
- Préserver la compatibilité avec les versions Flet, Flutter et Pyodide choisies pour le projet.
- Ne pas effectuer de mise à niveau de dépendances sans validation explicite.
- Éviter la duplication de code et préférer les bases communes et variantes spécialisées.
- Garder une API Python claire, stable et cohérente avec les usages de PaperNest.
- Maintenir la cohérence entre la partie Python et la partie Flutter.
- Vérifier les valeurs affichées, les événements, le focus, le clavier, le survol et les états désactivés lorsqu’ils sont concernés.
- Ajouter ou mettre à jour un exemple fonctionnel pour chaque contrôle.
- Ne pas considérer un contrôle comme terminé avant sa validation dans PaperNest.
- Corriger la cause réelle d’un bug et ne pas masquer le problème avec un contournement fragile.
- Mettre à jour `docs/roadmaps/ROADMAP_CONTROLS.md` après toute évolution importante.
- Créer puis maintenir `docs/roadmaps/ROADMAP_<CONTROL>.md` lorsqu’un nouveau contrôle est ajouté ou profondément retravaillé.
- Mettre à jour `docs/CHANGELOG.md` pour toute modification notable.
- Utiliser des messages de commit explicites et ciblés.
- Ne pas introduire de contrôle ou fonctionnalité non demandé « pour plus tard ».

## Définition de terminé

Un contrôle est terminé uniquement lorsque :

- l’API Python est finalisée ;
- l’implémentation Flutter est fonctionnelle ;
- l’exemple est à jour ;
- le build concerné réussit ;
- l’intégration dans PaperNest est validée ;
- les bugs connus sont résolus ;
- la roadmap et le changelog sont à jour.
