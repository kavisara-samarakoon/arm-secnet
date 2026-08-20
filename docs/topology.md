# ARM-SecNet V1 Topology

This document explains the first ARM-SecNet lab topology.

Version 1 uses a simple single-VM topology to keep the project realistic, safe, and easy to reproduce on Apple Silicon systems.

## Topology Diagram

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
        ├── user and group review
        ├── running process review
        ├── service and port review
        ├── network interface review
        ├── authentication log analysis
        └── security findings report
```

## Topology Components

### 1. Apple Silicon Mac Host

The host machine runs macOS on Apple Silicon hardware.

The host is used to:

- run UTM
- manage the ARM64 Linux VM
- store ARM-SecNet documentation
- run the validation script
- collect lab evidence and screenshots

### 2. UTM Virtualization Layer

UTM is used to create and run the ARM64 Linux virtual machine.

For V1, UTM provides a simple and practical way to run ARM64 Linux on Apple Silicon without depending on x86-only virtualization workflows.

### 3. UTM Shared/NAT Network

V1 uses UTM Shared/NAT networking.

This keeps the lab simple and safer because the VM can access the network through the host, but the lab does not need to expose services directly to the wider network.

Shared/NAT networking is suitable for V1 because the current labs focus on:

- local Linux investigation
- network interface review
- route and DNS review
- listening port review
- authentication log analysis

### 4. ARM64 Linux Security VM

The ARM64 Linux VM is the main lab system.

Learners use this VM to run defensive investigation commands, review system state, inspect logs, and write findings.

The VM should be treated as a controlled lab machine, not as a production system.

## V1 Lab Activities

The V1 topology supports:

- confirming ARM64/aarch64 architecture
- checking hostname and operating system information
- reviewing users and groups
- reviewing running processes
- reviewing services
- checking network interfaces
- checking default routes and DNS
- reviewing listening ports
- analyzing authentication logs
- documenting basic findings

## V1 Network Boundary

All V1 activities should remain inside the local lab environment.

For V1:

- use UTM Shared/NAT networking
- avoid exposing the VM directly to public networks
- avoid scanning public targets
- avoid attacking external systems
- use lab-generated data where possible

## What V1 Does Not Include

The V1 topology does not include:

- multiple VMs
- bridged network design
- firewall appliance VM
- IDS/IPS appliance VM
- packet capture lab
- public target scanning
- offensive exploitation lab
- SentinelLite AI integration

These items may be considered in later versions after the single-VM defensive foundation is stable.

## Why This Topology Was Chosen

This topology was chosen because it is:

- realistic for a student with an Apple Silicon Mac
- simple to reproduce
- safer for beginner cybersecurity learning
- suitable for defensive Linux and network investigation
- easier to document and validate
- strong enough for a V1 lab foundation

This simple topology lets learners focus on understanding the V1 system and its defensive investigation tasks.
