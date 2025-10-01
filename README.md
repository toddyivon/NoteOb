# NoteOb

A simple command-line tool to quickly capture notes directly to your Obsidian vault from the terminal. Each note includes a timestamp, weather information, and automatic tagging.

## Features

- Quick note creation from the command line
- Automatic filename generation based on note content
- Timestamps and weather data included in each note
- Direct integration with Obsidian vaults
- Works seamlessly across Linux, macOS, and Windows

## Installation

### Linux

1. Clone the repository:
```bash
git clone https://github.com/toddyivon/NoteOb.git
cd NoteOb
```

2. Make the script executable:
```bash
chmod +x note.sh
```

3. Edit `note.sh` and update the `VAULT_PATH` variable to point to your Obsidian vault:
```bash
VAULT_PATH="/path/to/your/obsidian/vault"
```

4. Move the script to a directory in your PATH (optional, for global access):
```bash
sudo cp note.sh /usr/local/bin/note
```

Or add an alias to your shell configuration file:

**For Bash:**
```bash
echo "alias note='$(pwd)/note.sh'" >> ~/.bashrc
source ~/.bashrc
```

**For Zsh:**
```zsh
echo "alias note='$(pwd)/note.sh'" >> ~/.zshrc
source ~/.zshrc
```

### macOS

1. Clone the repository:
```bash
git clone https://github.com/toddyivon/NoteOb.git
cd NoteOb
```

2. Make the script executable:
```bash
chmod +x note.sh
```

3. Edit `note.sh` and update the `VAULT_PATH` variable to point to your Obsidian vault:
```bash
VAULT_PATH="/Users/yourusername/Documents/ObsidianVault"
```

4. Move the script to a directory in your PATH (optional, for global access):
```bash
sudo cp note.sh /usr/local/bin/note
```

Or add an alias to your shell configuration file:

**For Zsh (default on macOS Catalina and later):**
```zsh
echo "alias note='$(pwd)/note.sh'" >> ~/.zshrc
source ~/.zshrc
```

**For Bash:**
```bash
echo "alias note='$(pwd)/note.sh'" >> ~/.bash_profile
source ~/.bash_profile
```

### Windows

#### Using Git Bash or WSL

1. Clone the repository:
```bash
git clone https://github.com/toddyivon/NoteOb.git
cd NoteOb
```

2. Edit `note.sh` and update the `VAULT_PATH` variable to point to your Obsidian vault:
```bash
# For WSL
VAULT_PATH="/mnt/c/Users/YourUsername/Documents/ObsidianVault"

# For Git Bash
VAULT_PATH="/c/Users/YourUsername/Documents/ObsidianVault"
```

3. Make the script executable:
```bash
chmod +x note.sh
```

4. Add an alias to your shell configuration file:

**For Bash (Git Bash/WSL):**
```bash
echo "alias note='$(pwd)/note.sh'" >> ~/.bashrc
source ~/.bashrc
```

**For Zsh (WSL with Zsh):**
```zsh
echo "alias note='$(pwd)/note.sh'" >> ~/.zshrc
source ~/.zshrc
```

#### Using PowerShell (Alternative)

Create a PowerShell function by adding this to your PowerShell profile (`$PROFILE`):

```powershell
function note {
    $message = $args -join " "
    $vaultPath = "C:\Users\YourUsername\Documents\ObsidianVault"

    $title = ($message -split " " | Select-Object -First 5) -join " "
    $filenameTitle = $title -replace '[^a-zA-Z0-9 ]', '' -replace ' ', '_'
    $datetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $date = Get-Date -Format "yyyy-MM-dd"
    $time = Get-Date -Format "HHmmss"

    $filename = "${filenameTitle}_${date}_${time}.md"
    $filepath = Join-Path $vaultPath $filename

    $content = @"
# $title

**Date:** $datetime
**Weather:** Weather unavailable

---

$message

---
*Created via terminal note command*

#terminal [[terminal]]
"@

    $content | Out-File -FilePath $filepath -Encoding UTF8
    Write-Host "✓ Note saved to: $filename"
}
```

## Usage

Simply run the `note` command followed by your note content:

```bash
note This is my quick note about something important
```

This creates a new markdown file in your Obsidian vault with:
- Filename based on the first few words
- Current date and time
- Current weather conditions
- Your full note content
- Automatic `#terminal` tag

## Example

```bash
$ note Meeting with team about project deadline
✓ Note saved to: Meeting_with_team_about_2025-09-30_143022.md
  Weather: Clear +22°C
```

## Requirements

- Bash shell (Linux/macOS/Git Bash/WSL)
- `curl` (for weather information)
- Obsidian vault

## License

MIT License - feel free to use and modify as needed.
