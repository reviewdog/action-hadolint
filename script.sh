#!/bin/sh

# shellcheck disable=SC2086,SC2089,SC2090

cd "${GITHUB_WORKSPACE}" || exit

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

echo '::group:: Installing hadolint ... https://github.com/hadolint/hadolint'
HADOLINT_FILE="hadolint-Linux-x86_64"

if [ "$RUNNER_ARCH" = "ARM64" ]; then
  HADOLINT_FILE="hadolint-Linux-arm64"
fi

wget -q "https://github.com/hadolint/hadolint/releases/download/$HADOLINT_VERSION/$HADOLINT_FILE" -O $TEMP_PATH/hadolint \
    && chmod +x $TEMP_PATH/hadolint
echo '::endgroup::'

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

EXCLUDES=""
for exclude_path in $INPUT_EXCLUDE; do
  set -- --exclude="!${exclude_path}"
  EXCLUDES="$EXCLUDES $*"
done

INCLUDES=""
for include_path in $INPUT_INCLUDE; do
  set -- --exclude="${include_path}"
  INCLUDES="$INCLUDES $*"
done

IGNORE_LIST=""
for rule in $INPUT_HADOLINT_IGNORE; do
  IGNORE_LIST="$IGNORE_LIST --ignore $rule"
done

INPUT_HADOLINT_FLAGS="$INPUT_HADOLINT_FLAGS $IGNORE_LIST"

echo '::group:: Running hadolint with reviewdog 🐶 ...'
git ls-files ${INCLUDES} --ignored --cached ${EXCLUDES} \
  | xargs hadolint -f json ${INPUT_HADOLINT_FLAGS} \
  | jq -f "${GITHUB_ACTION_PATH}/to-rdjson.jq" -c \
  | reviewdog -f="rdjson" \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-level="${INPUT_FAIL_LEVEL}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS}
EXIT_CODE=$?
echo '::endgroup::'

exit $EXIT_CODE
