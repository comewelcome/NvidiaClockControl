# NvidiaPowerManager

## Gestionnaire de Modes de Performance GPU NVIDIA pour Linux

Ce projet fournit une solution complète pour gérer et optimiser les performances et la consommation d'énergie des cartes graphiques NVIDIA sous Linux. Il permet aux utilisateurs de basculer facilement entre différents modes de performance (Éco, Intermédiaire, Performance) via des scripts shell, des raccourcis de bureau et un service systemd pour une application automatique au démarrage.

### Fonctionnalités

*   **Trois Modes de Performance** :
    *   **Éco (Eco)** : Optimisé pour une faible consommation d'énergie, idéal pour les tâches légères ou l'économie de batterie.
    *   **Intermédiaire (Med)** : Un équilibre entre performance et consommation, adapté à un usage quotidien.
    *   **Performance (Perf)** : Maximise les performances du GPU pour les jeux ou les applications gourmandes en ressources.
*   **Gestion de la Puissance et de l'Overclocking** : Utilise un outil personnalisé (`nvidia_oc`) pour ajuster les limites de puissance et les décalages de fréquence (overclocking).
*   **Contrôle des Fréquences d'Horloge** : Utilise `nvidia-smi` pour verrouiller ou limiter les fréquences d'horloge du GPU.
*   **Automatisation au Démarrage** : Un service systemd (`gpu-mode-med.service`) permet d'appliquer automatiquement le mode "Intermédiaire" au démarrage du système.
*   **Raccourcis Bureau** : Des fichiers `.desktop` sont fournis pour un changement de mode rapide via l'environnement de bureau.

### Modes Détaillés

#### Mode Éco
*   **`gpu-tuning.sh eco`**: Limite la puissance du GPU à 100W, sans overclocking.
*   **`gpuconfig.sh eco`**: Verrouille la fréquence du GPU à 210 MHz pour une consommation minimale.

#### Mode Intermédiaire (Med)
*   **`gpu-tuning.sh med`**: Limite la puissance du GPU à 200W, avec un overclocking modéré (+100 MHz core, +500 MHz mémoire).
*   **`gpuconfig.sh med`**: Limite la fréquence du GPU entre 1000 MHz et 1200 MHz, visant une consommation maximale d'environ 150W.

#### Mode Performance (Perf)
*   **`gpu-tuning.sh perf`**: Limite la puissance du GPU à 300W, avec un overclocking élevé (+200 MHz core, +1000 MHz mémoire).
*   **`gpuconfig.sh perf`**: Restaure les fréquences d'horloge du GPU à leurs valeurs par défaut.

### Prérequis

*   Un système d'exploitation Linux.
*   Une carte graphique NVIDIA avec les pilotes propriétaires installés.
*   `nvidia-smi` (généralement inclus avec les pilotes NVIDIA).
*   `systemd` (pour l'automatisation au démarrage).
*   L'exécutable `nvidia_oc` (fourni dans ce dépôt).

### Installation du Service `gpu-mode-med.service`

Le script [`install-gpu-mode-med.sh`](install-gpu-mode-med.sh) automatise l'installation du service systemd pour appliquer le mode "Intermédiaire" au démarrage.

1.  **Assurez-vous que le fichier `gpu-mode-med.service` est dans le même répertoire que le script d'installation.**
2.  Exécutez le script avec les privilèges root :
    ```bash
    sudo ./install-gpu-mode-med.sh
    ```
    Ce script va :
    *   Copier [`gpu-mode-med.service`](gpu-mode-med.service) vers `/etc/systemd/system/`.
    *   Recharger le démon systemd.
    *   Activer et démarrer le service `gpu-mode-med.service`.
    *   Afficher le statut du service pour confirmation.

### Utilisation

#### Changement de Mode Manuel via Scripts

Vous pouvez exécuter les scripts [`gpu-tuning.sh`](gpu-tuning.sh) et [`gpuconfig.sh`](gpuconfig.sh) manuellement depuis le terminal.

*   **Pour le mode Éco :**
    ```bash
    ./gpu-tuning.sh eco
    sudo ./gpuconfig.sh eco
    ```
*   **Pour le mode Intermédiaire :**
    ```bash
    ./gpu-tuning.sh med
    sudo ./gpuconfig.sh med
    ```
*   **Pour le mode Performance :**
    ```bash
    ./gpu-tuning.sh perf
    sudo ./gpuconfig.sh perf
    ```
    **Note** : Il est recommandé d'exécuter les deux scripts pour une configuration complète du mode.

#### Changement de Mode via Raccourcis Bureau

Les fichiers `.desktop` (par exemple, `gpu-eco.desktop`, `gpu-med.desktop`, `gpu-perf.desktop`) sont conçus pour être utilisés comme raccourcis graphiques.
1.  Copiez ces fichiers dans `~/.local/share/applications/` pour qu'ils apparaissent dans votre menu d'applications.
2.  Assurez-vous qu'ils ont les permissions d'exécution.
3.  Cliquez sur le raccourci désiré pour changer de mode.

### Structure du Projet

```
.
├── gpu-eco.desktop             # Raccourci bureau pour le mode Éco
├── gpu-med.desktop             # Raccourci bureau pour le mode Intermédiaire
├── gpu-mode-med.service        # Définition du service systemd pour le mode Intermédiaire au démarrage
├── gpu-perf.desktop            # Raccourci bureau pour le mode Performance
├── gpu-tuning.sh               # Script pour la gestion de la puissance et l'overclocking (utilise nvidia_oc)
├── gpuconfig.sh                # Script pour la gestion des fréquences d'horloge (utilise nvidia-smi)
├── install-gpu-mode-med.sh     # Script d'installation du service gpu-mode-med.service
├── lancer med au demarahe.txt  # Notes ou instructions pour le démarrage du mode Med
└── nvidia_oc                   # Exécutable personnalisé pour l'overclocking NVIDIA
```

### Contribution

Les contributions sont les bienvenues ! N'hésitez pas à soumettre des issues ou des pull requests.

### Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.