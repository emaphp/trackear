#!/bin/bash

echo ""
echo "> Running: docker-compose run --rm app bundle exec rails $@"
echo ""

docker-compose run --rm app bundle exec rails "$@"
