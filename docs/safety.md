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
- documenting lab evidence safely

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

For V1, UTM Shared/NAT networking is recommended because it keeps the lab simple and reduces unnecessary exposure to the wider network.

## Evidence and Privacy

When collecting screenshots, logs, or test notes:

- avoid exposing passwords, tokens, private keys, or real credentials
- avoid publishing sensitive personal information
- review screenshots before uploading them to a public repository
- use lab-generated data where possible
- clearly separate lab evidence from real production system data

## If Unsure

If an activity could affect a system that is not owned, authorized, or clearly part of the local lab, stop and do not continue.

ARM-SecNet should remain a safe defensive learning project.
