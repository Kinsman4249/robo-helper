# Changelog

This file tracks real changes to this repository. For the rules on how entries here should be written, see CHANGELOG_TEMPLATE.md.

### Initial template set (round one)

1. Created the repository as an empty private repo with the default auto-generated README.
2. Replaced the auto-generated README with a templates index describing what the repo is for and how to use it.
3. Added a generic Code of Conduct template based on Contributor Covenant 2.1, with a project-agnostic placeholder for the repo URL.
4. Added a generic Contributing guide template covering bug reports, feature requests, PR submission steps, and pre-1.0 versioning rules.
5. Added a generic Security policy template covering vulnerability reporting through GitHub Security Advisories.
6. Added a generic bug report issue template with sections for environment details, reproduction steps, and log output.
7. Added a generic feature request issue template that asks for the use case before the proposed solution.
8. Added a generic pull request template with sections for summary, type of change, testing, and documentation.

### Release tooling (round two)

9. Added the tag-driven release workflow template (release.yml) plus its registration file (release.properties.json) so it appears in GitHub's workflow picker, along with a README explaining how to wire it into a new project and customize the build matrix.
10. Added a full VS Code walkthrough guide covering the entire project lifecycle, from creating a new repo through cloning, adding the release workflow, committing, and tagging a first release, with cross-links added to the release template README.

### Security policy variant and command reference (round three)

11. Added a post-1.0 variant of the security policy, narrowing support to only the newest major release line once a project matures past its initial 0.x versions.
12. Added a Git and GitHub cheatsheet covering the daily solo workflow, the full PR-based workflow, merge strategies, tagging, releases, and common recovery commands for mistakes.

### Formatting cleanup (round four)

13. Cleaned up non-ASCII characters across the markdown files, replacing smart quotes, em dashes, and similar characters with plain ASCII equivalents for consistency and portability.

### Changelog system and documentation fixes (round five)

14. Added a changelog formatting guide as a reusable template, later renamed to CHANGELOG_TEMPLATE.md so it would not be mistaken for an actual changelog.
15. Added this changelog file, with entries reconstructed from the repository's commit history.
16. Updated the README's file index to include the changelog files and the Git and GitHub cheatsheet, which existed in the repo but were missing from the documented file tree, and added a line to the workflow section instructing that every new project should get its own changelog copied from the template.
17. Merged the post-1.0 security policy variant into a single SECURITY.md, since backporting fixes across major versions is not the normal workflow for these projects. The default policy is now simply: only the latest release receives fixes, regardless of version number. The separate post-1.0 file was removed.
18. Corrected references to CHANGELOG.md in CONTRIBUTING.md, PULL_REQUEST_TEMPLATE.md, and GIT_GITHUB_CHEATSHEET.md, which had assumed the Keep a Changelog format (an [Unreleased] section with version-numbered headers) instead of the round-based numbered format this repo actually uses. Also corrected a handful of remaining em dash characters in README.md and GIT_GITHUB_CHEATSHEET.md that the earlier ASCII cleanup round had missed.
19. Deleted SECURITY-POST-1.0.md, which had been left in the repository after its content was merged into SECURITY.md the previous round. Its presence contradicted the current security policy, since it still described the old multi-major-version support window.

### Repository release automation (round six)

20. Added .github/workflows/release.yml, this repository's own release workflow, which is separate from the multi-language build template kept under .github/workflow-templates/. Because the repository ships only markdown and template files with nothing to compile, the workflow does not build binaries. It runs on a single Ubuntu runner and uses git archive to package the tagged commit into a .tar.gz and a .zip source snapshot, then attaches both to a GitHub Release with auto-generated notes.
21. Scoped the workflow permissions to read-only by default and elevated only the release job to contents write, so the token holds the minimum access needed to publish. Added a concurrency group keyed on the tag so a re-pushed tag cannot race an in-progress publish, configured so an in-flight run is not cancelled.
22. Set the release step to fail when its file glob matches nothing, so a broken archive step cannot silently publish an empty release. The workflow triggers on tags matching the v pattern with three number segments and also supports a manual workflow_dispatch run that takes an existing tag name.
23. Updated the README file tree to add the .github/workflows/ directory and to note the distinction between this repository's own release workflow and the reusable release template kept under .github/workflow-templates/.

### Attribute exclusion change (round two)
5. Changed the robocopy attribute exclusion in robocopy-batch.cmd from /XA:SH to /XA:S so that only System-attributed files are skipped and Hidden files are now copied. This affects every per-job robocopy invocation. Updated README.md to match, changing the flag reference in the usage block and rewording the flag description to state that hidden files are still copied.
