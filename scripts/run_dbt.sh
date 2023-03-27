#!/bin/bash
set -e

echo "Generating dbt profile..."
export DBT_PROFILES_DIR=/usr/src/app
./scripts/generate_dbt_profile.py $DBT_PROFILES_DIR
cat $DBT_PROFILES_DIR/profiles.yml

echo "Cloning dbt project..."
git clone https://github.com/brunoabreu0/dbt_project_poc.git dbt_project
echo "Project cloned successfully."
cd dbt_project

echo "Running dbt project..."
dbt run --profiles-dir $DBT_PROFILES_DIR
echo "dbt project has run successfully."