# Convert hadlint JSON output to Reviewdog Diagnostic Format (rdjson)
# https://github.com/reviewdog/reviewdog/blob/f577bd4b56e5973796eb375b4205e89bce214bd9/proto/rdf/reviewdog.proto
{
  source: {
    name: "hadolint",
    url: "https://github.com/hadolint/hadolint"
  },
  diagnostics: . | map({
    message: .message,
    code: {
      value: .code,
      url: (if .code | startswith("DL") then
              "https://github.com/hadolint/hadolint/wiki/\(.code)"
            elif .code | startswith("SC") then
              "https://github.com/koalaman/shellcheck/wiki/\(.code)"
            else
              null
            end),
    } ,
    location: {
      path: .file,
      range: {
        start: {
          line: .line,
          column: .column
        }
      }
    },
    severity: ((.level|ascii_upcase|select(match("ERROR|WARNING|INFO")))//null)
  })
}
