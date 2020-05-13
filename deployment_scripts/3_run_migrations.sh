#!/bin/bash 
cd /home/ec2-user/app
RAILS_ENV=production bundle exec rake db:migrate