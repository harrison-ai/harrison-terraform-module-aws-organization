FROM debian:bullseye-slim as builder

RUN apt-get update \
  && apt-get install \
  ca-certificates \
  curl \
  jq \
  unzip \
  wget \
  --no-install-recommends -y

RUN TERRAFORM=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version) \
    && wget --no-verbose --tries=5 --timeout=5 \
    "https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip" -O /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /tmp && \
    chmod +x /tmp/terraform

FROM python:3-slim-bullseye

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install \
  git \
  graphviz \
  --no-install-recommends -y

RUN pip install boto3 diagrams pyyaml

COPY --from=builder /tmp/terraform /usr/local/bin/terraform

WORKDIR /app

ENTRYPOINT ["terraform"]
