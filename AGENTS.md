# AGENTS.md

## Cookbook Purpose

Installs/Configures aptly

## Agent Findings

* This cookbook is in an incremental modernization pass. Preserve existing public recipes and attributes unless a later full migration is explicitly selected.
* Dependency management should use `Policyfile.rb`; do not reintroduce Berkshelf.

## Known Limitations

- Aptly upstream publishes packages for Debian `bullseye`, `bookworm`, and `trixie`, plus Ubuntu `jammy` and `noble`.
- Debian 12 remains supported through June 10, 2026 in standard Debian security support and through June 30, 2028 in Debian LTS.
- Debian 13 is now current and supported by Aptly upstream, so it is included in Kitchen and CI.
- The cookbook support matrix is limited to Debian 12, Debian 13, Ubuntu 22.04, and Ubuntu 24.04.
