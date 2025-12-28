#!/bin/bash

# Obsidian vault path
VAULT_PATH="/home/missola/Documents/base/_NewNotes"

# Claude API key (set via environment variable)
# Export it in your shell: export ANTHROPIC_API_KEY="your-key-here"
ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}"

# Check if message was provided
if [ $# -eq 0 ]; then
    echo "Usage: note <your message>"
    echo "       note --no-ai <your message>  (skip AI enhancement)"
    exit 1
fi

# Check for --no-ai flag
USE_AI=true
if [ "$1" = "--no-ai" ]; then
    USE_AI=false
    shift
fi

# Get the full message
MESSAGE="$*"

# Get current date and time
DATETIME=$(date "+%Y-%m-%d %H:%M:%S")
DATE=$(date "+%Y-%m-%d")

# Get weather info (using wttr.in for simplicity - no API key needed)
WEATHER=$(curl -s "wttr.in/?format=%C+%t" 2>/dev/null || echo "Weather unavailable")

# Function to enhance note with Claude AI
enhance_with_ai() {
    local input_message="$1"
    local weather="$2"
    local datetime="$3"

    if [ -z "$ANTHROPIC_API_KEY" ]; then
        echo ""
        return 1
    fi

    # Create the prompt for Claude
    local prompt="You are a note enhancement assistant. Take the following quick note and enhance it into a well-formatted, informative markdown note.

Instructions:
- Keep the original message's intent and information
- Add relevant context or details if the note mentions specific topics, places, or concepts
- Format it nicely with proper markdown (headers, bullet points, etc. where appropriate)
- If locations are mentioned, add brief relevant information about them
- If technical terms or concepts are mentioned, add brief explanations
- Keep it concise but informative
- Do NOT add a title (it will be added separately)
- Do NOT add date/weather (it will be added separately)
- Output ONLY the enhanced note content, no explanations

Current context:
- Date: ${datetime}
- Weather: ${weather}

Original note:
${input_message}"

    # Escape the prompt for JSON
    local escaped_prompt=$(echo "$prompt" | jq -Rs .)

    # Call Claude API
    local response=$(curl -s "https://api.anthropic.com/v1/messages" \
        -H "Content-Type: application/json" \
        -H "x-api-key: ${ANTHROPIC_API_KEY}" \
        -H "anthropic-version: 2023-06-01" \
        -d "{
            \"model\": \"claude-sonnet-4-20250514\",
            \"max_tokens\": 1024,
            \"messages\": [
                {\"role\": \"user\", \"content\": ${escaped_prompt}}
            ]
        }" 2>/dev/null)

    # Extract the text content from the response
    local enhanced=$(echo "$response" | jq -r '.content[0].text // empty' 2>/dev/null)

    if [ -n "$enhanced" ] && [ "$enhanced" != "null" ]; then
        echo "$enhanced"
        return 0
    else
        return 1
    fi
}

# Extract first few words (up to 5 words) for the title
TITLE=$(echo "$MESSAGE" | awk '{for(i=1;i<=5 && i<=NF;i++) printf "%s ", $i}' | sed 's/ *$//')
# Clean title for filename (remove special chars, replace spaces with underscores)
FILENAME_TITLE=$(echo "$TITLE" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')

# Create filename with title and timestamp
FILENAME="${FILENAME_TITLE}_${DATE}_$(date +%H%M%S).md"
FILEPATH="${VAULT_PATH}/${FILENAME}"

# Try to enhance with AI if enabled and API key is available
ENHANCED_CONTENT=""
AI_USED=false

if [ "$USE_AI" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "🤖 Enhancing note with AI..."
    ENHANCED_CONTENT=$(enhance_with_ai "$MESSAGE" "$WEATHER" "$DATETIME")
    if [ -n "$ENHANCED_CONTENT" ]; then
        AI_USED=true
    fi
fi

# Create the note content
if [ "$AI_USED" = true ]; then
    cat > "${FILEPATH}" << EOF
# ${TITLE}

**Date:** ${DATETIME}
**Weather:** ${WEATHER}

---

${ENHANCED_CONTENT}

---

<details>
<summary>Original note</summary>

${MESSAGE}

</details>

---
*Created via terminal note command (AI-enhanced)*

#terminal #ai-enhanced [[terminal]]
EOF
else
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
fi

echo "✓ Note saved to: ${FILENAME}"
echo "  Weather: ${WEATHER}"
if [ "$AI_USED" = true ]; then
    echo "  🤖 AI-enhanced: Yes"
elif [ "$USE_AI" = true ] && [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "  ⚠️  AI skipped: ANTHROPIC_API_KEY not set"
fi