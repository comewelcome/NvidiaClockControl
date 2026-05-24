#!/bin/bash

case "$1" in
  eco)
    echo "🔋 Mode Éco activé (fréquence verrouillée à 210 MHz)"
    sudo nvidia-smi -pm 1
    sudo nvidia-smi -lgc 210,210
    ;;
  med)
    echo "🌿 Mode Intermédiaire activé (fréquence limitée pour conso max ~150W)"
    sudo nvidia-smi -pm 1
    sudo nvidia-smi -lgc 1000,1200
    ;;
  perf)
    echo "🚀 Mode Performance restauré"
    sudo nvidia-smi -rgc
    ;;
  *)
    echo "Usage : $0 [eco|med|perf]"
    ;;
esac
