#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
NVIDIA_OC_CMD="$SCRIPT_DIR/nvidia_oc"

case "$1" in
  eco)
    echo "🔋 Mode Éco activé (100W, sans overclock)"
    "$NVIDIA_OC_CMD" set -i 0 -p 100000
    ;;
  med)
    echo "🌿 Mode Intermédiaire activé (200W, OC modéré)-f 100 -m 500"
    "$NVIDIA_OC_CMD" set -i 0 -p 200000 -f 100 -m 500
    ;;
  perf)
    echo "🚀 Mode Performance activé (300W, OC élevé)"
    "$NVIDIA_OC_CMD" set -i 0 -p 300000 -f 200 -m 1000
    ;;
  *)
    echo "Usage : $0 [eco|med|perf]"
    exit 1
    ;;
esac
