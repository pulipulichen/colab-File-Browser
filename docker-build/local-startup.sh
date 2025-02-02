#!/bin/bash

# Get the directory path of the script
script_dir=$(dirname "$0")

# Change the current working directory to the script's location
cd "$script_dir"

cd ../app-build

docker-compose down
docker-compose up --build