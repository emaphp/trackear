#!/bin/bash 
cd /home/ec2-user/app
RAILS_ENV=production bundle exec rails s -p 80 -b "0.0.0.0"