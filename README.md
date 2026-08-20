# ARM-SecNet

**Defensive security labs for Apple Silicon — from zero setup to first investigation.**

ARM-SecNet is an ARM64-first defensive cybersecurity and networking lab toolkit for Apple Silicon students, lecturers, and security learners.

The project helps learners build a small, repeatable security lab using UTM, ARM64 Linux, safe investigation exercises, setup documentation, and simple validation checks.

## Project Purpose

Many cybersecurity and networking learning resources are still designed around x86 systems, VirtualBox, VMware, and older lab setups. Students using Apple Silicon Macs often face ARM64 compatibility issues when building cybersecurity labs.

ARM-SecNet addresses this by providing a small, repeatable, ARM64-first defensive security lab toolkit using UTM, ARM64 Linux, safe investigation exercises, and clear documentation.

## Current Scope

ARM-SecNet is a **lab toolkit**, not a custom operating system, not a full SOC platform, and not a replacement for existing cybersecurity tools.

The first version focuses on:

- setting up UTM on Apple Silicon
- creating an ARM64 Linux VM
- understanding the lab network topology
- running safe Linux baseline checks
- analyzing authentication logs
- writing a basic security findings report

## Target Users

- Computer Networks students
- Cybersecurity students
- University lecturers
- Apple Silicon Mac users
- ARM64 Linux learners
- Beginner Blue Team / SOC learners
- Small cybersecurity clubs and lab teams

## Version 1 MVP

ARM-SecNet V1 currently includes:

- UTM setup guide
- ARM64 Linux VM setup guide
- one concrete lab topology
- safety rules
- Lab 01: Linux baseline investigation
- Lab 02: Authentication log analysis
- validation script

## Quick Navigation

### Testing Evidence

- [V1 Test Notes](docs/v1-test-notes.md)
- [V1 Screenshot Evidence](docs/evidence/v1-screenshots.md)

### Testing Evidence


### Core Documentation

- [Project Overview](docs/overview.md)
- [Safety Rules](docs/safety.md)
- [V1 Topology](docs/topology.md)

### Setup Guides

- [macOS UTM Setup Guide](docs/setup/macos-utm-setup.md)
- [ARM64 Linux VM Setup Guide](docs/setup/arm64-linux-vm-setup.md)

### V1 Labs

- [Lab 01 — Linux Baseline Investigation](docs/labs/lab-01-linux-baseline.md)
- [Lab 02 — Authentication Log Analysis](docs/labs/lab-02-auth-log-analysis.md)

### Validation

Run the validation script:

```bash
bash scripts/validate-lab.sh
```

Expected result:

```text
Passed:  10
Warnings: 0
Failed:  0

Foundation validation passed.
```

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

## Security Scope

ARM-SecNet is a defensive cybersecurity learning project.

It is intended for:

- Linux security learning
- safe lab testing
- defensive investigation practice
- network visibility practice
- authentication log analysis
- system baseline review
- structured security reporting

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

## Repository Structure

```text
arm-secnet/
├── README.md
├── docs/
│   ├── overview.md
│   ├── safety.md
│   ├── topology.md
│   ├── setup/
│   │   ├── macos-utm-setup.md
│   │   └── arm64-linux-vm-setup.md
│   └── labs/
│       ├── lab-01-linux-baseline.md
│       └── lab-02-auth-log-analysis.md
├── scripts/
│   └── validate-lab.sh
├── LICENSE
└── CONTRIBUTING.md
```

## Setup Guides

### macOS UTM Setup Guide

The macOS UTM setup guide explains how to install and prepare UTM on Apple Silicon macOS for the ARM-SecNet V1 lab.

Read:

```text
docs/setup/macos-utm-setup.md
```

### ARM64 Linux VM Setup Guide

The ARM64 Linux VM setup guide explains how to create the ARM64 Linux Security VM used in the V1 labs.

Read:

```text
docs/setup/arm64-linux-vm-setup.md
```

## V1 Labs

### Lab 01 — Linux Baseline Investigation

Learners collect basic system, user, service, network, and package information from an ARM64 Linux VM and explain what the baseline shows.

This lab helps learners answer questions such as:

- What system am I investigating?
- Is the VM really running ARM64 Linux?
- Which users exist on the system?
- Which services are running?
- Which ports are listening?
- What would make this baseline suspicious?

Read:

```text
docs/labs/lab-01-linux-baseline.md
```

### Lab 02 — Authentication Log Analysis

Learners inspect authentication-related logs, identify normal and suspicious login activity, review sudo usage, and write a short security findings summary.

This lab helps learners answer questions such as:

- Are there repeated failed login attempts?
- Are successful logins expected?
- Are any usernames unfamiliar?
- Was sudo used by the expected user?
- What would make this activity suspicious?
- What evidence should be captured before changing anything?

Read:

```text
docs/labs/lab-02-auth-log-analysis.md
```

## Project Direction

ARM-SecNet will stay small and practical in V1.

The goal is to finish two complete labs instead of creating many unfinished sections. Later versions may add process monitoring, network visibility, firewall basics, packet capture basics, and SentinelLite AI integration documentation.

## Future Ideas

Possible future improvements include:

- process monitoring lab
- network visibility lab
- firewall basics lab
- packet capture basics
- validation improvements
- screenshots and demo evidence
- lecturer-facing summary document
- SentinelLite AI integration guide

These are intentionally delayed until the V1 documentation and lab experience are stable.

## Safety Notice

ARM-SecNet follows a defensive-first approach.

All activities should remain inside the local lab environment. Do not scan public targets, attack external systems, collect real credentials, run malware, or expose the VM unnecessarily to the local network.

For V1, use UTM Shared/NAT networking.

## Author

Kavisara Samarakoon  
Computer Networks Student, NSBM Green University  
External BIT Student, University of Moratuwa  
Career Direction: Cybersecurity Analyst and Network Engineer
