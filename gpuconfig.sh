#!/bin/bash

# Récupérer le nombre de GPU disponibles
GPU_COUNT=$(nvidia-smi --query-gpu=index --format=csv,noheader 2>/dev/null | wc -l)

if [[ -z "$GPU_COUNT" || "$GPU_COUNT" -eq 0 ]]; then
    echo "❌ Erreur : Aucun GPU NVIDIA détecté"
    exit 1
fi

# Fonction pour appliquer une commande sur tous les GPU
apply_all_gpus() {
    local cmd_base="$1"
    for i in $(seq 0 $((GPU_COUNT - 1))); do
        eval "$cmd_base -i $i"
    done
}

case "$1" in
  eco)
    echo "🔋 Mode Éco activé (fréquence verrouillée à 210 MHz)"
    apply_all_gpus "sudo nvidia-smi -pm 1"
    apply_all_gpus "sudo nvidia-smi -lgc 210,210"
    ;;
  med)
    echo "🌿 Mode Intermédiaire activé (fréquence limitée pour conso max ~150W)"
    apply_all_gpus "sudo nvidia-smi -pm 1"
    apply_all_gpus "sudo nvidia-smi -lgc 1000,1200"
    ;;
  perf)
    echo "🚀 Mode Performance restauré"
    apply_all_gpus "sudo nvidia-smi -rgc"
    ;;
  *)
    echo "Usage : $0 [eco|med|perf]"
    exit 1
    ;;
esac

echo "✅ Appliqué sur $GPU_COUNT GPU(s)"
