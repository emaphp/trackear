#!/bin/bash 
cd /home/ec2-user/app
NODE_ENV=production RAILS_ENV=production bundle exec rake assets:precompile