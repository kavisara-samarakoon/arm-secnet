# Lecturer Summary — ARM-SecNet

## Project Title

**ARM-SecNet**

## Tagline

**Defensive security labs for Apple Silicon — from zero setup to first investigation.**

## Student

**Kavisara Samarakoon**  
Computer Networks Student, NSBM Green University  
External BIT Student, University of Moratuwa  
Career Direction: Cybersecurity Analyst and Network Engineer

## Project Overview

ARM-SecNet is an ARM64-first defensive cybersecurity and networking lab toolkit for Apple Silicon students, lecturers, and security learners.

The project helps learners build a small, repeatable Linux security lab using UTM, ARM64 Linux, safe investigation exercises, setup documentation, and simple validation checks.

ARM-SecNet is designed as a lab toolkit, not as a custom operating system, full SOC platform, or offensive security framework.

## Problem Statement

Many cybersecurity and networking learning resources are still designed around x86 systems, VirtualBox, VMware, and older lab environments.

Students using Apple Silicon Macs often face ARM64 compatibility issues when trying to build cybersecurity labs. This creates problems such as unclear setup steps, unsupported VM images, scattered guidance, and difficulty creating a stable lab environment.

ARM-SecNet addresses this problem by providing a focused ARM64-first lab toolkit for Apple Silicon users.

## Solution

ARM-SecNet provides a structured defensive lab environment using:

- UTM virtualization
- one ARM64 Linux virtual machine
- Shared/NAT networking
- clear setup guides
- safe lab exercises
- investigation questions
- findings report templates
- validation checks

The first version focuses on helping students move from basic setup to their first defensive investigation.

## V1 Scope

Version 1 is intentionally small and realistic.

ARM-SecNet V1 includes:

- macOS UTM setup guide
- ARM64 Linux VM setup guide
- V1 topology documentation
- safety rules
- Lab 01: Linux baseline investigation
- Lab 02: Authentication log analysis
- lecturer summary
- V1 test notes
- screenshot evidence from a real ARM64 VM test
- V1 demo script
- validation script

V1 provides two complete labs instead of many unfinished lab sections.

## V1 Topology

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
