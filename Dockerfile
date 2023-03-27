FROM public.ecr.aws/bitnami/git:latest
LABEL Maintainer="RedCloud DataOps"

ARG PROJECT_NAME
ENV PROJECT_NAME=$PROJECT_NAME

ENV ENV=dev
ENV INSTALL_PATH /usr/src/app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN install_packages python3.9-minimal python3-pip awscli
COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .
RUN chmod -R 755 scripts/

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["scripts/run_dbt.sh"]
