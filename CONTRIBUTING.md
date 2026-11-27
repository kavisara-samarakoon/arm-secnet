# Contributing to ARM-SecNet

Thank you for considering contributing to ARM-SecNet.

ARM-SecNet is a defensive cybersecurity and networking lab toolkit for Apple Silicon and ARM64 learners.

## Contribution Scope

Good contributions include:

- improving setup documentation
- testing instructions on Apple Silicon
- improving ARM64 Linux compatibility notes
- fixing unclear lab steps
- adding screenshots or evidence from safe lab testing
- improving validation scripts
- improving learning outcomes and investigation questions
- correcting mistakes in documentation

## Safety Rules

Contributions must stay defensive and educational.

Do not contribute:

- malware
- credential theft code
- phishing content
- unauthorized exploitation steps
- persistence payloads
- destructive automation
- public target scanning instructions
- harmful offensive activity

## Documentation Style

Documentation should be:

- clear
- beginner-friendly
- practical
- tested where possible
- written in simple English
- focused on Apple Silicon / ARM64 compatibility when relevant

Each lab should include:

- learning outcome
- required environment
- commands
- expected observations
- investigation questions
- short findings/reporting task
- ARM64-specific note where useful

## Testing Before Commit

From the repository root, run:

```bash
git status
bash -n scripts/validate-lab.sh
bash scripts/validate-lab.sh
git diff --check
```

The validator reports the 29 historical file-presence checks and the 13
screenshot SHA-256 checks separately. It resolves paths relative to the repository
and runs with Bash 3.2 or newer on macOS and Ubuntu. It uses `sha256sum` when
available and falls back to `shasum -a 256`. Keep the historical screenshots and
manifest intact.

GitHub Actions checks committed changes on pull requests and pushes to `main`.
Pull requests compare the merge base with the event's head commit. Pushes compare
the event's before and after commits, covering the net changes across the push.
An invalid or unavailable comparison fails the check. The local `git diff --check`
above checks unstaged changes. Use `git diff --cached --check` for staged changes.

Run `bash scripts/test-validation.sh` to exercise the validator and CI comparison
script in temporary fixtures. The suite requires Git, Bash, standard shell utilities
and a supported SHA-256 utility.

These checks cover repository files, screenshot bytes and committed whitespace.
Lab 03 runtime evidence is limited to the recorded Ubuntu 26.04 LTS aarch64 VM
and SentinelLite source commit `d1775f0ca09d714f5ed9d681af90f216c1c39e8e`.
The evidence does not validate the exact SentinelLite v1.2.0-beta wheel or
establish broad ARM64 compatibility.
