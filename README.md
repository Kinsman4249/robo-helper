# .github-private

Private home for **reusable community-health files and project templates** that get copied into Kinsman4249's public projects.

If you're looking at this because you found a link from one of those projects: this repo is intentionally private. You don't need to look here, the project you came from has its own copy of whatever document you're after.

## Quickstart

**Starting a new project?** See [VSCODE_QUICKSTART.md](./VSCODE_QUICKSTART.md) for the full step-by-step walkthrough using VS Code: create the repo, clone it, copy the templates, make your first commit, and ship your first tagged release.

## What lives here

```
.
|-- CHANGELOG.md                   - the actual changelog for this repo (not a template, real entries)
|-- CHANGELOG_TEMPLATE.md          - formatting guide for changelog entries, copy and rename to CHANGELOG.md in a new project
|-- CODE_OF_CONDUCT.md             - Contributor Covenant 2.1 + project-friendly summary
|-- CONTRIBUTING.md                - Generic contribution guide
|-- GIT_GITHUB_CHEATSHEET.md       - Practical git and GitHub command reference for everyday work
|-- SECURITY.md                    - Vulnerability reporting policy
|-- RELEASE_TEMPLATE_README.md     - How the release workflow template works
|-- VSCODE_QUICKSTART.md           - New-project lifecycle in VS Code: create to release
`-- .github/
    |-- ISSUE_TEMPLATE/
    |   |-- bug_report.md
    |   `-- feature_request.md
    |-- PULL_REQUEST_TEMPLATE.md
    |-- workflows/
    |   `-- release.yml            - this repo's OWN release workflow (packages source archives on a version tag)
    `-- workflow-templates/
        |-- release.yml            - reusable multi-language BUILD template copied into downstream code projects
        `-- release.properties.json - registers the template in GitHub's workflow picker
```

Each community-health file is written to be **project-agnostic**. Placeholders like <PROJECT_NAME>, <REPO_URL>, and <TESTING_INSTRUCTIONS> are filled in when the file is copied into a real project.

Note the two release.yml files are different. The one under .github/workflows/ is this repository's own release process; because this repo ships only text, it packages a source snapshot rather than building binaries. The one under .github/workflow-templates/ is the generic build template you copy into code projects.

## Workflow

When starting a new public repo:

1. Follow [VSCODE_QUICKSTART.md](./VSCODE_QUICKSTART.md) for the step-by-step.
2. Copy the relevant community-health files from this repo into the new repo (top-level for CODE_OF_CONDUCT.md / CONTRIBUTING.md / SECURITY.md, and .github/ for issue and PR templates).
3. Copy CHANGELOG_TEMPLATE.md into the new repo, rename it to CHANGELOG.md, and clear out the example content so the new repo starts with a real, empty changelog from day one.
4. Copy .github/workflow-templates/release.yml into your new repo at .github/workflows/release.yml.
5. Find-and-replace the placeholders.
6. Commit.

When updating a community-health policy that should apply across all projects:

1. Edit the canonical version here first.
2. Open PRs to each downstream public repo to bring them into sync.

## Why a separate private repo

GitHub natively supports a .github repo on user/org accounts that automatically applies community-health files to all public repos. That's nice in theory but couples every project to a single set of templates. Keeping these as **canonical sources you copy from** rather than **defaults that auto-apply** lets each project tweak its own templates (test commands, supported versions, etc.) without diverging from the originals here.
