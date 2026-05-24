#!/bin/bash

# This script automates the installation and enablement of the gpu-mode-med.service

echo "Copying gpu-mode-med.service to /etc/systemd/system/"
sudo cp /home/yo/Desktop/code/nvidia/gpu-mode-med.service /etc/systemd/system/gpu-mode-med.service

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling gpu-mode-med.service..."
sudo systemctl enable gpu-mode-med.service

echo "Starting gpu-mode-med.service..."
sudo systemctl start gpu-mode-med.service

echo "Checking status of gpu-mode-med.service..."
systemctl status gpu-mode-med.service

echo "Installation and enablement complete."