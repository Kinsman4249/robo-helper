# Changelog

This file tracks real changes to this repository. For the rules on how entries
here should be written, see the changelog formatting guide in the
.github-private repository.

### Initial script and documentation (round one)
1. Added robocopy-batch.cmd, the interactive batch script. It requires an
   elevated prompt and exits with an error if not run as Administrator, detects
   logical processors via NUMBER_OF_PROCESSORS and clamps the /MT thread count
   to the 1-128 range robocopy accepts, prompts for a destination base folder
   and re-prompts if it is left blank, strips a trailing backslash from the
   destination for clean path joins, creates the destination if it does not
   exist, prompts for source paths one per line ending on a blank line, and runs
   one robocopy job per source. Each job preserves the source path minus its
   drive letter under the destination and runs with /B /E /XJ /XA:S /XF *.ost
   /R:0 /W:0, the detected thread count, /TEE to mirror console output, and
   /LOG+ to append all jobs into one timestamped log in the destination.
2. Added README.md documenting what the script does, its requirements, the
   per-job flags and their meanings, a note that /COPY and /DCOPY are left at
   robocopy defaults, a PowerShell download-and-run section for deployment
   without cloning the repo, and the known gotchas around UNC paths, exclamation
   marks in paths, and the deprecated WMIC timestamp source.
3. Added the community-health files copied from the .github-private repository
   with the project placeholders filled in: CODE_OF_CONDUCT.md, CONTRIBUTING.md,
   SECURITY.md, the bug report and feature request issue templates, and the pull
   request template.
4. Added .github/workflows/release.yml, a tag-driven release workflow. Because
   the repository ships only a batch script with nothing to compile, the matrix
   is trimmed to a single Ubuntu runner and the build step uses git archive to
   package the tagged commit into a .tar.gz and a .zip source snapshot, then
   attaches both to a GitHub Release with auto-generated notes.

### Attribute exclusion change (round two)
5. Changed the robocopy attribute exclusion in robocopy-batch.cmd from /XA:SH to
   /XA:S so that only System-attributed files are skipped and Hidden files are
   now copied. This affects every per-job robocopy invocation. Updated README.md
   to match, changing the flag reference in the usage block and rewording the
   flag description to note that files which are both System and Hidden are still
   skipped, since /XA:S excludes on the System attribute regardless of Hidden.

### Command-line flags and prompt order (round three)
6. Added command-line flag parsing to robocopy-batch.cmd. The script accepts
   -source (or -s), which can be repeated to queue multiple sources, and -dest
   (or -d) for the destination base folder, plus -help (-h and /?) for usage.
   Any value supplied on the command line skips its corresponding prompt, so the
   script runs fully non-interactively when both flags are given. A flag
   supplied without a value reports an error and prints usage, and unknown
   arguments are reported and skipped rather than aborting the run.
7. Reordered the interactive prompts so source paths are requested before the
   destination, matching robocopy's source-then-destination argument order. The
   destination prompt and the timestamped log path construction now run after
   the source list is collected. README.md was updated with a command-line usage
   section and the reordered prompt description.

### Quoted path handling (round four)
8. Fixed handling of quoted paths in robocopy-batch.cmd. Paths pasted from
   Windows Explorer via Copy as path or shift-right-click arrive wrapped in
   double quotes, and the interactive prompt previously stored those quotes
   verbatim. The drive-letter strip that builds each destination (removing the
   first two characters of the source) then removed the opening quote and the
   drive letter instead of the drive letter and colon, producing an invalid
   destination such as C:\test:\folder" and causing robocopy ERROR 123. The
   script now strips all double quotes from each prompted source path and from
   the prompted destination before any further processing. Command-line values
   were already unquoted by the tilde expansion, so this affects the interactive
   path only. Updated README.md to note that quoted and unquoted paths both work.

### Batch parse fix (round five)
9. Fixed a batch parse error in robocopy-batch.cmd that aborted the script
   immediately on launch. A REM comment describing the argument parser contained
   the literal text with a percent sign and tilde, and cmd expands percent
   sequences even inside REM lines, so it tried to treat that text as
   batch-parameter substitution and failed with "The following usage of the path
   operator in batch-parameter substitution is invalid". The comment was
   reworded to remove the percent sign. No executable logic changed; the genuine
   numbered-argument expansions in the parser were already valid.
