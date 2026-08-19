# Lab 02 — Authentication Log Analysis

**Defensive security labs for Apple Silicon — from zero setup to first investigation.**

## Lab Purpose

This lab introduces defensive authentication log analysis on the ARM-SecNet V1 Linux VM. Authentication records help an analyst understand who accessed a system, when access occurred, whether attempts failed, and when administrative privileges were used.

The goal is to review existing evidence and report what it shows. Do not create suspicious activity or change the system to produce events.

## Learning Outcome

After completing this lab, the learner should be able to:

- locate authentication records on Ubuntu or Debian
- review recent login activity
- distinguish failed attempts from successful events
- review recorded `sudo` usage
- compare usernames in logs with known local accounts
- identify patterns that require further defensive investigation
- preserve important context in a short findings report

## Required Environment

You need:

- an Apple Silicon Mac with UTM installed
- one ARM64 Linux Security VM
- Ubuntu Server ARM64 or Debian ARM64
- UTM Shared/NAT networking
- a lab account with permission to read system logs using `sudo`
- a terminal inside the VM
- completed notes from Lab 01, if available
- a text file or notebook for recording evidence

Log contents depend on the distribution, installed services, and activity that has occurred. It is normal for a new VM to contain only a small number of authentication events.

## Safety Scope

This is a read-only defensive review of authentication evidence on your own ARM-SecNet VM.

You may:

- read local authentication logs
- review existing login history and current sessions
- compare recorded usernames with local accounts
- document relevant events and observations

Do not attempt passwords, create failed logins for testing, collect credentials, scan public targets, exploit systems, install malware, create persistence, or inspect a system without authorization. Keep the VM on UTM Shared/NAT networking.

## Investigation Scenario

You are reviewing the ARM-SecNet Linux Security VM after its baseline was recorded. Your task is to determine whether the available authentication activity is consistent with expected lab use.

You need to establish:

1. which log source contains authentication events
2. whether recent logins belong to expected users
3. whether failed attempts form a concerning pattern
4. whether administrative commands were run by the expected user
5. which evidence must be preserved for follow-up

Record observations before making any changes to accounts, services, or logs.

## Step 1: Identify Authentication Log Location

Ubuntu and Debian commonly store authentication events in:

```text
/var/log/auth.log
```

Try reviewing the most recent entries:

```bash
sudo tail -n 50 /var/log/auth.log
```

Expected observations:

- Recent events appear in time order, with the newest entries near the end.
- Entries may include a timestamp, hostname, process name, process ID, username, and event message.
- The exact fields and messages depend on the distribution and active services.
- A permission error indicates that elevated read access is required.
- A file-not-found message may mean the system stores these events in the systemd journal instead.

Some distributions or configurations use `journalctl`. If `/var/log/auth.log` is not available, use:

```bash
sudo journalctl -u ssh
sudo journalctl | grep -i authentication
```

Expected observations:

- The first command shows journal entries for the SSH service when that service and unit exist.
- The second command filters journal messages containing the word `authentication`.
- No matching output does not by itself prove that authentication activity is missing or suspicious.
- Service unit names and log wording can differ between installations.

Record whether the primary log source is `/var/log/auth.log`, the systemd journal, or both. Use the source that is available for the remaining steps.

## Step 2: Review Recent Login Activity

Start with these commands to review users who are currently signed in. They are safe defaults on Ubuntu and Debian:

```bash
who
w
```

### Compatibility Note

On some newer systems, including Ubuntu 26.04 ARM64, `last` and the older `lastlog` command may not be installed by default. If you want to review recorded login history, you can optionally install the package suggested by Ubuntu and then run `last`:

```bash
sudo apt install wtmpdb
last
```

On systems that provide it, use `lastlog2` instead of the older `lastlog` command:

```bash
lastlog2
```

Expected observations:

- `who` shows current login sessions.
- `w` adds session activity and basic system load information.
- `last` shows recorded login and logout history, including reboots on many systems.
- `lastlog2` shows the most recent recorded login for local accounts; many service accounts may show that they have never logged in.
- A command may show little or no output on a newly installed VM.

Record expected usernames, session times, and terminal or source fields that are relevant to the lab. Do not assume that every reboot entry or account with no login is suspicious.

## Step 3: Review Failed Login Attempts

If the VM uses `/var/log/auth.log`, run:

```bash
sudo grep -i "failed" /var/log/auth.log
```

If the VM uses the systemd journal, use the available journal source and filter:

```bash
sudo journalctl | grep -i "failed"
```

Expected observations:

- There may be no matching entries on a new or lightly used VM.
- A failed entry may identify a time, account name, authentication component, and source context.
- A single known typing mistake has different significance from repeated failures involving unfamiliar users or times.
- `failed` is a broad search term and can return general service failures or other non-login messages.
- Read the source or service named in each full log line before classifying it as a failed login attempt.

Record the number and timing of relevant failures, the usernames involved, and whether the activity has a known explanation. Do not reproduce failed login activity.

## Step 4: Review Successful Login Events

For SSH success messages in `/var/log/auth.log`, run:

```bash
sudo grep -i "accepted" /var/log/auth.log
```

If `/var/log/auth.log` is unavailable, review the SSH journal:

```bash
sudo journalctl -u ssh
```

Also compare the results with:

```bash
last
```

Expected observations:

- The word `accepted` is commonly associated with successful SSH authentication, so there may be no matches if SSH is not installed or used.
- Local console logins may appear through session or PAM messages rather than as `accepted` entries.
- `last` may provide login history even when the text search returns no matches.
- Successful events should match known users, expected times, and the way the VM is normally accessed.

Record successful events that are relevant to the investigation. Treat an unexplained successful login as more important than a normal event that matches the learner's activity.

## Step 5: Review Sudo Usage

If the VM uses `/var/log/auth.log`, run:

```bash
sudo grep -i "sudo" /var/log/auth.log
```

If the VM uses the systemd journal, run:

```bash
sudo journalctl | grep -i "sudo"
```

Expected observations:

- Entries may identify the user who invoked `sudo`, the working directory, the target user, and the command.
- Normal setup, update, and lab commands may appear.
- Output varies according to the distribution's logging configuration and log retention.
- A search can include messages that mention `sudo` without representing a completed administrative action.

Compare the recorded user, time, and command with authorized lab activity. Be careful when copying evidence because a command line could contain private paths or other sensitive values.

## Step 6: Review User Accounts

List accounts known to the system:

```bash
getent passwd
```

Confirm the current user and group membership:

```bash
id
groups
```

To review a specific username found in the logs, replace `USERNAME` with that exact local account name:

```bash
id USERNAME
groups USERNAME
```

Expected observations:

- `getent passwd` includes human users and service accounts.
- Human login accounts commonly have home directories under `/home`.
- Service accounts commonly use non-login shells.
- `id` and `groups` show whether an account exists locally and which groups it belongs to.
- An unknown username in a failed remote event may not exist as a local account.

Do not create, remove, disable, or change an account during evidence collection.

## Step 7: Identify Suspicious Patterns

Compare the events with the Lab 01 baseline and expected use of the VM. Look for patterns such as:

- repeated failed attempts close together in time
- failures involving several unfamiliar usernames
- successful logins at unexplained times
- successful activity for an account that is not part of the known baseline
- `sudo` usage by an unexpected user
- administrative commands that do not match documented lab work
- authentication events associated with an unfamiliar source or session
- gaps or inconsistencies between log sources that need explanation

A single unfamiliar line is not proof of compromise. Confirm its meaning using timestamps, usernames, service names, login history, and the known purpose of the VM.

Classify each notable observation as:

- expected and explained
- unusual but not yet confirmed as a security issue
- suspicious and requiring follow-up

## Step 8: Record Evidence

Capture basic context first:

```bash
hostname
date
uname -m
whoami
```

Then record:

- the exact log source reviewed
- the command used to retrieve each relevant event
- the complete timestamp and hostname from the event
- the username and service or process involved
- whether the event indicates failure, success, or privilege use
- the surrounding context needed to interpret the event
- why the activity is expected, unusual, or suspicious

Preserve the original wording of important log entries in private lab notes. Redact unnecessary personal information before sharing a report. Do not edit, delete, rotate, or clear the original logs.

## Investigation Questions

Answer these questions using the collected evidence:

1. Which authentication log source is available on this VM?
2. Are there repeated failed login attempts?
3. Can the failed attempts be explained by normal lab activity?
4. Are successful logins expected for the recorded users and times?
5. Are any usernames unfamiliar?
6. Do unfamiliar usernames exist as local accounts?
7. Was `sudo` used by the expected user?
8. Do the recorded administrative commands match authorized setup or lab work?
9. What would make this activity suspicious?
10. Which event has the highest priority for follow-up, and why?
11. What evidence should be captured before changing anything?
12. How does the activity compare with the Lab 01 baseline?

## Findings Report Template

Copy and complete this template without including passwords, credentials, or unnecessary personal information:

```markdown
# ARM-SecNet Authentication Log Findings

- System name:
- Date/time:
- Analyst name:
- Log source:
- Authentication events reviewed:
- Failed login observations:
- Successful login observations:
- Sudo activity observations:
- Suspicious patterns:
- Risk level: Low / Medium / High
- Recommended next action:

## Evidence Summary

- Commands used:
- Relevant timestamps:
- Usernames and services involved:
- Important log entries preserved:

## Conclusion

Write a short conclusion explaining whether the observed authentication activity is consistent with expected lab use.
```

Base the risk level on evidence and explain the reason for it. An empty search result, unfamiliar service name, or isolated failure is not enough by itself to assign a high risk level.

## ARM64-Specific Note

Authentication log formats and commands are generally the same on ARM64 and x86 Linux systems. Confirm the lab architecture with:

```bash
uname -m
```

The expected result is `aarch64` or `arm64`. Differences in available logs are usually caused by the Linux distribution, installed logging services, or system configuration rather than the ARM64 processor architecture.

## Completion Checklist

- [ ] System name, collection time, and architecture recorded
- [ ] Authentication log source identified
- [ ] Recent and current login activity reviewed
- [ ] Failed login attempts reviewed
- [ ] Successful authentication events reviewed
- [ ] `sudo` activity reviewed
- [ ] Usernames compared with known local accounts
- [ ] Suspicious patterns assessed using context
- [ ] Important evidence recorded before any changes
- [ ] Investigation questions answered
- [ ] Findings report completed
- [ ] No logs, accounts, services, or network settings changed

## Next Step

Save the completed report with the Lab 01 baseline and other ARM-SecNet notes. The two reports together provide the V1 starting point for future defensive investigations.

Review any unexplained event using trusted operating system documentation and the evidence already collected. Do not change the VM until the relevant timestamps, usernames, commands, and log entries have been recorded.
