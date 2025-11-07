#!/bin/bash
##########################################################################################################
#       Name:           P Nitish
#       Date:           07/11
#       Version:        v1.4
#
#       Purpose: Delete a GitHub repository (user or organization)
##########################################################################################################

set -euo pipefail

API_URL="https://api.github.com"
USERNAME="${USERNAME:-your-username}"
TOKEN="${TOKEN:-your-token}"

# ----------------- INPUT ARGUMENTS ----------------------
OWNER="$1"
REPO_NAME="$2"

# ---------------- FUNCTIONS ------------------
delete_repo() {
    echo "Deleting repository '${REPO_NAME}' for owner '${OWNER}'..."

    endpoint="${API_URL}/repos/${OWNER}/${REPO_NAME}"

    response=$(curl -s -w "%{http_code}" -o /tmp/resp.json \
        -X DELETE \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$endpoint")

    if [[ "$response" -eq 204 ]]; then
        echo "Repository deleted successfully!"
    else
        echo "Failed to delete repository. HTTP Code: $response"
        jq . /tmp/resp.json || cat /tmp/resp.json
        exit 1
    fi
}

# ------------------ MAIN EXECUTION ----------------------
delete_repo

