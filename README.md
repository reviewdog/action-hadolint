# GitHub Action: Run hadolint with reviewdog 🐶

[![](https://img.shields.io/github/license/reviewdog/action-hadolint)](./LICENSE)
[![depup](https://github.com/reviewdog/action-hadolint/workflows/depup/badge.svg)](https://github.com/reviewdog/action-hadolint/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-hadolint/workflows/release/badge.svg)](https://github.com/reviewdog/action-hadolint/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-hadolint?logo=github&sort=semver)](https://github.com/reviewdog/action-hadolint/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

This action runs [hadolint](https://github.com/hadolint/hadolint) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to lint Dockerfile 
and validate inline bash.

## Examples

### With `github-pr-check`

By default, with `reporter: github-pr-check` an annotation is added to the line:

![Example comment made by the action, with github-pr-check](./examples/example-github-pr-check.png)

### With `github-pr-review`

With `reporter: github-pr-review` a comment is added to the Pull Request Conversation:

![Example comment made by the action, with github-pr-review](examples/example-github-pr-review.png)

## Inputs

### `github_token`

Optional. `${{ github.token }}` is used by default.

### `hadolint_flags`

Optional. Pass hadolint flags:
```
with:
  hadolint_flags: --trusted-registry docker.io
```

### `hadolint_ignore`

Optional. Pass hadolint rules to ignore them:
```
with:
  hadolint_ignore: DL3009 DL3008
```

### `tool_name`

Optional. Tool name to use for reviewdog reporter. Useful when running multiple
actions with different config.

### `exclude`

Optional. List of folders and files to exclude from checking.

Use `/%FOLDER%/*` to exclude whole folder or `%FILENAME%` to exclude certain files. 

Note that you can use wildcard to exclude certain file extensions, like `Dockerfile.*` will exclude `Dockerfile.dev`, but will not exclude `Dockerfile`.

You can combine those rules as you wish (i.e. exclude certain files from certain folders only):
```yaml
with:
  exclude: |
    /vendor/*
    Dockerfile.*
```

### `include`

Optional. Defaults to `*Dockerfile*`. List of folders and files to use for checking.

Use `/%FOLDER%/*` to include whole folder or `%FILENAME%` to include certain files.

Note that you can use wildcard to include certain file extensions, like `Dockerfile.*` will include `Dockerfile.dev`, but will not include `Dockerfile`.

You can combine those rules as you wish (i.e. exclude certain files from certain folders only):
```yaml
with:
  include: |
    subfolder/Dockerfile.*
```

### `level`

Optional. Report level for reviewdog [`info`, `warning`, `error`].
It's same as `-level` flag of reviewdog.

### `reporter`

Optional. Reporter of reviewdog command [`github-pr-check`, `github-pr-review`].
The default is `github-pr-check`.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [`added`, `diff_context`, `file`, `nofilter`].
Default is `added`.

### `fail_level`

Optional. If set to `none`, always use exit code 0 for reviewdog. Otherwise, exit code 1 for reviewdog if it finds at least 1 issue with severity greater than or equal to the given level.
Possible values: [`none`, `any`, `info`, `warning`, `error`]
Default is `none`.

### `fail_on_error`

Deprecated, use `fail_level` instead.
Optional.  Exit code for reviewdog when errors are found [`true`, `false`]
Default is `false`.

### `reviewdog_flags`

Optional. Additional reviewdog flags.

## Example usage

```yml
name: reviewdog
on: [pull_request]
jobs:
  hadolint:
    name: runner / hadolint
    runs-on: ubuntu-latest
    steps:
      - name: Check out code
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - name: hadolint
        uses: reviewdog/action-hadolint@fc7ee4a9f71e521bc43e370819247b70e5327540 # v1.50.2
        with:
          reporter: github-pr-review # Default is github-pr-check
```

## Sponsor

<p>
  <a href="https://evrone.com/?utm_source=action-hadolint">
    <img src="https://www.mgrachev.com/assets/static/evrone-sponsored-300.png" 
      alt="Sponsored by Evrone" width="210">
  </a>
</p>

## License

[MIT](https://choosealicense.com/licenses/mit)
