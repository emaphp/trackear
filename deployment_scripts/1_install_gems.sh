#!/bin/bash 
cd /home/ec2-user/app
RAILS_ENV=production bundle install --without development test --deployment --quiet