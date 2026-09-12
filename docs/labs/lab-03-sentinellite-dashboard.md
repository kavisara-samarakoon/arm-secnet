# Lab 03 — SentinelLite AI Local CLI and Static Dashboard

## 1. Purpose

This ARM-SecNet V1.1 documentation addition describes an optional SentinelLite AI demo
inside the Ubuntu ARM64 lab VM. ARM-SecNet provides the Apple Silicon / UTM / ARM64 lab
environment. SentinelLite AI provides the optional local defensive observation,
report-review, and dashboard CLI. They remain separate repositories with no runtime
dependency between them.

ARM-SecNet V1.0 remains the documentation MVP with two tested labs. This guide does not
claim an ARM-SecNet V1.1 release is published.
Runtime evidence for one Ubuntu ARM64 VM run is recorded in
[docs/evidence/v1.1-sentinellite-dashboard.md](../evidence/v1.1-sentinellite-dashboard.md).
That result applies only to the recorded VM and source commit, not all ARM64 environments.

SentinelLite AI `v1.1.0-beta` is the current published
[GitHub pre-release](https://github.com/kavisara-samarakoon/sentinellite-ai/releases/tag/v1.1.0-beta).
Its wheel includes `doctor` and `demo`, but **does not include `dashboard export`**.
The dashboard exporter was merged into SentinelLite `main` after that release. Use source
from `main` for this lab. This guide does not claim a SentinelLite v1.2 release exists.

## 2. Safety Scope

- Work only inside your local, authorized Ubuntu ARM64 lab VM using UTM Shared/NAT.
- Use a normal user account. Do not run SentinelLite with root privileges for this lab.
- `doctor` checks local installation readiness; it does not assess endpoint security.
- `demo` processes bundled synthetic fixture data only. It does not read real logs,
  observe processes, network connections or files, or send network traffic.
- `dashboard export` reads existing local JSON reports only and writes a static HTML
  snapshot. It does not modify the source reports, start a server, open a browser,
  make network requests, or provide live monitoring. The HTML uses embedded CSS, with
  no external scripts, styles, fonts, tracking or other resources. Report-derived text
  is escaped and raw evidence is omitted.
- This workflow performs no endpoint observation, scanning, exploitation, firewall
  changes, process killing, or automatic remediation. Do not substitute observation
  commands or real host logs for the synthetic demo.
- Neither this lab nor its dashboard provides production monitoring, EDR, antivirus,
  a SIEM, a SOC platform, a malware remover, or enterprise security protection.
  Explanations are deterministic local templates, not real AI/LLM execution.

Source downloads and package installation need network access. The SentinelLite demo and
dashboard workflow itself does not send network traffic. Follow the existing
[ARM-SecNet safety rules](../safety.md).

## 3. Prerequisites

- Apple Silicon Mac with UTM
- An authorized Ubuntu ARM64 VM prepared using the
  [VM setup guide](../setup/arm64-linux-vm-setup.md)
- Python 3.11 or newer, Python virtual-environment support, and Git inside the VM
- A writable home directory and temporary directory
- Network access for downloading trusted source and Python dependencies
- A graphical browser for manually viewing local HTML, if a dashboard screenshot is needed

Run inside the Ubuntu VM terminal:

```bash
uname -m
python3 --version
git --version
```

Expect `aarch64` and Python 3.11 or newer. Correct the VM architecture or Python setup
before proceeding if those requirements are not met. Architecture output alone is not
proof of successful application validation.

## 4. Install SentinelLite from GitHub Source

Create a separate checkout outside the ARM-SecNet repository:

```bash
mkdir -p "$HOME/lab-tools"
cd "$HOME/lab-tools"
git clone https://github.com/kavisara-samarakoon/sentinellite-ai.git
cd sentinellite-ai
git switch main
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -e .
python -m pip check
```

If that checkout already exists, review its local changes before updating it; do not
overwrite it or reset someone else's work. Use a fresh separate checkout if needed.
SentinelLite AI is not published to PyPI. `pip install -e .` installs the trusted local
source and its Python dependencies; it does not install ARM-SecNet as a dependency.

Record which source you installed and verify the command is available:

```bash
git branch --show-current
git rev-parse HEAD
sentinellite --version
sentinellite dashboard export --help
```

The branch should be `main`; keep the printed commit hash with your evidence. The CLI
version may still show `SentinelLite AI v1.1.0-beta` on this development source. The version
string alone cannot distinguish it from the published wheel. The source commit and
`dashboard export --help` output establish dashboard availability for this run.

Keep this virtual environment active in the same terminal for the remaining steps.

## 5. Run the Safe CLI and Dashboard Demo

Create a fresh output directory so existing reports cannot enter the demonstration:

```bash
lab_output="$(mktemp -d /tmp/arm-secnet-sentinellite.XXXXXX)"
cd "$lab_output"
printf 'Lab output directory: %s\n' "$lab_output"
```

Keep the printed path. The following commands use default paths relative to this directory:

```bash
sentinellite doctor
sentinellite demo
sentinellite dashboard export
```

`doctor` reports versions, platform, architecture, default configuration, dependency
imports, and report-directory write access. Its temporary write probe is removed after
the check. Review every PASS/WARNING/FAIL result; a failure means the installation needs
attention, not that the VM is compromised. Exit code 0 allows passes or warnings, while
failures return code 1.

`demo` should report three synthetic authentication events and three example alerts with
the current source, then print the saved JSON path and report-review commands. These
records describe fixture activity, not real events observed on the VM.

`dashboard export` reads the existing JSON files in `reports` and writes
`reports/dashboard.html`. It does not collect events, rescan the host, or regenerate alert
explanations. By default it displays at most 25 reports and 25 combined alerts, sorted
newest first when timestamps are available. Invalid reports are skipped. The fresh demo
directory should contain one valid report with three alerts.

The explicit equivalent is:

```bash
sentinellite dashboard export --reports-dir reports --output reports/dashboard.html --limit 25
```

Review the same saved report in the terminal:

```bash
sentinellite reports list
sentinellite reports show "<REPORT_PATH>"
```

Replace `<REPORT_PATH>` with the actual JSON path printed by `demo`. Do not pass the HTML
file to `reports show`; that command reviews JSON reports.

## 6. View the Static HTML Manually

Print the full dashboard path:

```bash
printf '%s\n' "$lab_output/reports/dashboard.html"
```

Use the VM browser's **Open File** action to open that HTML file manually. No local web
server, port forwarding, or browser launch command is needed. The page should show:

- Title: **SentinelLite AI Local Dashboard**
- Banner: **Local static report viewer. No live monitoring, no network activity, no automatic remediation.**
- One loaded report and three displayed synthetic alerts for a fresh run
- Highest displayed severity, latest report time, and severity/rule/module counts
- A latest-alerts table and the saved-report list
- Footer: **Generated from local SentinelLite AI JSON reports.**

The dashboard is a snapshot. It does not refresh itself; exporting again creates a new
snapshot from stored reports. Alert counts and breakdowns describe the displayed selection;
the loaded-report count includes all compatible reports in the selected directory.

On an Ubuntu Server VM without a graphical browser, retain the CLI evidence. If an
authorized local shared folder is already configured, you may copy only the synthetic
`dashboard.html` there and open it manually on the Mac. Record that screenshot as a host
view of VM-generated output; it does not demonstrate browser rendering inside the VM.
Do not start a server or expose the VM to obtain a screenshot.

## 7. Evidence Checklist

- [ ] Record date, VM OS, architecture, Python version, and UTM Shared/NAT setup.
- [ ] Record the ARM-SecNet branch/commit and the separate SentinelLite `main` commit.
- [ ] Capture `sentinellite --version` and `dashboard export --help` output.
- [ ] Capture `doctor` results, including any warnings or failures.
- [ ] Capture `demo` output and identify the report as synthetic.
- [ ] Capture `reports list` and `reports show` for that generated JSON report.
- [ ] Capture dashboard export success and the local HTML view, noting the viewing host.
- [ ] Record command outcomes and any limitations; do not mark skipped steps as passed.
- [ ] Review evidence before sharing and redact personal paths or host identifiers.

Use the [V1.1 runtime evidence record](../evidence/v1.1-sentinellite-dashboard.md) as a
reference when recording results for additional runs.
Run `git branch --show-current` and `git rev-parse HEAD` from each repository's own checkout
when recording its provenance.
Do not copy real host reports into either repository.

## 8. Expected Screenshots

For a repeat run, capture eight images: VM prerequisites; SentinelLite source/command
availability; doctor; synthetic demo; JSON report review; dashboard export in the terminal;
browser summary; and browser alerts/report table. The evidence record links all eight
screenshots from the recorded run. Existing V1.0 screenshots remain separate from Lab 03.

## 9. Troubleshooting

| Symptom | Action |
|---|---|
| Architecture is not `aarch64` | Check that these commands are running inside the Ubuntu ARM64 VM. |
| Python is older than 3.11, or `venv` is unavailable | Complete Python and virtual-environment prerequisites using the VM's normal setup process, then recreate the lab environment. |
| `dashboard` is an unknown command | Confirm the active environment uses a source checkout from SentinelLite `main`. The published v1.1.0-beta wheel lacks this command. Check the source commit and rerun `python -m pip install -e .` from that checkout. |
| `sentinellite` is not found | Reactivate `$HOME/lab-tools/sentinellite-ai/.venv/bin/activate` in the current shell. |
| Doctor reports an import failure | Run `python -m pip check` in the active environment and repair the source installation. Typer and Rich must be installed for the CLI to start at all. |
| Doctor or export reports a write error | Use a fresh writable lab output directory. Do not use root privileges or change host file permissions to force the demo. |
| Dashboard says no reports were found | Check `pwd` and `sentinellite reports list`; run the synthetic demo from the same isolated output directory before exporting. |
| Export reports skipped files | Review the selected report directory. A fresh synthetic demo avoids unrelated, incompatible or malformed JSON. Do not edit real reports to make them load. |
| Dashboard does not change | It is static HTML. Export again after creating a new synthetic report, then reopen or reload the local file manually. |
| No VM graphical browser | Use the documented local shared-folder option or record the browser step as not performed. |
| `lab_output` is unset after reopening the terminal | Use the exact temporary path recorded earlier; do not guess a path for cleanup. Reactivate the source environment before running more commands. |

## 10. Cleanup Commands

After saving any intended evidence, review and remove only the generated demo output.
Run this in the original VM terminal where `lab_output` was set. Each `rm -i` prompts
before deleting a file; `rmdir` removes only empty directories. This does not remove the
SentinelLite checkout, its virtual environment, or ARM-SecNet files.

```bash
cd "$HOME"
case "${lab_output:-}" in
  /tmp/arm-secnet-sentinellite.??????)
    printf 'Reviewing generated output in: %s\n' "$lab_output"
    ls -la -- "$lab_output/reports"
    rm -i -- "$lab_output/reports/dashboard.html"
    rm -i -- "$lab_output"/reports/alerts-*.json
    rmdir -- "$lab_output/reports" "$lab_output"
    ;;
  *)
    printf 'Cleanup skipped: use the exact lab output directory recorded earlier.\n'
    ;;
esac
deactivate
unset lab_output
```

If a file is absent or you decline deletion, a cleanup command may report an error. Review
the remaining files manually; do not replace these commands with recursive forced deletion.

## 11. What This Proves for ARM-SecNet

The recorded run demonstrates local readiness checks, synthetic fixture processing, JSON
review, standalone static dashboard export and browser viewing on one Ubuntu ARM64 VM
with the recorded SentinelLite source. Repeat runs on other environments need their own evidence.

It connects ARM-SecNet's lab environment to an optional tool workflow without merging
repositories or adding a runtime dependency. It does not prove live endpoint protection,
threat detection effectiveness, production readiness, real AI/LLM capability, or universal
ARM64 compatibility. Adding this guide and passing repository file checks alone does not
prove the VM workflow has run; record actual results separately before claiming validation.
