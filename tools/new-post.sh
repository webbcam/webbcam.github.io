#!/usr/bin/env bash
#
# Create a new draft post with pre-filled front matter.
#
# Usage:
#   bash tools/new-post.sh "Post Title" [options]
#
# Options:
#   -c, --categories "Cat1,Cat2"   Up to 2 categories (comma-separated)
#   -t, --tags       "tag1,tag2"   Tags (comma-separated, lowercase)
#   -s, --series     "Series Name" Series name (optional)

set -euo pipefail

usage() {
  echo "Usage: $0 \"Post Title\" [-c \"Cat1,Cat2\"] [-t \"tag1,tag2\"] [-s \"Series Name\"]"
  exit 1
}

[[ $# -eq 0 ]] && usage

TITLE="$1"
shift

CATEGORIES=""
TAGS=""
SERIES=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--categories) CATEGORIES="$2"; shift 2 ;;
    -t|--tags)       TAGS="$2";       shift 2 ;;
    -s|--series)     SERIES="$2";     shift 2 ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

# Slugify: lowercase, replace non-alphanumeric with hyphens, collapse/strip surrounding hyphens
SLUG=$(echo "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9]/-/g' \
  | sed 's/--*/-/g' \
  | sed 's/^-//;s/-$//')

DATE=$(date +"%Y-%m-%d")
DATETIME=$(date +"%Y-%m-%d %H:%M:%S %z")
FILENAME="_posts/${DATE}-${SLUG}.md"

if [[ -f "$FILENAME" ]]; then
  echo "Error: $FILENAME already exists."
  exit 1
fi

mkdir -p _posts

# Normalise comma-separated values to "val1, val2" format
fmt_list() {
  echo "$1" | sed 's/,/, /g' | sed 's/  */ /g'
}

{
  echo "---"
  echo "title: ${TITLE}"
  echo "date: ${DATETIME}"

  if [[ -n "$CATEGORIES" ]]; then
    echo "categories: [$(fmt_list "$CATEGORIES")]"
  else
    echo "categories: []"
  fi

  if [[ -n "$TAGS" ]]; then
    echo "tags: [$(fmt_list "$TAGS")]"
  else
    echo "tags: []"
  fi

  if [[ -n "$SERIES" ]]; then
    echo "series: \"${SERIES}\""
  fi

  echo "---"
  echo ""
} > "$FILENAME"

echo "Created: $FILENAME"
