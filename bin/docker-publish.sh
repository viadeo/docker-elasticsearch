#!/bin/bash

set -x

# is docker installed ?
if [ 0 -eq  $(ps -ef | grep "docker" | grep -v "grep" | wc -l) ]; then
  echo "Docker is not started, you probably forgot to declare it in circle.yml's service section"
  exit 1;
fi

# Auth and repository creation
eval $(aws ecr get-login --region 'us-west-1')

aws ecr create-repository --repository-name "viadeo/${CIRCLE_PROJECT_REPONAME}" || true

TAG=1.7.5
URL=062010136920.dkr.ecr.us-west-1.amazonaws.com/viadeo/$CIRCLE_PROJECT_REPONAME:$TAG

echo "pushing docker to $URL"
docker push $URL
