#!/usr/bin/python3
import boto3
import os
import sys
import yaml
from pathlib import Path


def get_secret(secret_key_alias: str) -> str:
    return boto3.session.Session().client(service_name='secretsmanager') \
        .get_secret_value(SecretId=secret_key_alias)['SecretString']


def generate_dbt_profile():
    profiles_file_name = 'profiles.yml'
    profiles_dir = Path(sys.argv[1])
    profiles_file_path = os.path.join(profiles_dir, profiles_file_name)

    profile_name = os.environ['DBT_PROFILE_NAME']
    target_name = os.environ['DBT_TARGET_NAME']
    profile_yaml = {
        profile_name: {
            'target': target_name,
            'outputs': {
                target_name: {
                    'type': 'snowflake',
                    'account': os.environ['DBT_ACCOUNT'],
                    'user': os.environ['DBT_USER'],
                    'password': get_secret(os.environ['DBT_PASSWORD_SECRET_ID']),
                    'role': os.environ['DBT_ROLE'],
                    'warehouse': os.environ['DBT_WAREHOUSE'],
                    'database': os.environ['DBT_DATABASE'],
                    'schema': os.environ['DBT_SCHEMA'],
                    'threads': int(os.environ['DBT_THREADS']),
                }
            }
        }
    }
    with open(profiles_file_path, 'w') as profiles_file_handle:
        yaml.dump(profile_yaml, profiles_file_handle)


if __name__ == '__main__':
    generate_dbt_profile()
