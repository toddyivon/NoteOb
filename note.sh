#!/bin/bash

# Obsidian vault path
VAULT_PATH="/home/missola/Documents/base/_NewNotes"

# Check if message was provided
if [ $# -eq 0 ]; then
    echo "Usage: note <your message>"
    exit 1
fi

# Get the full message
MESSAGE="$*"

# Extract first few words (up to 5 words) for the title
TITLE=$(echo "$MESSAGE" | awk '{for(i=1;i<=5 && i<=NF;i++) printf "%s ", $i}' | sed 's/ *$//')
# Clean title for filename (remove special chars, replace spaces with underscores)
FILENAME_TITLE=$(echo "$TITLE" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')

# Get current date and time
DATETIME=$(date "+%Y-%m-%d %H:%M:%S")
DATE=$(date "+%Y-%m-%d")

# Get weather info (using wttr.in for simplicity - no API key needed)
WEATHER=$(curl -s "wttr.in/?format=%C+%t" 2>/dev/null || echo "Weather unavailable")

# Create filename with title and timestamp
FILENAME="${FILENAME_TITLE}_${DATE}_$(date +%H%M%S).md"
FILEPATH="${VAULT_PATH}/${FILENAME}"

# Create the note content
cat > "${FILEPATH}" << EOF
# ${TITLE}

**Date:** ${DATETIME}  
**Weather:** ${WEATHER}

---

${MESSAGE}

---
*Created via terminal note command*

#terminal [[terminal]]
EOF

echo "✓ Note saved to: ${FILENAME}"
echo "  Weather: ${WEATHER}"