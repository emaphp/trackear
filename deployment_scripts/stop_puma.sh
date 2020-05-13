#!/bin/bash 
cd /home/ec2-user/app
kill $(cat tmp/pids/server.pid)