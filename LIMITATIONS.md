# Aptly Cookbook Limitations

- Aptly upstream publishes packages for Debian `bullseye`, `bookworm`, and `trixie`, plus Ubuntu `jammy` and `noble`.
- As of March 15, 2026, endoflife.date shows Debian 11 is still in LTS support through August 31, 2026, so it remains in the test matrix.
- Debian 13 is now current and supported by Aptly upstream, so it is included in Kitchen and CI.
- The cookbook support matrix is limited to Debian 11, Debian 12, Debian 13, Ubuntu 22.04, and Ubuntu 24.04 because those are the Debian-family platforms Aptly currently publishes packages for.
