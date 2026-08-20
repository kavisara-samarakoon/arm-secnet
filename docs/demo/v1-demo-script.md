# ARM-SecNet V1 Demo Script

This document provides a simple demo flow for explaining ARM-SecNet V1 to a lecturer, reviewer, or portfolio viewer.

## 1. Demo Goal

The goal of this demo is to show that ARM-SecNet is a working ARM64-first defensive cybersecurity and networking lab toolkit.

The demo should prove that:

- the project has a clear cybersecurity learning purpose
- the lab environment works on Apple Silicon / ARM64
- the project follows a safe defensive scope
- the V1 labs are documented and tested
- the repository includes validation and evidence

## 2. Short Project Introduction

ARM-SecNet is an ARM64-first defensive cybersecurity and networking lab toolkit.

It is designed mainly for students and Apple Silicon users who want to build a safe cybersecurity lab using macOS, UTM, an ARM64 Linux VM, Linux security investigation commands, authentication log analysis, and evidence collection.

This project does not focus on attacking real systems. It focuses on defensive learning inside a local lab environment.

## 3. Problem Statement

Many cybersecurity labs and tutorials are still written for x86 systems, VirtualBox, VMware, or Kali-based environments.

Apple Silicon users can face issues because:

- some tools are designed mainly for x86
- some VM setup guides do not match ARM64 systems
- students may waste time fixing compatibility problems
- beginners may not know how to safely start a defensive lab

ARM-SecNet solves this by giving a clean ARM64-friendly path for setup, testing, and learning.

## 4. V1 Scope

ARM-SecNet V1 includes:

- project README
- safety rules
- ARM64 lab topology
- macOS UTM setup guide
- ARM64 Linux VM setup guide
- Lab 01: Linux baseline investigation
- Lab 02: authentication log analysis
- lecturer summary
- V1 test notes
- screenshot evidence
- validation script

The V1 scope is intentionally simple. The aim is to build a strong foundation before adding advanced labs or tools.

## 5. Demo Preparation Checklist

Before starting the demo, confirm that the repository is clean:

    git status

Expected result:

    nothing to commit, working tree clean

Run the validation script:

    bash scripts/validate-lab.sh

Expected result:

    Passed:  19
    Warnings: 0
    Failed:  0

    ARM-SecNet V1 validation passed.

## 6. Suggested Demo Flow

### Step 1: Show the README

Open README.md and explain that it is the main entry point of the project.

Show the quick navigation links for overview, safety, topology, setup guides, labs, test notes, and screenshot evidence.

### Step 2: Explain the Safety Scope

Open docs/safety.md.

Explain that ARM-SecNet is defensive and local-lab focused.

Mention that the project avoids malware, credential theft, phishing, attacking public targets, and harmful automation.

### Step 3: Show the Topology

Open docs/topology.md.

Explain the V1 topology:

    Apple Silicon Mac
    -> UTM
    -> ARM64 Linux VM
    -> defensive Linux and network investigation labs

Mention that V1 uses UTM Shared/NAT networking for safety and simplicity.

### Step 4: Show Setup Guides

Open:

- docs/setup/macos-utm-setup.md
- docs/setup/arm64-linux-vm-setup.md

Explain that these guides help Apple Silicon users create the lab environment step by step.

### Step 5: Show Lab 01

Open docs/labs/lab-01-linux-baseline.md.

Explain that Lab 01 teaches basic Linux baseline investigation.

It helps learners check system architecture, hostname, OS information, users, running processes, services, network interfaces, routes, DNS, listening ports, and installed packages.

### Step 6: Show Lab 02

Open docs/labs/lab-02-auth-log-analysis.md.

Explain that Lab 02 teaches authentication log analysis.

It helps learners review login activity, sudo activity, failed login indicators, successful login indicators, journalctl output, and suspicious authentication patterns.

Mention that Ubuntu ARM64 compatibility notes were added after real VM testing.

### Step 7: Show V1 Test Notes

Open docs/v1-test-notes.md.

Explain that this file records the first real test session.

Mention that the test confirmed ARM64/aarch64 architecture, UTM/QEMU virtualization, Shared/NAT networking, and that Lab 01 and Lab 02 worked.

### Step 8: Show Screenshot Evidence

Open docs/evidence/v1-screenshots.md.

Explain that screenshots were added as proof of real testing.

The evidence includes:

- ARM64 architecture confirmation
- UTM Shared/NAT networking
- Lab 01 system baseline
- Lab 01 users and processes
- Lab 02 authentication log and sudo activity

### Step 9: Run the Validation Script

Run:

    bash scripts/validate-lab.sh

Explain that the validation script checks whether all required V1 files and evidence files exist.

## 7. Short Explanation to Say During Demo

ARM-SecNet is a defensive cybersecurity and networking lab toolkit designed for ARM64 systems, especially Apple Silicon Macs.

The main purpose is to help students safely set up an ARM64 Linux lab in UTM and complete practical defensive security labs.

In V1, I focused on building a clean foundation instead of adding too many advanced features. The project includes setup guides, safety rules, topology, two practical labs, test notes, screenshot evidence, and a validation script.

The project is useful because many cybersecurity learning resources are still x86-focused, while Apple Silicon users need clearer ARM64-compatible guidance.

## 8. Current Limitations

ARM-SecNet V1 is still an early version.

Current limitations:

- only two labs are included
- the project is documentation-focused
- V1 uses one ARM64 Linux VM
- V1 does not include a packet capture lab
- SentinelLite AI is outside the V1 scope
- the current screenshots come from one tested Ubuntu ARM64 VM

These limitations are acceptable for V1 because the goal was to build a safe and tested foundation first.

## 9. Future Improvements

Possible future improvements:

- add more defensive Linux investigation labs
- add packet capture and traffic analysis labs
- add firewall and IDS/IPS-related labs
- test on a cleaner minimal Ubuntu Server ARM64 VM
- add more screenshot evidence
- add learner worksheets and answer templates
- optionally integrate SentinelLite AI in a later version

## 10. Demo Closing Statement

ARM-SecNet V1 proves that a safe ARM64 cybersecurity lab can be built, documented, tested, and validated on Apple Silicon.

The project is useful for my cybersecurity and networking learning path, and it can also help other students who want to start defensive cybersecurity labs on ARM64 systems.
