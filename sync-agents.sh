#!/bin/bash

# sync-agents.sh
# Synchronizes agent files from the /plugins folder to the vscode_agents_folder submodule

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLUGINS_DIR="$SCRIPT_DIR/plugins"
SUBMODULE_DIR="$SCRIPT_DIR/vscode_agents_folder"

echo -e "${BLUE}=== Agent Files Sync Script ===${NC}"
echo ""

# Check if plugins directory exists
if [ ! -d "$PLUGINS_DIR" ]; then
    echo -e "${RED}Error: plugins directory not found at $PLUGINS_DIR${NC}"
    exit 1
fi

# Check if submodule directory exists
if [ ! -d "$SUBMODULE_DIR" ]; then
    echo -e "${RED}Error: submodule directory not found at $SUBMODULE_DIR${NC}"
    echo -e "${YELLOW}Run: git submodule update --init --recursive${NC}"
    exit 1
fi

echo -e "${BLUE}Scanning submodule folder for existing agents...${NC}"

# Find all .md files in submodule (excluding README.md)
declare -a submodule_files=()
while IFS= read -r -d '' file; do
    if [[ "$(basename "$file")" != "README.md" ]]; then
        submodule_files+=("$file")
    fi
done < <(find "$SUBMODULE_DIR" -maxdepth 1 -type f -name "*.md" -print0)

echo -e "${GREEN}Found ${#submodule_files[@]} agent files in submodule to update${NC}"
echo ""

echo -e "${BLUE}Building index of all agent files in plugins folder...${NC}"

# Create a temporary file to store plugin file mappings
temp_index=$(mktemp)

# Find all .md files in plugins/*/agents/ directories
find "$PLUGINS_DIR" -type f -path "*/agents/*.md" -print0 | while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    echo "$filename|$file" >> "$temp_index"
done

# Also check disabled folders
find "$PLUGINS_DIR" -type f -path "*/disabled/*.md" -print0 | while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    # Only add if not already in index (prefer non-disabled version)
    if ! grep -q "^$filename|" "$temp_index" 2>/dev/null; then
        echo "$filename|$file" >> "$temp_index"
    fi
done

total_indexed=$(wc -l < "$temp_index" | tr -d ' ')
echo -e "${GREEN}Indexed $total_indexed agent files from plugins folder${NC}"
echo ""

echo -e "${BLUE}Updating matching agent files...${NC}"

# Update only the agents that exist in submodule
updated=0
skipped=0
not_found=0

for submodule_file in "${submodule_files[@]}"; do
    filename=$(basename "$submodule_file")
    
    # Strip .agent.md and add just .md to search for the source file
    base_name="${filename%.agent.md}"
    if [[ "$filename" == *.agent.md ]]; then
        search_name="${base_name}.md"
    else
        search_name="$filename"
    fi
    
    # Look up the source file from the index
    source_file=$(grep "^$search_name|" "$temp_index" 2>/dev/null | cut -d'|' -f2 | head -1)
    
    if [[ -n "$source_file" && -f "$source_file" ]]; then
        # Check if files are different before copying
        if ! cmp -s "$source_file" "$submodule_file"; then
            cp "$source_file" "$submodule_file"
            ((updated++))
            echo -e "${GREEN}  ✓ Updated: $filename${NC}"
        else
            ((skipped++))
        fi
    else
        echo -e "${YELLOW}  ⚠ Not found in plugins: $filename (keeping existing)${NC}"
        ((not_found++))
    fi
done

# Clean up temp file
rm -f "$temp_index"

echo ""
echo -e "${GREEN}Successfully updated $updated agent files${NC}"
if [ $skipped -gt 0 ]; then
    echo -e "${YELLOW}Skipped $skipped files (unchanged)${NC}"
fi
if [ $not_found -gt 0 ]; then
    echo -e "${YELLOW}Not found in plugins: $not_found files (kept existing)${NC}"
fi
echo ""

# Show summary
echo -e "${BLUE}=== Sync Summary ===${NC}"
echo -e "Source:      ${PLUGINS_DIR}"
echo -e "Destination: ${SUBMODULE_DIR}"
echo -e "Updated:     ${updated} agent files"
echo -e "Unchanged:   ${skipped} files"
echo -e "Not found:   ${not_found} files"
echo ""

# Check for git changes
cd "$SUBMODULE_DIR"
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}=== Git Status ===${NC}"
    git status --short
    echo ""
    echo -e "${YELLOW}Changes detected in submodule.${NC}"
    echo -e "${YELLOW}To commit and push these changes:${NC}"
    echo ""
    echo -e "  cd vscode_agents_folder"
    echo -e "  git add ."
    echo -e "  git commit -m 'Sync agent files from plugins folder'"
    echo -e "  git push"
    echo -e "  cd .."
    echo -e "  git add vscode_agents_folder"
    echo -e "  git commit -m 'Update submodule reference'"
    echo -e "  git push"
else
    echo -e "${GREEN}No changes detected. Submodule is up to date.${NC}"
fi

echo ""
echo -e "${GREEN}=== Sync Complete ===${NC}"
