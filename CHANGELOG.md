# Résumé des modifications - NvidiaPowerManager

## Date : 24/05/2026

### Configuration matérielle
- **GPU 0** : NVIDIA GeForce RTX 3090
- **GPU 1** : NVIDIA GeForce RTX 3060

---

## Bugs corrigés

### 1. Service systemd brisé (`gpu-mode-med.service`)
- **Problème** : Deux lignes `ExecStart` dans le service, seule la dernière était exécutée → `gpuconfig.sh` jamais appelé au démarrage.
- **Solution** : Fusion des deux commandes en une seule avec `/bin/bash -c "..."`.

### 2. Overclocking manquant en mode Med (`gpu-tuning.sh`)
- **Problème** : Le mode `med` ne setait que la puissance (`-p 200000`) sans overclocking, contrairement au README qui mentionnait +100 MHz core / +500 MHz mémoire.
- **Solution** : Ajout de `-f 100 -m 500` dans la commande `nvidia_oc` pour le mode med.

### 3. Raccourcis bureau incomplets (`gpu-*.desktop`)
- **Problème** : Les fichiers `.desktop` n'appelaient que `gpu-tuning.sh` sans `gpuconfig.sh`, donc les fréquences d'horloge n'étaient pas appliquées via les raccourcis.
- **Solution** : Ajout de `gpuconfig.sh` dans chaque lanceur via `/bin/bash -c "... && ..."`.

### 4. Script d'installation fragile (`install-gpu-mode-med.sh`)
- **Problème** : Chemins en dur, aucune vérification de prérequis, pas de gestion d'erreurs.
- **Solution** : Réécriture complète avec `SCRIPT_DIR` dynamique, vérifications (fichier service, root, systemd, nvidia-smi), `set -euo pipefail`, messages d'aide.

### 5. Scripts mono-GPU (`gpu-tuning.sh` + `gpuconfig.sh`)
- **Problème** : Les scripts ciblait uniquement `-i 0` (GPU 0), ignorant le GPU 1.
- **Solution** : Détection automatique du nombre de GPU via `nvidia-smi`, boucle sur tous les GPU avec fonctions `apply_all_gpus()` et `apply_oc()`.

---

## Modes de performance

| Mode | Puissance | Overclocking | Fréquence GPU |
|------|-----------|--------------|---------------|
| Éco | 100W | Aucun | 210 MHz (verrouillé) |
| Med | 200W | +100 MHz core, +500 MHz mem | 1000-1200 MHz |
| Perf | 300W | +200 MHz core, +1000 MHz mem | Défaut |

---

## Fichiers modifiés

| Fichier | Modification |
|---------|-------------|
| `gpu-mode-med.service` | ExecStart fusionné en une commande bash |
| `gpu-tuning.sh` | Multi-GPU + overclocking mode med |
| `gpuconfig.sh` | Multi-GPU + détection automatique |
| `gpu-eco.desktop` | Ajout de gpuconfig.sh |
| `gpu-med.desktop` | Ajout de gpuconfig.sh |
| `gpu-perf.desktop` | Ajout de gpuconfig.sh |
| `install-gpu-mode-med.sh` | Réécriture complète avec gestion d'erreurs |
| `lancer med au demarahe.txt` | Instructions complètes |
| `README.md` | Documentation mise à jour + dépannage |

---

## Commandes utiles

```bash
# Installation du service
sudo ./install-gpu-mode-med.sh

# Changement de mode manuel
./gpu-tuning.sh med && sudo ./gpuconfig.sh med

# Arrêter le service
sudo systemctl stop gpu-mode-med.service

# Redémarrer le service
sudo systemctl start gpu-mode-med.service

# Vérifier les fréquences
nvidia-smi --query-gpu=index,name,clocks.current.graphics,clocks.max.graphics --format=csv