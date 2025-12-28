# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NoteOb is a bash script that creates timestamped markdown notes directly in an Obsidian vault from the command line. Notes include weather data fetched from wttr.in and optional AI enhancement via Claude API.

## Architecture

Single-file bash script (`note.sh`) that:
1. Takes a message as command-line arguments
2. Generates a filename from first 5 words + date/time
3. Fetches current weather from wttr.in
4. Optionally enhances note content via Claude API (adds context, formatting, explanations)
5. Writes a formatted markdown file to the configured vault path

## Configuration

The vault path is hardcoded in `note.sh`:
```bash
VAULT_PATH="/home/missola/Documents/base/_NewNotes"
```

For AI enhancement, set the API key as an environment variable:
```bash
export ANTHROPIC_API_KEY="your-key-here"
```

## Usage

```bash
./note.sh Your note message here          # With AI enhancement (if API key set)
./note.sh --no-ai Your note message here  # Skip AI enhancement
```

Or if installed globally:
```bash
note Your note message here
```

## Dependencies

- bash
- curl (for weather and Claude API)
- jq (for JSON parsing in AI enhancement)
- Standard unix utilities: awk, sed, date
