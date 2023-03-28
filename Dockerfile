FROM public.ecr.aws/bitnami/git:latest
LABEL Maintainer="RedCloud DataOps"

ARG DBT_PROJECT_GIT_REPOSITORY
ENV DBT_PROJECT_GIT_REPOSITORY=$DBT_PROJECT_GIT_REPOSITORY

ARG DBT_PROFILE_NAME
ENV DBT_PROFILE_NAME=$DBT_PROFILE_NAME

ARG DBT_TARGET_NAME
ENV DBT_TARGET_NAME=$DBT_TARGET_NAME

ARG DBT_ACCOUNT
ENV DBT_ACCOUNT=$DBT_ACCOUNT

ARG DBT_USER
ENV DBT_USER=$DBT_USER

ARG DBT_PASSWORD_SECRET_ID
ENV DBT_PASSWORD_SECRET_ID=$DBT_PASSWORD_SECRET_ID

ARG DBT_ROLE
ENV DBT_ROLE=$DBT_ROLE

ARG DBT_WAREHOUSE
ENV DBT_WAREHOUSE=$DBT_WAREHOUSE

ARG DBT_DATABASE
ENV DBT_DATABASE=$DBT_DATABASE

ARG DBT_SCHEMA
ENV DBT_SCHEMA=$DBT_SCHEMA

ARG DBT_THREADS
ENV DBT_THREADS=$DBT_THREADS

ENV INSTALL_PATH /usr/src/app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN  apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN install_packages python3.9-minimal python3-pip awscli
COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .
RUN chmod -R 755 scripts/

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["scripts/run_dbt.sh"]
