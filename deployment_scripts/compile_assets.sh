#!/bin/bash

echo "---------------------------------------------------------------------"
echo "Building assets"
NODE_ENV=production RAILS_ENV=production bundle exec rake assets:precompile
echo "Assets done"
echo "---------------------------------------------------------------------"
