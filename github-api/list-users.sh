#!/bin/bash
#
############################################################################################
#	Author: P Nitish								   
#	Date: 07 Nov									   
#	Version: v1									   
#											   
#	This script is to list the number of users having permission to a repository.
##########################################################################################

set -x

API_URL="https://api.github.com"

# Github username and personal access token (must be exported before running)
USERNAME=$USERNAME
TOKEN=$TOKEN

# User and repository information
REPO_OWNER=$1
REPO_NAME=$2

# --- Function to make a GET request to the GitHub API ---
function get_github_api {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# --- Function to list users with read access to the repository ---
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators
    collaborators="$(get_github_api "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login' 2>/dev/null)"

    # Handle error messages from GitHub API (e.g. "Not Found", "Must have push access")
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}"
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# --- Main Script ---
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}"
list_users_with_read_access

