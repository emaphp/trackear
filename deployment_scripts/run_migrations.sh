#!/bin/bash

echo "---------------------------------------------------------------------"
echo "Running migrations..."
RAILS_ENV=production bundle exec rake db:migrate
echo "Migrations done"
echo "---------------------------------------------------------------------"
