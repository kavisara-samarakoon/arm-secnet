# macOS UTM Setup Guide

This guide explains how to install and prepare UTM on Apple Silicon macOS for the ARM-SecNet V1 lab.

## Learning Outcome

After completing this guide, the learner should be able to:

- install UTM on macOS
- understand why UTM is used for ARM64 labs
- prepare a clean virtualization environment
- confirm that the Mac is ready to run an ARM64 Linux security VM

## Why UTM?

ARM-SecNet uses UTM because it supports Apple Silicon Macs and ARM64 virtual machines.

Many older cybersecurity labs are designed for x86 virtualization tools such as VirtualBox or VMware. Apple Silicon Macs use ARM64 architecture, so some older x86-based lab instructions do not work smoothly.

UTM provides a practical way to run ARM64 Linux virtual machines on Apple Silicon.

## Recommended Host System

Recommended host environment:

| Component | Recommended |
|---|---|
| Device | Apple Silicon Mac |
| Processor | M1 or newer |
| RAM | 8 GB minimum, 16 GB recommended |
| Storage | At least 30 GB free |
| Virtualization Tool | UTM |
| Network Mode for V1 | Shared/NAT |

The current ARM-SecNet V1 design uses one ARM64 Linux VM.

## Download UTM

Download UTM from the [official UTM website](https://mac.getutm.app/) or the Mac App Store. Either version is suitable for this lab; the App Store version provides automatic updates.

## Install UTM

1. Download the UTM `.dmg` file.
2. Open the downloaded file.
3. Drag UTM into the Applications folder.
4. Open UTM from Applications.
5. If macOS shows a security warning, allow UTM from System Settings if needed.

## Prepare a VM Storage Location

For better storage management, create a dedicated folder for ARM-SecNet virtual machines.

Recommended location:

```text
~/UTM-VMs/arm-secnet/
```

If you are using an external SSD, you can create a folder such as:

```text
/Volumes/ExternalSSD/UTM-VMs/arm-secnet/
```

Using an external SSD is useful if your MacBook has limited internal storage.

## Recommended UTM Settings for V1

For the first ARM-SecNet VM, use these general settings:

| Setting | Recommendation |
|---|---|
| Virtualization Mode | Virtualize |
| Architecture | ARM64 |
| RAM | 2 GB minimum, 4 GB recommended |
| CPU Cores | 2 cores |
| Disk Size | 20 GB minimum |
| Network | Shared Network / NAT |
| Display | Default |
| Clipboard Sharing | Optional |

## Why Shared/NAT Network?

ARM-SecNet V1 uses Shared/NAT networking because it is simple and safer for beginners.

Shared/NAT networking:

- allows the VM to access the internet for updates
- avoids exposing the VM directly to the local network
- reduces troubleshooting issues
- works well for a single-VM defensive lab
- supports the V1 labs without extra network complexity

## Why Not Bridged Networking Yet?

Bridged networking is delayed until a later version.

For V1, bridged networking is not recommended because:

- it can expose the VM more directly to the local network
- behavior can depend on router and Wi-Fi settings
- it creates more troubleshooting problems
- it distracts from the first learning goals

## UTM Readiness Checklist

Before continuing to the ARM64 Linux VM setup guide, confirm:

- [ ] UTM is installed
- [ ] UTM opens successfully
- [ ] A VM storage folder is prepared
- [ ] You understand the V1 Shared/NAT network choice
- [ ] You have enough storage for one ARM64 Linux VM
- [ ] You are ready to download an ARM64 Linux ISO

## Common Issues

### UTM does not open

Check macOS security settings and confirm that UTM is allowed to run.

### Not enough storage

Free space on the internal disk or move the VM storage location to an external SSD.

### Confusion about architecture

For ARM-SecNet, use ARM64 Linux images, not x86 ISO images.

### Network confusion

Use Shared/NAT for V1. Do not use bridged networking unless a later guide specifically asks for it.

## Safety Note

This guide only prepares the virtualization environment.

Do not scan public targets, attack external systems, or expose the VM unnecessarily to the local network.

ARM-SecNet V1 is designed for local defensive learning only.

## Next Step

After UTM is installed and ready, continue to the [ARM64 Linux VM Setup Guide](arm64-linux-vm-setup.md).
