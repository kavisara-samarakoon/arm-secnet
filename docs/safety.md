# Safety Rules

ARM-SecNet is a defensive cybersecurity and networking lab toolkit.

The project is designed for safe learning, local lab testing, and defensive investigation practice only.

## Allowed Activities

ARM-SecNet may be used for:

- setting up an ARM64 Linux lab VM
- learning Linux system visibility
- checking local users, services, ports, and logs
- reviewing authentication logs
- practicing defensive investigation
- writing security findings reports
- testing inside an isolated local lab environment

## Not Allowed

ARM-SecNet must not be used for:

- scanning public targets
- attacking real systems
- exploiting unauthorized machines
- collecting real credentials
- phishing
- malware development
- persistence payloads
- destructive automation
- bypassing security controls
- illegal or harmful activity

## Lab Boundary

All activities should stay inside the local lab environment.

For Version 1, the recommended setup is:

```text
MacBook Apple Silicon Host
        ↓
UTM Shared/NAT Network
        ↓
ARM64 Linux Security VM
```
