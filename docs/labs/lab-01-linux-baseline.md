# Lab 01 — Linux Baseline Investigation

**Defensive security labs for Apple Silicon — from zero setup to first investigation.**

## Lab Purpose

This lab builds a basic security baseline for the ARM-SecNet V1 Linux VM. A baseline records the system's normal identity, users, processes, services, network settings, listening ports, and installed software.

The baseline provides a reference for later defensive investigations. Complete the observations before making unnecessary system changes.

## Learning Outcome

After completing this lab, the learner should be able to:

- confirm the identity and ARM64 architecture of a Linux VM
- collect basic operating system and resource information
- review local users, running processes, and services
- identify network interfaces, routes, DNS settings, and listening ports
- record observations in a short defensive findings report
- explain why a known-good baseline is useful during an investigation

## Required Environment

You need:

- an Apple Silicon Mac with UTM installed
- one ARM64 Linux Security VM
- Ubuntu Server ARM64 or Debian ARM64
- UTM Shared/NAT networking
- a normal lab user with `sudo` access where required
- a terminal inside the VM
- a text file or notebook for recording evidence

Complete the ARM64 Linux VM setup guide before starting this lab.

## Safety Scope

This is a defensive, local investigation of your own ARM-SecNet VM.

You may:

- inspect local system information
- review local users, processes, services, and packages
- review the VM's own interfaces, routes, DNS settings, and listening ports
- record findings without changing the system

Do not scan public targets, test passwords, exploit systems, install malware, create persistence, or investigate systems without authorization. Keep the VM on UTM Shared/NAT networking.

## Investigation Scenario

You are preparing a newly installed ARM64 Linux Security VM for future defensive labs. Before using it, you need to document its normal state.

Your task is to answer three questions:

1. What system are you examining?
2. What normally runs and listens on this system?
3. Is there anything unexpected that should be reviewed before this VM becomes the known-good baseline?

Open a terminal and record each command, the important parts of its output, and the time the evidence was collected.

## Step 1: Confirm System Identity

Run:

```bash
hostname
hostnamectl
date
uptime
```

Expected observations:

- `hostname` displays the VM's configured system name.
- `hostnamectl` provides the hostname and general system information when systemd is available.
- `date` shows the VM's current date, time, and time zone.
- `uptime` shows how long the VM has been running and its recent load averages.

Record the hostname and collection time. Note an incorrect clock, unfamiliar hostname, or unexpectedly long uptime.

Review basic storage and memory information:

```bash
df -h
free -h
```

Expected observations:

- `df -h` lists mounted filesystems and their available space.
- `free -h` summarizes used and available memory.

Record any filesystem that is nearly full or any resource value that appears unusual for the VM configuration.

## Step 2: Confirm ARM64 Architecture

Run:

```bash
uname -m
```

Expected observation:

- The architecture should normally be reported as `aarch64` or `arm64`.

If the result is `x86_64` or `amd64`, stop and review the VM setup. ARM-SecNet V1 requires an ARM64 Linux guest.

## Step 3: Review Kernel and OS Details

Run:

```bash
uname -a
cat /etc/os-release
```

Expected observations:

- `uname -a` displays the kernel name, release, build information, and architecture.
- `/etc/os-release` identifies the Linux distribution and version.
- Version values will differ depending on the selected Ubuntu or Debian image and installed updates.

Record the kernel release, distribution name, and distribution version. Do not assume a version is outdated or unsafe without checking its support status later.

## Step 4: Review Current User and Privileges

Run:

```bash
whoami
id
```

Expected observations:

- `whoami` displays the current account name.
- `id` displays the current user's numeric ID, primary group, and additional groups.
- A lab user may belong to an administrative group such as `sudo` if that access was configured during setup.

Record the current user and important group memberships. Note unexpected administrative access.

## Step 5: Review Local Users

Run:

```bash
getent passwd
```

Expected observations:

- The output includes both human login accounts and service accounts.
- System accounts often use non-login shells such as `/usr/sbin/nologin` or `/bin/false`.
- Normal user accounts commonly have home directories under `/home`.
- The second field does not display account passwords; password hashes are protected separately.

Record the human accounts you recognize and any account that needs further explanation. Do not delete or modify an account during baseline collection.

## Step 6: Review Running Processes

Run:

```bash
ps aux
```

Expected observations:

- The output lists processes owned by both system and user accounts.
- Core operating system processes will normally be present.
- The command itself and the current shell may appear in the results.
- Process names and counts will vary with the distribution and current workload.

Record processes that are important to the VM's role and investigate unfamiliar names through trusted documentation before deciding they are suspicious.

## Step 7: Review Services

Run:

```bash
systemctl --type=service --state=running
```

Expected observations:

- The output lists services that systemd currently reports as running.
- The exact services depend on the distribution, installer choices, and installed packages.
- Some services support normal operating system functions even if their names are unfamiliar.

Record services of interest and their purpose. If `systemctl` is unavailable, note that the system may use a different service manager rather than treating the missing command as suspicious.

## Step 8: Review Network Interfaces

Run:

```bash
ip addr
```

Expected observations:

- A loopback interface is normally present.
- The primary VM interface should normally have an address supplied through UTM Shared/NAT networking.
- Interface names may differ between installations.
- Temporary or additional addresses may appear depending on the distribution's network configuration.

Record the primary interface name and its address. Do not record unrelated personal network details in a report intended for public sharing.

## Step 9: Review Routes and DNS

Run:

```bash
ip route
resolvectl status
```

Expected observations:

- `ip route` should normally show a default route for external access and a route for the VM's local subnet.
- `resolvectl status` may show the active DNS configuration on systems using `systemd-resolved`.
- DNS server and gateway addresses depend on UTM and the host environment.

If `resolvectl` is not installed or the service is not active, record that observation. You can safely review the resolver configuration with:

```bash
cat /etc/resolv.conf
```

Do not change network or DNS settings during evidence collection.

## Step 10: Review Listening Ports

Run:

```bash
ss -tuln
```

Expected observations:

- The output shows TCP and UDP sockets that are listening locally.
- A listener bound to `127.0.0.1` or `::1` is limited to the local system.
- A listener bound to all interfaces may appear as `0.0.0.0` or `::`.
- Port numbers depend on the services installed and running in the VM.

For each listener, compare the port with the running services and the intended purpose of the VM. A listening port is not automatically malicious, but an unexplained listener should be documented for review.

## Step 11: Review Installed Packages

Run either or both commands:

```bash
dpkg -l | head
apt list --installed | head
```

Expected observations:

- Each command shows only the beginning of a much longer package list.
- Package names and versions depend on the chosen distribution image and updates.
- `apt` may display an informational warning about its command-line interface.

These short views confirm that package information is available. Record packages relevant to the lab or any package whose presence needs explanation. Do not remove packages during baseline collection.

## Step 12: Record Baseline Findings

Review your notes and create a concise baseline record. Include:

- the evidence collection date and time
- hostname, architecture, kernel, and OS version
- current user and important group memberships
- recognized local user accounts
- important running processes and services
- primary interface, route, and DNS observations
- listening ports and their likely services
- notable storage, memory, uptime, or package observations
- anything unexpected that requires follow-up

Separate direct evidence from your interpretation. For example, record the port and listening address as evidence, then explain why you believe a known service opened it.

## Investigation Questions

Answer these questions using the evidence you collected:

1. Is this system really ARM64? Which command proves it?
2. Which Linux distribution and kernel version are installed?
3. Which users exist on the system, and which appear to be human login accounts?
4. Does the current user have elevated privileges? What evidence supports the answer?
5. Which services are running and why are they needed?
6. Are any listening ports unexpected for this VM?
7. Can each listening port be connected to a known service or system purpose?
8. Are the VM's interface, route, and DNS settings consistent with Shared/NAT networking?
9. What would make this baseline suspicious?
10. What evidence should be recorded before making changes?
11. Are the system time, uptime, disk use, and memory use reasonable?
12. Which observation needs the most follow-up, and why?

## Findings Report Template

Copy and complete this template without including passwords, password hashes, or unnecessary personal information:

```markdown
# ARM-SecNet Linux Baseline Findings

- System name:
- Date/time:
- Architecture:
- OS version:
- Active users:
- Running services of interest:
- Listening ports:
- Notable observations:
- Risk level: Low / Medium / High
- Recommended next action:

## Evidence Summary

- Commands used:
- Important output recorded:
- Items requiring follow-up:

## Conclusion

Write a short conclusion explaining whether this VM can be accepted as the current baseline.
```

Choose the risk level from the evidence. Explain the reason rather than assigning a level only because a service or port is unfamiliar.

## ARM64-Specific Note

On Linux, the same 64-bit ARM architecture may be labelled `aarch64` by the kernel and `arm64` by package tools or documentation. Both are expected for the ARM-SecNet VM.

Package versions, process names, and service availability can differ from x86-focused tutorials. Use the ARM64 packages supplied by the Ubuntu or Debian repositories and document architecture-related differences instead of treating them as suspicious by default.

## Completion Checklist

- [ ] System name and collection time recorded
- [ ] ARM64 architecture confirmed as `aarch64` or `arm64`
- [ ] Kernel and OS version recorded
- [ ] Current user and privileges reviewed
- [ ] Local user accounts reviewed
- [ ] Running processes and services reviewed
- [ ] Network interfaces, routes, and DNS reviewed
- [ ] Listening ports reviewed and compared with services
- [ ] Installed package information checked
- [ ] Investigation questions answered
- [ ] Findings report completed
- [ ] Unexpected observations identified for follow-up
- [ ] No unnecessary system changes made during collection

## Next Step

Save the completed findings report as the known baseline for this VM. Keep the evidence with the lab notes so it can be compared with future observations.

Continue with:

```text
docs/labs/lab-02-auth-log-analysis.md
```
