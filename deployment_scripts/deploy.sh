#!/bin/bash

echo "---------------------------------------------------------------------"
echo "Deploying..."
bash ./deployment_scripts/run_migrations.sh
bash ./deployment_scripts/compile_assets.sh
bash ./deployment_scripts/start.sh
