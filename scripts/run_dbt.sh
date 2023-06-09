#!/bin/bash
set -e

echo "Testing connectivity..."
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
  echo "Online"
else
  echo "Offline"
fi

echo "Generating dbt profile..."
export DBT_PROFILES_DIR=/usr/src/app
./scripts/generate_dbt_profile.py $DBT_PROFILES_DIR

echo "Cloning dbt project..."
git clone "$DBT_PROJECT_GIT_REPOSITORY" dbt_project
echo "Project nas been successfully cloned."
cd dbt_project

echo "Installing dbt dependency packages..."
dbt deps
echo "dbt project dependency packages has been successfully installed."

echo "Running dbt command: '$DBT_COMMAND'"
dbt $DBT_COMMAND --profiles-dir $DBT_PROFILES_DIR
echo "dbt project has successfully run."
