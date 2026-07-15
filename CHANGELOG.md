## Changelog

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
   drive letter under the destination and runs with /B /E /XJ /XA:SH /XF *.ost
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
   the repository ships only a batch script with nothing to compile, the
   workflow runs on a single Ubuntu runner and uses git archive to package the
   tagged commit into a .tar.gz and a .zip source snapshot, then attaches both
   to a GitHub Release with auto-generated notes.
