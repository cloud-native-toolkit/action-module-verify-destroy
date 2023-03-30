#! /bin/bash

PARALELLISM=10
if [[ "$REPO_NAME" == *"gitops"* ]]; then
  PARALELLISM=3
  echo "GitOps repo detected, using \"terraform -parallelism=$PARALELLISM\""
fi

echo "Destroying resources"
terraform apply -parallelism=$PARALELLISM -destroy -auto-approve -input=false
