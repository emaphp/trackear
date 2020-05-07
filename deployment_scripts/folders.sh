#!/bin/bash 

# Remove if previous deployment folder exists
rm -rf /var/www/dashboard-prod-prev

# Backup current deployment 
mv /var/www/dashboard-prod /var/www/dashboard-prod-prev

# Create new deployment folder and make nginx owner
mkdir /var/www/dashboard-prod

chown nginx:nginx /var/www/dashboard-prod