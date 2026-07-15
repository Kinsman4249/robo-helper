# Security Policy

## Supported Versions

Only the most recent release receives security fixes, regardless of version
number. Older releases, including older major versions, are not backported.

| Version        | Supported          |
| -------------- | ------------------ |
| Latest release | :white_check_mark: |
| Anything older | :x:                |

If you need a fix and you are on an older release, upgrade to the latest release
first.

This policy assumes a solo maintainer, which is the normal setup for these
projects. If a project grows into a team effort with users who genuinely need
multiple supported release lines, this file can be adapted to add a longer
support window instead.

## Reporting a Vulnerability

If you find a security issue in this project, please do not file a public GitHub
issue.

Instead, open a private GitHub Security Advisory:
- Go to the [Security tab](https://github.com/Kinsman4249/robo-helper/security) of this repository.
- Click "Report a vulnerability".
- Provide as much detail as possible: affected version, reproduction steps,
  impact, and any suggested mitigation.

You should receive an acknowledgment within a few business days. If the issue is
confirmed, a fix will be developed privately and released as a patch version.
You will be credited in the release notes (or anonymously, if you prefer).

## Scope

In-scope:
- Vulnerabilities in any code or scripts shipped by this project
- Insecure default configurations written by this project's setup / install code
- Any path that could allow privilege escalation or unauthorized access to
  credentials managed by this project

Out of scope:
- Vulnerabilities in upstream dependencies. Please report those to the
  dependency's own maintainers.
- Vulnerabilities in third-party services this project integrates with. Report
  those to the service directly.
- General hardening suggestions for your own host or environment (use a feature
  request issue instead).
