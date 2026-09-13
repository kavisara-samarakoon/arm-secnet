# ARM-SecNet

**Defensive security labs for Apple Silicon — from zero setup to first investigation.**

ARM-SecNet is an ARM64-first defensive cybersecurity and networking lab toolkit for Apple Silicon students, lecturers, and security learners.

The project helps learners build a small, repeatable security lab using UTM, ARM64 Linux, safe investigation exercises, setup documentation, screenshot-backed evidence, and simple validation checks.

Latest published release: [ARM-SecNet V1.1.0 SentinelLite Dashboard Lab](https://github.com/kavisara-samarakoon/arm-secnet/releases/tag/v1.1.0-sentinellite-dashboard-lab)  
Published: `2026-09-13`  
Current validation result: **29 passed, 0 warnings, 0 failures**

---

## Project Purpose

Many cybersecurity and networking learning resources are still designed around x86 systems, VirtualBox, VMware, and older lab setups. Students using Apple Silicon Macs often face ARM64 compatibility issues when building cybersecurity labs.

ARM-SecNet addresses this by providing a small, repeatable, ARM64-first defensive security lab toolkit using:

- Apple Silicon macOS
- UTM virtualization
- ARM64 Linux
- safe defensive investigation exercises
- evidence-based lab documentation
- simple validation checks

The goal is to make cybersecurity lab learning practical for students using modern MacBooks.

---

## Current Scope

ARM-SecNet is a **lab toolkit**.

It is not:

- a custom operating system
- a production EDR
- an antivirus
- a SIEM or SOC platform
- a malware analysis platform
- an offensive security toolkit
- a replacement for professional cybersecurity tools

The current release focuses on:

- setting up UTM on Apple Silicon
- creating an ARM64 Linux VM
- understanding the lab network topology
- running safe Linux baseline checks
- analyzing authentication logs
- writing a basic security findings report
- optionally running SentinelLite AI inside the ARM64 VM
- exporting a local static SentinelLite dashboard
- recording evidence and validating documentation structure

---

## Latest Release: V1.1.0 SentinelLite Dashboard Lab

[ARM-SecNet V1.1.0 SentinelLite Dashboard Lab](https://github.com/kavisara-samarakoon/arm-secnet/releases/tag/v1.1.0-sentinellite-dashboard-lab) was published on `2026-09-13` under tag:

```text
v1.1.0-sentinellite-dashboard-lab
```

V1.1 includes three documented labs:

1. Lab 01 — Linux Baseline Investigation
2. Lab 02 — Authentication Log Analysis
3. Lab 03 — SentinelLite AI Local CLI and Static Dashboard

V1.1 also includes:

- screenshot-backed Lab 03 evidence
- GitHub Actions documentation validation
- local validation using `scripts/validate-lab.sh`
- release notes for the V1.1 milestone

Read the release notes:

```text
docs/release-notes-v1.1.0-sentinellite-dashboard-lab.md
```

---

## How ARM-SecNet and SentinelLite AI Work Together

ARM-SecNet and SentinelLite AI are separate projects.

```text
ARM-SecNet = ARM64 lab environment and learning framework
SentinelLite AI = optional defensive Linux observation and report-review CLI
```

ARM-SecNet provides the Apple Silicon / UTM / ARM64 Linux lab environment.

SentinelLite AI can be installed inside the ARM64 Linux VM for the optional Lab 03 workflow. In that workflow, SentinelLite is used to run safe local commands such as:

- `sentinellite doctor`
- `sentinellite demo`
- `sentinellite dashboard export`

The SentinelLite dashboard is static local HTML. It does not start a server, make network requests, provide live monitoring, or perform automatic remediation.

For new Lab 03 runs, use the published [SentinelLite AI v1.2.0-beta GitHub pre-release](https://github.com/kavisara-samarakoon/sentinellite-ai/releases/tag/v1.2.0-beta) wheel or the `v1.2.0-beta` release tag.

---

## Important Evidence Limitation

The existing Lab 03 screenshots were recorded before SentinelLite AI `v1.2.0-beta` was published.

The recorded Lab 03 VM evidence used:

```text
SentinelLite source commit:
d1775f0ca09d714f5ed9d681af90f216c1c39e8e

Recorded CLI version:
SentinelLite AI v1.1.0-beta

VM:
Ubuntu 26.04 LTS aarch64
```

That source commit already included the dashboard exporter, but the existing screenshots do **not** validate the exact SentinelLite `v1.2.0-beta` release wheel.

A new exact-release validation run must record separate evidence before claiming exact `v1.2.0-beta` wheel validation.

This project does not claim universal ARM64 compatibility or production security protection.

---

## Target Users

- Computer Networks students
- Cybersecurity students
- University lecturers
- Apple Silicon Mac users
- ARM64 Linux learners
- beginner Blue Team / SOC learners
- individual learners and small cybersecurity clubs

---

## Full Setup Path

Follow the repository in this order.

### 1. Prepare UTM on Apple Silicon macOS

Read:

```text
docs/setup/macos-utm-setup.md
```

This guide covers:

- installing UTM
- preparing a VM storage location
- selecting ARM64 virtualization
- using Shared/NAT networking
- understanding why UTM is used for Apple Silicon labs

---

### 2. Create the ARM64 Linux Security VM

Read:

```text
docs/setup/arm64-linux-vm-setup.md
```

This guide covers:

- downloading an ARM64 Linux image
- creating the VM in UTM
- configuring CPU, RAM, disk, and network settings
- installing Ubuntu Server ARM64 or Debian ARM64
- confirming `aarch64`
- checking network access
- creating a lab user
- taking a clean recovery snapshot

Expected architecture check:

```bash
uname -m
```

Expected result:

```text
aarch64
```

---

### 3. Run Lab 01 — Linux Baseline Investigation

Read:

```text
docs/labs/lab-01-linux-baseline.md
```

Lab 01 helps learners inspect:

- system identity
- architecture
- users
- running processes
- listening services
- network interfaces
- installed packages
- basic security findings

---

### 4. Run Lab 02 — Authentication Log Analysis

Read:

```text
docs/labs/lab-02-auth-log-analysis.md
```

Lab 02 helps learners inspect:

- authentication logs
- successful login activity
- failed login activity
- sudo usage
- suspicious account activity
- evidence collection
- basic reporting

---

### 5. Run Lab 03 — SentinelLite AI Local CLI and Static Dashboard

Read:

```text
docs/labs/lab-03-sentinellite-dashboard.md
```

Lab 03 is optional. It adds a SentinelLite AI workflow inside the ARM64 Linux VM.

The recommended path for new runs is to install the published SentinelLite AI `v1.2.0-beta` wheel.

Inside the Ubuntu ARM64 VM:

```bash
mkdir -p "$HOME/lab-tools/sentinellite-v1.2.0-beta-wheel"
cd "$HOME/lab-tools/sentinellite-v1.2.0-beta-wheel"

python3 -m venv .venv
source .venv/bin/activate

python -m pip install --upgrade pip
python -m pip install 'https://github.com/kavisara-samarakoon/sentinellite-ai/releases/download/v1.2.0-beta/sentinellite_ai-1.2.0b0-py3-none-any.whl#sha256=fc8c647921d1d2575cb0ac25e1a7f32191e8ea8e0363a90a4728bf59dae4ba15'

python -m pip check
sentinellite --version
sentinellite dashboard export --help
```

Expected version output:

```text
SentinelLite AI v1.2.0-beta
```

Then run the safe demo workflow from a fresh temporary directory:

```bash
lab_output="$(mktemp -d /tmp/arm-secnet-sentinellite.XXXXXX)"
cd "$lab_output"

sentinellite doctor
sentinellite demo
sentinellite dashboard export
```

The demo uses bundled synthetic data. It does not read real host logs, observe real processes, inspect active connections, scan the network, or send external notifications.

The dashboard export creates:

```text
reports/dashboard.html
```

Open the HTML file manually in a browser to view the local static dashboard.

---

## Quick Navigation

### Core Documentation

- [Project Overview](docs/overview.md)
- [Safety Rules](docs/safety.md)
- [V1 Topology](docs/topology.md)

### Setup Guides

- [macOS UTM Setup Guide](docs/setup/macos-utm-setup.md)
- [ARM64 Linux VM Setup Guide](docs/setup/arm64-linux-vm-setup.md)

### Labs

- [Lab 01 — Linux Baseline Investigation](docs/labs/lab-01-linux-baseline.md)
- [Lab 02 — Authentication Log Analysis](docs/labs/lab-02-auth-log-analysis.md)
- [Lab 03 — SentinelLite AI Local CLI and Static Dashboard](docs/labs/lab-03-sentinellite-dashboard.md)

### Evidence and Demo

- [V1 Screenshot Evidence](docs/evidence/v1-screenshots.md)
- [Recorded SentinelLite Dashboard Evidence](docs/evidence/v1.1-sentinellite-dashboard.md)
- [V1 Demo Script](docs/demo/v1-demo-script.md)
- [V1 Test Notes](docs/v1-test-notes.md)
- [Lecturer Summary](docs/lecturer-summary.md)

### Release Notes

- [V1.1.0 SentinelLite Dashboard Lab Release Notes](docs/release-notes-v1.1.0-sentinellite-dashboard-lab.md)
- [V1.0.0 Documentation MVP Release](https://github.com/kavisara-samarakoon/arm-secnet/releases/tag/v1.0.0-docs-mvp)

---

## Validation

Run the validation script:

```bash
bash scripts/validate-lab.sh
```

Expected result:

```text
Passed:  29
Warnings: 0
Failed:  0

ARM-SecNet documentation and evidence validation passed.
```

The validation script checks documentation and evidence file presence. It does not install SentinelLite, run SentinelLite, or perform a fresh ARM64 VM validation.

GitHub Actions also runs:

```bash
bash scripts/validate-lab.sh
git diff --check
```

on pull requests and pushes to `main`.

---

## V1 Lab Topology

```text
MacBook Apple Silicon Host
macOS + UTM
        │
        │ UTM Shared/NAT Network
        │
        ▼
ARM64 Linux Security VM
        │
        ├── system baseline checks
        ├── network interface checks
        ├── open port/service checks
        ├── authentication log analysis
        └── basic security findings report
```

Optional V1.1 Lab 03 workflow:

```text
MacBook Apple Silicon Host
        │
        ▼
UTM Shared/NAT
        │
        ▼
Ubuntu ARM64 VM
        │
        ▼
SentinelLite AI
        │
        ├── doctor
        ├── demo using synthetic data
        ├── JSON report output
        └── static dashboard export
```

---

## Security Scope

ARM-SecNet is a defensive cybersecurity learning project.

It is intended for:

- Linux security learning
- safe local lab testing
- defensive investigation practice
- network visibility practice
- authentication log analysis
- system baseline review
- structured security reporting
- portfolio demonstration

It is not intended for:

- malware
- credential theft
- phishing
- backdoors
- unauthorized exploitation
- persistence payloads
- destructive automation
- public target scanning
- harmful offensive activity

All activities should remain inside the local authorized lab environment.

For V1 and V1.1, use UTM Shared/NAT networking.

---

## Repository Structure

```text
arm-secnet/
├── README.md
├── docs/
│   ├── overview.md
│   ├── safety.md
│   ├── topology.md
│   ├── lecturer-summary.md
│   ├── v1-test-notes.md
│   ├── demo/
│   │   └── v1-demo-script.md
│   ├── evidence/
│   │   ├── v1-screenshots.md
│   │   ├── v1.1-sentinellite-dashboard.md
│   │   └── screenshots/
│   │       ├── 01-arm64-hostnamectl.png
│   │       ├── 02-network-shared-nat.png
│   │       ├── 03-lab01-system-baseline.png
│   │       ├── 04-lab01-users-processes.png
│   │       ├── 05-auth-log-sudo-activity.png
│   │       └── v1.1-sentinellite/
│   │           ├── 01-vm-prerequisites.png
│   │           ├── 02-sentinellite-source.png
│   │           ├── 03-doctor.png
│   │           ├── 04-synthetic-demo.png
│   │           ├── 05-json-report-review.png
│   │           ├── 06-static-dashboard-terminal.png
│   │           ├── 07-static-dashboard-browser-summary.png
│   │           └── 08-static-dashboard-browser-alerts.png
│   ├── setup/
│   │   ├── macos-utm-setup.md
│   │   └── arm64-linux-vm-setup.md
│   └── labs/
│       ├── lab-01-linux-baseline.md
│       ├── lab-02-auth-log-analysis.md
│       └── lab-03-sentinellite-dashboard.md
├── scripts/
│   └── validate-lab.sh
├── .github/
│   └── workflows/
│       └── validate.yml
├── LICENSE
└── CONTRIBUTING.md
```

---

## Historical Release: V1.0.0 Documentation MVP

The historical `v1.0.0-docs-mvp` release includes:

- UTM setup guide for Apple Silicon macOS
- ARM64 Linux VM setup guide
- one concrete V1 lab topology
- safety rules for defensive lab work
- Lab 01: Linux baseline investigation
- Lab 02: authentication log analysis
- lecturer summary
- V1 test notes
- screenshot evidence from a real ARM64 VM test
- V1 demo script
- validation script with V1 documentation and evidence checks

The V1.0 release remains available here:

```text
https://github.com/kavisara-samarakoon/arm-secnet/releases/tag/v1.0.0-docs-mvp
```

---

## Project Direction

ARM-SecNet will stay small, practical, and defensive.

V1 created the foundation with setup guides, two tested labs, evidence, validation, and a demo flow.

V1.1 added the optional SentinelLite dashboard lab and public release workflow.

Future versions may add more advanced defensive labs only after the current documentation and learning experience remain stable.

Possible future improvements include:

- process observation lab
- network visibility lab
- firewall basics lab
- packet capture basics
- cleaner Ubuntu Server ARM64 test evidence
- learner worksheet and findings report templates
- validation improvements
- additional VM runs and reviewed evidence beyond the one recorded SentinelLite dashboard run

---

## Safety Notice

ARM-SecNet follows a defensive-first approach.

Do not scan public targets, attack external systems, collect real credentials, run malware, create persistence, or expose the VM unnecessarily to the local network.

Use only local, authorized lab environments.

---

## Author

Kavisara Samarakoon  
Computer Networks Student, NSBM Green University  
External BIT Student, University of Moratuwa  
Career Direction: Cybersecurity Analyst and Network Engineer
