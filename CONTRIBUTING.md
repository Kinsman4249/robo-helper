# Contributing to robo-helper

Thanks for considering a contribution! This is a small project and the process
is intentionally lightweight.

## How to report a bug

Open an issue using the Bug report template. Please include:
- The version of this project you are running (commit SHA or release tag)
- The exact command or workflow that triggered the issue
- The full error output (redact any secrets / credentials / personal data)
- Relevant log excerpts
- Your runtime environment (OS, language version, deployment target, etc.)

## How to propose a feature

Open an issue using the Feature request template. Describe the use case before
the implementation. Knowing why is more useful than what in early discussion.

## How to submit a change

- Fork the repo and create a feature branch (git checkout -b feat/short-description).
- Make your change. Keep changes focused, one logical change per PR.
- Test it. Run robocopy-batch.cmd from an elevated Command Prompt or PowerShell. Enter a throwaway destination such as a temp folder, then enter one or two source paths. Confirm the files are copied, the combined timestamped log appears in the destination, and that running the script without elevation exits with the admin error.
- Lint it. Run any project-specific linters or formatters before pushing.
- Update documentation. If your change alters user-visible behavior, update the
  README and add a new numbered entry to CHANGELOG.md under the current round.
- Open a PR against main. Fill in the PR template.

## Coding conventions

- Follow the style of the surrounding code. Match formatting, naming, and
  structure of existing files.
- Comments should explain why, not what. The diff already shows what.
- No new dependencies without strong justification. The appeal of small projects
  is the small, predictable surface area.
- No telemetry, ever. This project must not phone home.

## Commit messages

Conventional Commits style is preferred but not required:
- feat: add support for X
- fix: handle empty response from Y
- docs: clarify setup for Z

Keep the subject under 72 characters. Add a body if the change is not obvious
from the diff.

## Releases

Maintainers cut releases by tagging vX.Y.Z on main. Pre-1.0 versioning rules:
- 0.X.0 for any user-visible change
- 0.X.Y for bug-fix-only patch releases

After 1.0, standard SemVer applies.
