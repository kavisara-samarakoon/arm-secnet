# ARM-SecNet Overview

ARM-SecNet is an ARM64-first defensive cybersecurity and networking lab toolkit for Apple Silicon students, lecturers, and security learners.

The project focuses on building a small, repeatable, and safe Linux security lab using UTM, ARM64 Linux, clear documentation, and beginner-friendly investigation exercises.

## Project Problem

Many cybersecurity and networking learning resources are still designed around x86 systems, VirtualBox, VMware, and older lab setups.

Students using Apple Silicon Macs often face problems such as:

- x86 VM images not working properly
- unclear ARM64 compatibility
- outdated setup instructions
- scattered cybersecurity lab guides
- difficulty building repeatable security labs
- confusion around safe lab networking

ARM-SecNet addresses this by focusing specifically on Apple Silicon and ARM64 Linux environments.

## Project Solution

ARM-SecNet provides a structured lab toolkit that includes:

- UTM setup guidance
- ARM64 Linux VM setup guidance
- a clear defensive lab topology
- safety rules
- a baseline investigation lab
- an authentication log analysis lab
- validation checks
- documentation for students and lecturers

## What ARM-SecNet Is

ARM-SecNet is:

- a defensive security lab toolkit
- an ARM64-first learning environment
- a documentation-driven cybersecurity project
- a student-friendly lab framework
- a portfolio-ready networking and cybersecurity project

## What ARM-SecNet Is Not

ARM-SecNet is not:

- a custom operating system
- a full SOC platform
- a replacement for Kali Linux
- a replacement for pfSense
- an offensive exploitation framework
- a malware analysis platform
- an automated attack toolkit

## Version 1 Focus

Version 1 is intentionally small, practical, and defensive.

V1 provides a clean foundation with two tested labs instead of many unfinished sections.

V1 includes:

1. UTM setup guide for Apple Silicon macOS
2. ARM64 Linux VM setup guide
3. One concrete lab topology
4. Safety rules
5. Lab 01: Linux baseline investigation
6. Lab 02: authentication log analysis
7. Lecturer summary
8. V1 test notes
9. Screenshot evidence from a real ARM64 VM test
10. V1 demo script
11. Validation script for V1 documentation and evidence

## Optional V1.1 SentinelLite Dashboard Lab

[Lab 03](labs/lab-03-sentinellite-dashboard.md) adds documentation for an optional local
SentinelLite AI CLI and static dashboard demonstration inside the Ubuntu ARM64 VM.
ARM-SecNet provides the lab environment; SentinelLite provides the defensive observation,
report-review and dashboard CLI. The repositories remain separate with no runtime dependency.

The lab itself uses only local installation checks, synthetic demo data, stored JSON report
review and static HTML export. It performs no endpoint observation, scanning, exploitation
or automatic remediation. The dashboard has no server, network requests or live monitoring.
It provides no production security protection or real AI/LLM capability.

[SentinelLite AI v1.2.0-beta](https://github.com/kavisara-samarakoon/sentinellite-ai/releases/tag/v1.2.0-beta)
is now the published dashboard milestone, available as a GitHub pre-release. New Lab 03
runs should use its published wheel or the `v1.2.0-beta` source tag.

ARM-SecNet V1.1 remains release preparation; the V1.0 docs MVP remains the two tested labs
listed above. [Lab 03 runtime evidence](evidence/v1.1-sentinellite-dashboard.md) is recorded
for one Ubuntu 26.04 LTS aarch64 VM using SentinelLite source commit
`d1775f0ca09d714f5ed9d681af90f216c1c39e8e`, before v1.2.0-beta publication. Validation is
limited to that VM and source commit. It does not validate the exact v1.2.0-beta release
wheel or establish universal ARM64 compatibility. New runs require separate evidence.

GitHub Actions runs the 29 documentation/evidence file-presence checks and
`git diff --check` on pull requests and pushes to `main`. It does not install SentinelLite
or execute the VM workflow.

## Learning Goals

After completing the V1 labs, a learner should be able to:

- set up an ARM64 Linux VM using UTM
- understand the basic lab network topology
- collect Linux system baseline information
- inspect users, services, ports, and network interfaces
- review authentication-related logs
- identify normal and suspicious login activity
- write a simple security findings report

## ARM64-Specific Value

The main value of ARM-SecNet is not that it creates new cybersecurity tools from scratch.

The value is that it organizes a working defensive security lab experience specifically for ARM64 and Apple Silicon users.

This makes the project useful for students who use modern MacBooks and need practical cybersecurity labs without depending on x86-only tutorials.
