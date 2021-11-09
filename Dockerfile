FROM python:3-slim-bullseye

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install \
  graphviz \
  --no-install-recommends -y

RUN pip install boto3 diagrams pyyaml

WORKDIR /app
