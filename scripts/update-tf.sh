#!/bin/bash

set -euo pipefail

LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version )

echo ${LATEST} > .tf_version

echo "Wrote ${LATEST} to .tf_version"
