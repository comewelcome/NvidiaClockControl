#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
NVIDIA_OC_CMD="$SCRIPT_DIR/nvidia_oc"

# Récupérer le nombre de GPU disponibles
GPU_COUNT=$(nvidia-smi --query-gpu=index --format=csv,noheader 2>/dev/null | wc -l)

if [[ -z "$GPU_COUNT" || "$GPU_COUNT" -eq 0 ]]; then
    echo "❌ Erreur : Aucun GPU NVIDIA détecté"
    exit 1
fi

# Fonction pour appliquer nvidia_oc sur tous les GPU
apply_oc() {
    local args="$1"
    for i in $(seq 0 $((GPU_COUNT - 1))); do
        echo "  → GPU $i : $NVIDIA_OC_CMD set -i $i $args"
        "$NVIDIA_OC_CMD" set -i "$i" $args
    done
}

case "$1" in
  eco)
    echo "🔋 Mode Éco activé (100W, sans overclock)"
    apply_oc "-p 100000"
    ;;
  med)
    echo "🌿 Mode Intermédiaire activé (200W, OC modéré)"
    apply_oc "-p 200000 -f 100 -m 500"
    ;;
  perf)
    echo "🚀 Mode Performance activé (300W, OC élevé)"
    apply_oc "-p 300000 -f 200 -m 1000"
    ;;
  *)
    echo "Usage : $0 [eco|med|perf]"
    exit 1
    ;;
esac

echo "✅ Appliqué sur $GPU_COUNT GPU(s)"
