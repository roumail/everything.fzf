#!/usr/bin/env bash

resolve_repo() {
  local query="$*"

  # Try to extract --repo <value>
  local repo_flag
  repo_flag=$(echo "$query" | awk '
    {
      for (i = 1; i <= NF; i++) {
        if ($i == "--repo") {
          print $(i+1)
          exit
        }
      }
    }
  ')

  if [[ -n "$repo_flag" ]]; then
    echo "$repo_flag"
    return
  fi

  # Fallback to git remote
  local local_repo
  local_repo=$(git remote -v 2>/dev/null | awk '/fetch/ {print $2}' \
    | sed -E 's/.*[:\/](.*\/.*)\.git$/\1/; s/.*github\.com\///' \
    | head -n1)

  if [[ -n "$local_repo" ]]; then
    echo "$local_repo"
    return
  fi

  echo "Error: Could not determine repository. Use --repo <owner/name>" >&2
  return 1
}
