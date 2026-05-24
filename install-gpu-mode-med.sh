#!/bin/bash
set -euo pipefail

# Chemins dynamiques basés sur le répertoire du script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
SERVICE_FILE="$SCRIPT_DIR/gpu-mode-med.service"
SERVICE_DEST="/etc/systemd/system/gpu-mode-med.service"

# Vérifications de prérequis
if [[ ! -f "$SERVICE_FILE" ]]; then
    echo "ERREUR : Fichier $SERVICE_FILE non trouvé."
    echo "Assurez-vous que gpu-mode-med.service est dans le même répertoire que ce script."
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "ERREUR : Ce script doit être exécuté avec les privilèges root (sudo)."
    exit 1
fi

if ! command -v systemctl &> /dev/null; then
    echo "ERREUR : systemctl non trouvé. systemd est requis."
    exit 1
fi

if ! command -v nvidia-smi &> /dev/null; then
    echo "ATTENTION : nvidia-smi non trouvé. Vérifiez que les pilotes NVIDIA sont installés."
fi

echo "Copie de gpu-mode-med.service vers $SERVICE_DEST..."
cp "$SERVICE_FILE" "$SERVICE_DEST"

echo "Rechargement du démon systemd..."
systemctl daemon-reload

echo "Activation de gpu-mode-med.service..."
systemctl enable gpu-mode-med.service

echo "Démarrage de gpu-mode-med.service..."
systemctl start gpu-mode-med.service

echo ""
echo "Vérification du statut du service..."
echo "========================================"
systemctl status gpu-mode-med.service --no-pager || true
echo "========================================"
echo ""
echo "Installation et activation terminées avec succès."
echo ""
echo "Pour désactiver temporairement le mode Med :"
echo "  sudo systemctl stop gpu-mode-med.service"
echo ""
echo "Pour le réactiver :"
echo "  sudo systemctl start gpu-mode-med.service"