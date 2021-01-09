#!/bin/sh

# shellcheck disable=SC2086,SC2089,SC2090

cd "${GITHUB_WORKSPACE}" || exit

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

echo '::group:: Installing hadolint ... https://github.com/hadolint/hadolint'
wget -q https://github.com/hadolint/hadolint/releases/download/$HADOLINT_VERSION/hadolint-Linux-x86_64 -O $TEMP_PATH/hadolint \
    && chmod +x $TEMP_PATH/hadolint
echo '::endgroup::'

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

echo '::group:: Running hadolint with reviewdog 🐶 ...'
git ls-files --exclude='*Dockerfile*' --ignored ${EXCLUDES} \
  | xargs hadolint ${INPUT_HADOLINT_FLAGS} \
  | reviewdog -efm="%f:%l %m" \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS}
echo '::endgroup::'
