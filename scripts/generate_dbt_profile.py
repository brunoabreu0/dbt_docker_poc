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

    profile_name = 'dbt_project_poc'
    env_name = 'dev'
    profile_yaml = {
        profile_name: {
            'target': env_name,
            'outputs': {
                env_name: {
                    'type': 'snowflake',
                    'account': '',
                    'user': '',
                    'password': get_secret(''),
                    'role': ''.upper(),
                    'warehouse': '',
                    'database': '',
                    'schema': '',
                    'threads': '',
                }
            }
        }
    }
    with open(profiles_file_path, 'w') as profiles_file_handle:
        yaml.dump(profile_yaml, profiles_file_handle)


if __name__ == '__main__':
    generate_dbt_profile()
