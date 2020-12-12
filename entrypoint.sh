#!/bin/sh

cd "$GITHUB_WORKSPACE" || exit
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

EXCLUDES=""
for exclude_path in $INPUT_EXCLUDE; do
  EXCLUDES="$EXCLUDES --exclude='!$exclude_path'"
done

IGNORE_LIST=""
for rule in $INPUT_HADOLINT_IGNORE; do
  IGNORE_LIST="$IGNORE_LIST --ignore $rule"
done

INPUT_HADOLINT_FLAGS="$INPUT_HADOLINT_FLAGS $IGNORE_LIST"

git ls-files --exclude='*Dockerfile*' --ignored "${EXCLUDES}" \
  | xargs hadolint "${INPUT_HADOLINT_FLAGS}" \
  | reviewdog -efm="%f:%l %m" \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    "${INPUT_REVIEWDOG_FLAGS}"
