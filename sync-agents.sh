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
PERSONAL_DIR="$SCRIPT_DIR/personal_additions"
SUBMODULE_DIR="$SCRIPT_DIR/vscode_agents_folder/agents"
DISABLED_DIR="$SCRIPT_DIR/vscode_agents_folder/disabled"
SKILLS_DIR="$SCRIPT_DIR/vscode_agents_folder/skills"

echo -e "${BLUE}=== Agent Files Sync Script ===${NC}"
echo ""

# Check if plugins directory exists
if [ ! -d "$PLUGINS_DIR" ]; then
    echo -e "${RED}Error: plugins directory not found at $PLUGINS_DIR${NC}"
    exit 1
fi

# Check if submodule agents directory exists
if [ ! -d "$SUBMODULE_DIR" ]; then
    echo -e "${YELLOW}Creating agents directory in submodule...${NC}"
    mkdir -p "$SUBMODULE_DIR"
fi

# Create disabled directory if it doesn't exist
if [ ! -d "$DISABLED_DIR" ]; then
    echo -e "${YELLOW}Creating disabled directory in submodule...${NC}"
    mkdir -p "$DISABLED_DIR"
fi

# Create skills directory if it doesn't exist
if [ ! -d "$SKILLS_DIR" ]; then
    echo -e "${YELLOW}Creating skills directory in submodule...${NC}"
    mkdir -p "$SKILLS_DIR"
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

# Also check disabled folders in plugins
find "$PLUGINS_DIR" -type f -path "*/disabled/*.md" -print0 | while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    # Only add if not already in index (prefer non-disabled version)
    if ! grep -q "^$filename|" "$temp_index" 2>/dev/null; then
        echo "$filename|$file" >> "$temp_index"
    fi
done

# Add files from personal_additions/agents folder
if [ -d "$PERSONAL_DIR/agents" ]; then
    find "$PERSONAL_DIR/agents" -type f -name "*.agent.md" -print0 | while IFS= read -r -d '' file; do
        filename=$(basename "$file")
        # Personal additions take precedence, so replace any existing entry
        if grep -q "^$filename|" "$temp_index" 2>/dev/null; then
            grep -v "^$filename|" "$temp_index" > "${temp_index}.tmp" && mv "${temp_index}.tmp" "$temp_index"
        fi
        echo "$filename|$file" >> "$temp_index"
    done
fi

total_indexed=$(wc -l < "$temp_index" | tr -d ' ')
echo -e "${GREEN}Indexed $total_indexed agent files from plugins and personal_additions folders${NC}"
echo ""

echo -e "${BLUE}Updating matching agent files...${NC}"

# Update only the agents that exist in submodule
updated=0
skipped=0
not_found=0

for submodule_file in "${submodule_files[@]}"; do
    filename=$(basename "$submodule_file")
    
    # First try exact match (for personal_additions files that already have .agent.md)
    source_file=$(grep "^$filename|" "$temp_index" 2>/dev/null | cut -d'|' -f2 | head -1)
    
    # If not found, strip .agent.md and add just .md to search for the source file
    if [[ -z "$source_file" ]]; then
        base_name="${filename%.agent.md}"
        if [[ "$filename" == *.agent.md ]]; then
            search_name="${base_name}.md"
            source_file=$(grep "^$search_name|" "$temp_index" 2>/dev/null | cut -d'|' -f2 | head -1)
        fi
    fi
    
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

# Update model names in all agent files
echo -e "${BLUE}=== Updating Model Names ===${NC}"

model_updates=0
for file in "$SUBMODULE_DIR"/*.md; do
    if [ -f "$file" ]; then
        changed=false
        
        # Check and replace model: sonnet
        if grep -q "^model: sonnet" "$file"; then
            sed -i '' 's/^model: sonnet$/model: Claude Sonnet 4.5/' "$file"
            changed=true
        fi
        
        # Check and replace model: opus
        if grep -q "^model: opus" "$file"; then
            sed -i '' 's/^model: opus$/model: Claude Opus 4.5/' "$file"
            changed=true
        fi
        
        # Check and replace model: haiku
        if grep -q "^model: haiku" "$file"; then
            sed -i '' 's/^model: haiku$/model: Claude Haiku 4.5/' "$file"
            changed=true
        fi
        
        if [ "$changed" = true ]; then
            ((model_updates++))
            echo -e "${GREEN}  ✓ Updated model names in: $(basename "$file")${NC}"
        fi
    fi
done

if [ $model_updates -eq 0 ]; then
    echo -e "${YELLOW}No model name updates needed${NC}"
else
    echo -e "${GREEN}Updated model names in $model_updates files${NC}"
fi
echo ""

# Add new agents to disabled folder
echo -e "${BLUE}=== Adding New Agents to Disabled Folder ===${NC}"

new_agents=0
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    base_name="${filename%.md}"
    target_name="${base_name}.agent.md"
    
    # Check if this agent already exists in agents folder or disabled folder
    if [ ! -f "$SUBMODULE_DIR/$target_name" ] && [ ! -f "$DISABLED_DIR/$target_name" ]; then
        cp "$file" "$DISABLED_DIR/$target_name"
        ((new_agents++))
        
        # Update model names in the newly added file
        sed -i '' 's/^model: sonnet$/model: Claude Sonnet 4.5/' "$DISABLED_DIR/$target_name"
        sed -i '' 's/^model: opus$/model: Claude Opus 4.5/' "$DISABLED_DIR/$target_name"
        sed -i '' 's/^model: haiku$/model: Claude Haiku 4.5/' "$DISABLED_DIR/$target_name"
        
        # Only show every 10th file to avoid spam
        if [ $((new_agents % 10)) -eq 0 ]; then
            echo -e "${GREEN}  Added $new_agents new agents...${NC}"
        fi
    fi
done < <(find "$PLUGINS_DIR" -type f -path "*/agents/*.md" -print0)

if [ $new_agents -eq 0 ]; then
    echo -e "${YELLOW}No new agents to add${NC}"
else
    echo -e "${GREEN}Added $new_agents new agents to disabled folder${NC}"
fi
echo ""

# Add SKILL.md files to skills folder
echo -e "${BLUE}=== Syncing Skills Folders ===${NC}"

new_skills=0
updated_skills=0

# Find all skills directories and copy them over
while IFS= read -r -d '' skills_parent; do
    # skills_parent is like /path/to/plugins/payment-processing/skills
    # We want to copy each subdirectory inside it
    if [ -d "$skills_parent" ]; then
        for skill_dir in "$skills_parent"/*/; do
            if [ -d "$skill_dir" ]; then
                skill_name=$(basename "$skill_dir")
                target_dir="$SKILLS_DIR/$skill_name"
                
                if [ ! -d "$target_dir" ]; then
                    # New skill folder
                    cp -r "$skill_dir" "$target_dir"
                    ((new_skills++))
                    echo -e "${GREEN}  ✓ Added: $skill_name/${NC}"
                else
                    # Update existing skill folder if different
                    if ! diff -qr "$skill_dir" "$target_dir" > /dev/null 2>&1; then
                        cp -r "$skill_dir"/* "$target_dir/"
                        ((updated_skills++))
                        echo -e "${GREEN}  ✓ Updated: $skill_name/${NC}"
                    fi
                fi
            fi
        done
    fi
done < <(find "$PLUGINS_DIR" -type d -name "skills" -print0)

# Also sync custom skills from personal_additions
if [ -d "$PERSONAL_DIR/skills" ]; then
    for skill_dir in "$PERSONAL_DIR/skills"/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            target_dir="$SKILLS_DIR/$skill_name"
            
            if [ ! -d "$target_dir" ]; then
                # New personal skill folder
                cp -r "$skill_dir" "$target_dir"
                ((new_skills++))
                echo -e "${GREEN}  ✓ Added (personal): $skill_name/${NC}"
            else
                # Update existing personal skill folder if different
                if ! diff -qr "$skill_dir" "$target_dir" > /dev/null 2>&1; then
                    cp -r "$skill_dir"/* "$target_dir/"
                    ((updated_skills++))
                    echo -e "${GREEN}  ✓ Updated (personal): $skill_name/${NC}"
                fi
            fi
        fi
    done
fi

if [ $new_skills -eq 0 ] && [ $updated_skills -eq 0 ]; then
    echo -e "${YELLOW}No new or updated skills${NC}"
else
    if [ $new_skills -gt 0 ]; then
        echo -e "${GREEN}Added $new_skills new skill folders${NC}"
    fi
    if [ $updated_skills -gt 0 ]; then
        echo -e "${GREEN}Updated $updated_skills existing skill folders${NC}"
    fi
fi
echo ""

# Check for git changes
cd "$SCRIPT_DIR/vscode_agents_folder"
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
