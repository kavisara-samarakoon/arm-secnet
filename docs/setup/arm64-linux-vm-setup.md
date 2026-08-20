# ARM64 Linux VM Setup Guide

**Defensive security labs for Apple Silicon — from zero setup to first investigation.**

This guide creates the single ARM64 Linux Security VM used by ARM-SecNet V1. The instructions use UTM on an Apple Silicon Mac and keep the VM on UTM Shared/NAT networking.

## Learning Outcome

After completing this guide, the learner should be able to:

- create an ARM64 Linux virtual machine in UTM
- install Ubuntu Server ARM64 or Debian ARM64
- configure suitable CPU, memory, disk, and network settings
- confirm the operating system architecture and network access
- prepare a clean VM for the first defensive investigation lab

## V1 VM Purpose

ARM-SecNet V1 uses one Linux VM for beginner-friendly defensive security work. The VM will be used to review system information, users, services, network settings, and authentication logs.

The V1 topology is:

```text
Apple Silicon Mac
        │
        │ UTM Shared/NAT Network
        │
        ▼
ARM64 Linux Security VM
```

Keep this first environment small. Only one VM is required.

## Recommended Linux Image

Use one of these images:

- [Ubuntu Server for ARM](https://ubuntu.com/download/server/arm) — recommended for most beginners
- [Debian ARM64 network installer](https://www.debian.org/distrib/netinst) — a lightweight alternative

Download the current stable or long-term support release from the distribution's official website. Select an image labelled **ARM64** or **AArch64**. Do not download an `amd64`, `x86_64`, or Intel image.

Keep the downloaded `.iso` file until the installation is complete.

## Recommended VM Resources

| Resource | Minimum | Recommended |
|---|---:|---:|
| CPU | 2 cores | 2 cores |
| RAM | 2 GB | 4 GB |
| Disk | 20 GB | 25 GB |
| Network | Shared/NAT | Shared/NAT |

If the Mac has only 8 GB of memory, start with 2 GB for the VM. Do not assign most of the Mac's CPU or memory to this beginner lab.

## Create a New VM in UTM

1. Open UTM.
2. Select the **+** button to create a new virtual machine.
3. Select **Virtualize**.
4. Select **Linux**.
5. Select **Browse** and choose the downloaded ARM64 Linux ISO.
6. Continue to the hardware settings.

Use **Virtualize**, not **Emulate**, because both the Apple Silicon host and the selected Linux image use ARM64 architecture.

## Configure CPU, RAM, Disk, and Network

Configure the VM with these V1 settings:

1. Set CPU cores to **2**.
2. Set memory to **4096 MB** when the Mac has enough RAM. Use **2048 MB** on a lower-memory host.
3. Create a virtual disk of at least **20 GB**. A **25 GB** disk gives more room for updates and lab files.
4. Skip directory sharing unless it is needed for normal document transfer.
5. Name the VM `ARM-SecNet-Linux`.
6. Save the VM.
7. Open the VM settings and confirm that its network mode is **Shared Network** or **Shared/NAT**.

Leave other hardware options at their UTM defaults. ARM-SecNet V1 does not require additional network adapters.

## Install ARM64 Linux

Start the VM and follow the Ubuntu Server or Debian installer.

1. Choose the normal installation option.
2. Select the preferred language, keyboard layout, and time zone.
3. Keep automatic network configuration enabled. UTM Shared/NAT should provide an address using DHCP.
4. Set the hostname to a clear name such as `arm-secnet-vm`.
5. Create the initial administrator account and use a strong, unique password.
6. Choose guided partitioning with the entire **virtual disk**.
7. Confirm that the installer is changing the VM's virtual disk, not a host or external disk.
8. Install the standard system utilities when the installer offers software choices.
9. Complete the installation and reboot the VM.
10. If the installer starts again after reboot, stop the VM, eject or remove the installer ISO from its removable drive, and start the VM again.

## First Boot Checklist

After the first successful boot, sign in and confirm:

- [ ] the login prompt appears without the installer
- [ ] the account password works
- [ ] the hostname is correct
- [ ] the VM has a network interface and IP address
- [ ] the default route is present
- [ ] the system reports an ARM64 architecture
- [ ] the date and time are reasonable

Display basic system details with:

```bash
hostnamectl
```

## Update the System

Refresh the package list:

```bash
sudo apt update
```

Install available updates:

```bash
sudo apt upgrade -y
```

Read any prompts before accepting configuration changes. Reboot the VM if an update reports that a reboot is required.

## Install Basic Tools

Install the small set of general-purpose tools used by the documentation and labs:

```bash
sudo apt install -y curl wget git net-tools lsof htop tree jq
```

These packages support system inspection and normal lab setup. They do not change the single-VM V1 topology.

## Confirm ARM64 Architecture

Run:

```bash
uname -m
```

The expected result is:

```text
aarch64
```

Some tools or documentation may use the name `arm64` instead. For this project, `aarch64` and `arm64` both describe the expected 64-bit ARM architecture.

You can also review the architecture shown by:

```bash
hostnamectl
```

If the system reports `x86_64` or `amd64`, the wrong installation image was used.

## Confirm Network Access

Display the VM's interfaces and addresses:

```bash
ip addr
```

Display its routes:

```bash
ip route
```

There should normally be an IP address on the main network interface and a line beginning with `default` in the route output.

Test basic internet access:

```bash
ping -c 4 1.1.1.1
```

A successful response confirms basic network reachability. This test does not scan or target a service.

## Create a Lab User

Create a separate account for routine lab work:

```bash
sudo adduser labuser
```

Follow the prompts and set a strong password. Confirm the account:

```bash
id labuser
```

Only grant administrative access if the lab user needs to run the documented `sudo` commands:

```bash
sudo usermod -aG sudo labuser
```

Sign out and sign back in as `labuser` before beginning the labs so any group change takes effect.

## Snapshot Recommendation

Create a clean recovery point after the VM is installed, updated, and checked.

1. Shut down Linux normally.
2. Confirm that the VM is fully stopped in UTM.
3. Use UTM's snapshot option if it is available for the selected configuration. Otherwise, make a backup copy or clone of the stopped VM.
4. Name the recovery point `ARM-SecNet-V1-Clean` and record the date.

Keep the recovery copy powered off. It is a backup, not a second active lab VM.

## ARM64-Specific Notes

- Apple Silicon uses ARM64 architecture.
- Linux commonly reports ARM64 as `aarch64`.
- Always choose ARM64 or AArch64 installation media and packages.
- Software built only for `amd64` or `x86_64` may not run natively in this VM.
- Prefer packages from the Ubuntu or Debian ARM64 repositories.
- Virtualizing an ARM64 guest provides better performance than emulating an x86 guest on Apple Silicon.

## Common Issues

### The VM shows no bootable device

Stop the VM and confirm that the ARM64 Linux ISO is attached to a removable drive. Start the VM again after saving the setting.

### The installer starts after every reboot

Shut down the VM and eject or remove the installer ISO. The virtual disk should remain attached.

### The architecture is incorrect

If `uname -m` reports `x86_64`, create the VM again with an ARM64 or AArch64 ISO and select **Virtualize**.

### The VM has no IP address

Stop the VM, open its UTM settings, and confirm that the network device is enabled and set to **Shared Network** or **Shared/NAT**. Start the VM and check `ip addr` and `ip route` again.

### Internet access does not work

Confirm that the Mac itself has internet access. Then check for a VM address and default route. Restart the VM after correcting the UTM Shared/NAT setting.

### Package installation fails

Run `sudo apt update` again and read the error message. Check network access and available disk space before retrying.

### The VM is slow

Shut it down before changing resources. Confirm that it uses **Virtualize**, then use the recommended RAM and CPU values without allocating most of the host's resources.

## Safety Note

ARM-SecNet is a defensive cybersecurity and networking lab toolkit. Use this VM only for local learning, system review, log analysis, and other authorized defensive exercises.

Do not scan public targets, attack systems, collect real credentials, or expose the VM unnecessarily. Keep the VM on UTM Shared/NAT networking for V1.

## Next Step

The ARM64 Linux Security VM is ready when:

- the system boots from its virtual disk
- updates and basic tools are installed
- `uname -m` reports `aarch64` or `arm64`
- the VM has an IP address, a default route, and basic internet access
- the lab user and clean recovery point are ready

Continue with [Lab 01 — Linux Baseline Investigation](../labs/lab-01-linux-baseline.md).
