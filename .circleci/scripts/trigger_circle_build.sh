#!/usr/bin/env bash

set -euo pipefail

# branch and tag are mutually exclusive
TRIGGER_BRANCH="\"branch\": \"${CIRCLE_BRANCH}\""
if [[ -n "${CIRCLE_TAG:-}" ]]; then
    TRIGGER_BRANCH="\"tag\": \"${CIRCLE_TAG}\""
fi

cat > body.json <<-EOF
{
    ${TRIGGER_BRANCH},
    "parameters": {
        "run_build_workflow": true,
        "run_docker_workflow": false,
        "ci_docker_tag": "${DOCKER_TAG}"
    }
}
EOF

# Docs on this particular endpoint:
# https://circleci.com/docs/api/v2/?shell#trigger-a-new-pipeline
(
    set -x
    curl \
        -f \
        -u "${CIRCLECI_TOKEN}:" \
        -X POST \
        --header "Content-Type: application/json" \
        -d "@body.json" \
        "https://circleci.com/api/v2/project/github/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/pipeline"
)
