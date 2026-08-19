# ARM-SecNet V1 Topology

This document explains the first ARM-SecNet lab topology.

Version 1 uses a simple single-VM topology to keep the project realistic, safe, and easy to reproduce.

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
