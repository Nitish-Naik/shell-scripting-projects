#!/bin/bash
###########################################################################
#       Name:        P Nitish
#       Date:        07/11
#       Version:     v1.2
#
#       Purpose: Create a new GitHub repository (user or org)
###########################################################################

set -euo pipefail

API_URL="https://api.github.com"
USERNAME="${USERNAME:-your-username}"
TOKEN="${TOKEN:-your-token}"

# -------- INPUT ARGUMENTS ------------
OWNER="$1"             # can be user or org name
REPO_NAME="$2"
DESCRIPTION="${3:-"No description provided"}"
HOMEPAGE="${4:-"https://github.com"}"
PRIVATE="${5:-false}"
VISIBILITY="${6:-public}"

# -------- FUNCTION DEFINITIONS ------------

create_repo() {
  echo "Creating repository '${REPO_NAME}' for owner '${OWNER}'..."

  # Check if OWNER is the authenticated user
  if [[ "$OWNER" == "$USERNAME" ]]; then
    endpoint="${API_URL}/user/repos"
  else
    endpoint="${API_URL}/orgs/${OWNER}/repos"
  fi

  response=$(curl -s -w "%{http_code}" -o /tmp/resp.json \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$endpoint" \
    -d "{
      \"name\": \"${REPO_NAME}\",
      \"description\": \"${DESCRIPTION}\",
      \"homepage\": \"${HOMEPAGE}\",
      \"private\": ${PRIVATE},
      \"visibility\": \"${VISIBILITY}\",
      \"has_issues\": true,
      \"has_projects\": true,
      \"has_wiki\": true
    }")

  if [[ "$response" -eq 201 ]]; then
    echo "Repository created successfully!"
    jq '.html_url' /tmp/resp.json
  else
    echo "Failed to create repository. HTTP code: $response"
    jq . /tmp/resp.json
    exit 1
  fi
}

# -------- MAIN EXECUTION ------------
create_repo

