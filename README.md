# robo-helper

An interactive Windows batch script that runs robocopy jobs with backup-mode
defaults. It detects the machine's logical processor count for the /MT thread
count, prompts for a list of source paths and a destination folder, requires an
elevated prompt, and writes a single combined timestamped log to the destination
while mirroring output to the console. Source and destination can also be passed
as command-line flags for non-interactive runs.

## What it does

- Requires an elevated (Administrator) prompt and exits if it is not elevated.
- Accepts -source/-s and -dest/-d command-line flags; anything supplied on the
  command line skips the matching prompt.
- Strips surrounding double quotes from pasted paths, so paths copied from
  Windows Explorer (Copy as path / shift-right-click) work whether quoted or not.
- Detects logical processors via NUMBER_OF_PROCESSORS and clamps /MT to the
  valid 1-128 range.
- Prompts for source paths first (one per line, blank line ends), matching
  robocopy's source-then-destination order.
- Prompts for a destination base folder next (re-prompts if blank, strips a
  trailing backslash), then creates it if it does not exist.
- Runs one robocopy job per source, preserving the source path minus its drive
  letter under the destination (for example C:\updates copies to <DEST>\updates).
- Writes a combined log named robocopy_<timestamp>.log in the destination and
  mirrors output to the console with /TEE.

## Requirements

- Windows (robocopy ships with Windows, no install needed).
- An elevated prompt. Backup mode (/B) needs the backup privilege.

## Usage (local)

Download robocopy-batch.cmd, then run it from an elevated Command Prompt or
PowerShell. With no arguments it prompts for source paths first, then the
destination.

Per-job flags used:

```
/B /E /XJ /XA:S /XF *.ost /R:0 /W:0 /MT:<threads> /TEE /LOG+:<logfile>
```

- /B      Backup mode (uses the backup privilege).
- /E      Copy subdirectories including empty ones.
- /XJ     Exclude junction points (prevents recursion loops).
- /XA:S   Exclude System files and folders (hidden files are still copied).
- /XF *.ost  Skip Outlook OST cache files.
- /R:0 /W:0  No retries, no wait on failures.
- /MT     Multithreaded copy, thread count set to the detected processor count.
- /TEE    Mirror output to console and log at the same time.
- /LOG+   Append every job to one combined log file.

Note: /COPY and /DCOPY are left at robocopy defaults (/COPY:DAT and /DCOPY:DA),
which copy Data, Attributes, and Timestamps. ACLs, owner, and auditing are not
copied. Add /COPY:DATSOU /DCOPY:DAT if you need those preserved.

## Command-line usage

The script accepts flags so it can run without prompts:

```
robocopy-batch.cmd [-source PATH] [-dest PATH]
```

- -source, -s   Source path. Repeat the flag to queue multiple sources.
- -dest,   -d   Destination base folder.
- -help,   -h   Show usage.

Paths may be quoted or unquoted; surrounding quotes are stripped automatically,
so values pasted from Explorer work as-is.

Examples:

```
REM Fully non-interactive, two sources
robocopy-batch.cmd -source "C:\Data_Bin" -source "C:\temp" -dest "D:\backup"

REM Source only; the destination is prompted
robocopy-batch.cmd -s "C:\updates"
```

If -source is omitted the script prompts for source paths first, then the
destination, matching robocopy's argument order. A flag given without a value
prints an error and usage; unknown arguments are reported and skipped.

## Run from PowerShell (download and run)

For flexible deployment you can pull the script straight from GitHub and run it
without cloning the repo. The script is a Windows batch file (.cmd), so it runs
through cmd.exe. PowerShell execution policy does not apply to .cmd files, so no
-ExecutionPolicy Bypass flag is needed here. The script performs its own
elevation check and will exit if it is not run as Administrator, so launch it
from an elevated PowerShell window.

Note: `irm | iex` does not work for this script. That idiom pipes text into the
PowerShell parser, and a batch file is not PowerShell. Download to disk first,
then hand the file to cmd.exe as shown below.

### One-line (elevated PowerShell)

```powershell
$f = "$env:TEMP\\robocopy-batch.cmd"; irm 'https://raw.githubusercontent.com/Kinsman4249/robo-helper/main/robocopy-batch.cmd' -OutFile $f; & $env:ComSpec /c $f
```

### Multi-line (same thing, easier to read)

```powershell
# Download the script to the temp folder
$f = Join-Path $env:TEMP 'robocopy-batch.cmd'
Invoke-RestMethod 'https://raw.githubusercontent.com/Kinsman4249/robo-helper/main/robocopy-batch.cmd' -OutFile $f

# Run it through cmd.exe. The script prompts for source paths, then destination.
& $env:ComSpec /c $f
```

### Notes and gotchas (PowerShell method)

- Run from an elevated (Administrator) PowerShell. The script requires the admin
  token for backup mode (/B) and exits with an error if it is not elevated.
- Adjust the branch or tag in the URL if you are not tracking main (for example
  a pinned release tag like v1.0.0 instead of main).
- Verify the source before running. Downloading and executing a remote script
  means trusting this repo and the TLS connection to raw.githubusercontent.com.
  This is the same delivery pattern used by malware, so only run scripts whose
  source you control or have reviewed.
- The downloaded file lands in %TEMP%. Delete it afterward if you do not want it
  left on the machine.

## Notes and gotchas

- Drive-letter source paths only. UNC paths like \\server\share do not map
  cleanly under the drive-letter-strip logic.
- Paths containing an exclamation mark break under delayed expansion.
- The timestamp uses wmic os get LocalDateTime. WMIC is deprecated and removed
  on some newer Windows builds. If WMIC is absent the log is named
  robocopy_.log with no timestamp; the copy still runs.
- /XA:S excludes any file with the System attribute regardless of its Hidden
  attribute, so files that are both System and Hidden are still skipped. Only
  files that are Hidden but not System are now copied.

## Contributing

See CONTRIBUTING.md. Report bugs and request features through the issue
templates. Security issues go through the process in SECURITY.md, not public
issues.

## Changelog

See CHANGELOG.md.
