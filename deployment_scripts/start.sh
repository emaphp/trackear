#!/bin/bash
rm -f tmp/pids/server.pid
RAILS_ENV=production bundle exec rails s -p 80 -b "0.0.0.0"
