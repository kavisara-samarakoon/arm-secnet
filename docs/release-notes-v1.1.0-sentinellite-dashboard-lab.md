# ARM-SecNet V1.1.0 SentinelLite Dashboard Lab

Status: **published release** (not a draft or pre-release), listed as Latest at publication.

- Release: [ARM-SecNet V1.1.0 SentinelLite Dashboard Lab](https://github.com/kavisara-samarakoon/arm-secnet/releases/tag/v1.1.0-sentinellite-dashboard-lab)
- Published at: `2026-09-13T06:16:54Z`
- Release tag: `v1.1.0-sentinellite-dashboard-lab`
- Annotated tag object: `9d767ffc76cda88d07d20c78d1dac9ce9bc3e7dc`
- Tag target commit: `329f5e66d7986d68b547aa267f73976417c0c0f3` — merge of PR #3,
  `feature/v1.1-final-polish`, into `main`.

The V1.0 documentation MVP, tag, history, and existing screenshot evidence remain unchanged.

## Release Scope

- Three documented labs: Linux baseline investigation, authentication log analysis, and
  the optional SentinelLite AI local CLI and static dashboard workflow.
- [Lab 03 runtime evidence](evidence/v1.1-sentinellite-dashboard.md) recorded on one Ubuntu
  26.04 LTS aarch64 VM using SentinelLite source commit
  `d1775f0ca09d714f5ed9d681af90f216c1c39e8e`, before v1.2.0-beta publication. The recorded
  CLI version was `SentinelLite AI v1.1.0-beta`; that source already included the exporter.
- Recorded results: doctor reported 10 passed, 0 warnings, 0 failed; demo produced three
  synthetic events and three alerts; dashboard export created `reports/dashboard.html`.
- 29 documentation/evidence checks: 29 passed, 0 warnings, 0 failures after the evidence
  merge. These checks verify file presence and do not execute SentinelLite.
- [GitHub Actions validation](../.github/workflows/validate.yml) added for pull requests and
  pushes to `main`, running the validation script and `git diff --check` on `ubuntu-latest`.
  The workflow does not install SentinelLite or run ARM64 VM tests.
- [SentinelLite AI v1.2.0-beta](https://github.com/kavisara-samarakoon/sentinellite-ai/releases/tag/v1.2.0-beta)
  is the recommended published dashboard release for new runs. This GitHub pre-release
  includes `doctor`, `demo`, and `dashboard export`. Lab 03 documents both a published-wheel
  installation and source installation at the release tag.

## Validation

GitHub Actions **ARM-SecNet Validation** passed on
[PR #3](https://github.com/kavisara-samarakoon/arm-secnet/pull/3).
Local validation after publication also passed: `bash scripts/validate-lab.sh` reported
**29 passed, 0 warnings, 0 failures**, and `git diff --check` passed.
These are documentation/evidence file-presence and whitespace checks; they do not perform
a new SentinelLite runtime or ARM64 VM validation run.

## Evidence and Safety Limits

The existing screenshots validate only the recorded VM and source commit. They do not
validate the exact v1.2.0-beta release wheel. A new exact-release run must record separate
provenance and evidence before claiming that validation.

ARM-SecNet and SentinelLite remain separate repositories with no runtime dependency.
The optional demo uses synthetic data; the dashboard reads stored local JSON reports and
writes static HTML. It provides no server, network requests, or live monitoring.

This work makes no universal ARM64 compatibility or production security-protection claim.
It does not claim production EDR, antivirus, SIEM/SOC capability, real AI/LLM execution,
malware detection or removal, public scanning, or automatic remediation.
