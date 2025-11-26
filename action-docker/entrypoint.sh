#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Docker Action Entrypoint Script
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# This script is the entrypoint for the Docker container action.
# It receives arguments from action.yml and processes them.
#
# Key Concepts:
# • Runs inside an isolated container
# • Receives args as $1, $2, $3, etc.
# • Has access to GITHUB_* environment variables
# • Outputs via GITHUB_OUTPUT file
# • Complete control over the environment
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Strict error handling
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ANSI COLOR CODES (for pretty output)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# READ INPUT ARGUMENTS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Arguments are passed from action.yml in order
MESSAGE="${1:-}"           # First argument - message to process
PROCESS_TYPE="${2:-echo}"  # Second argument - processing type
COLOR_OUTPUT="${3:-true}"  # Third argument - whether to use colors

# Validate required arguments
if [ -z "$MESSAGE" ]; then
  echo "::error::MESSAGE argument is required"
  exit 1
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# HELPER FUNCTIONS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Function to print colored output
print_colored() {
  local color=$1
  local message=$2
  if [ "$COLOR_OUTPUT" = "true" ]; then
    echo -e "${color}${message}${NC}"
  else
    echo "$message"
  fi
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# EDUCATIONAL OUTPUT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_colored "$CYAN$BOLD" "🎓 DOCKER CONTAINER ACTION: What's happening?"
print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_colored "$GREEN" "✨ This is a DOCKER CONTAINER ACTION - fully isolated!"
echo ""
print_colored "$YELLOW" "📚 Key Concepts:"
echo "   • Runs in an isolated Docker container"
echo "   • Complete control over the environment"
echo "   • Can use any language or tool"
echo "   • Alpine Linux base (minimal, secure, fast)"
echo "   • Arguments passed from action.yml"
echo "   • Access to GitHub context via environment variables"
echo ""
print_colored "$YELLOW" "🔍 Why use Docker actions?"
echo "   • Need specific tool versions (e.g., Python 3.8)"
echo "   • Complex system dependencies"
echo "   • Language other than JavaScript (Go, Python, Ruby, etc.)"
echo "   • Maximum isolation and security"
echo "   • Consistent environment across runners"
echo ""
print_colored "$YELLOW" "⚖️  Trade-offs:"
echo "   ✅ Complete environment control"
echo "   ✅ Can use any language/tool"
echo "   ✅ Maximum isolation"
echo "   ⚠️  Slower startup (container overhead)"
echo "   ⚠️  Larger repository size (if Dockerfile is complex)"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DISPLAY CONTAINER ENVIRONMENT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_colored "$CYAN$BOLD" "🐳 Container Environment Information:"
print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Display OS information
print_colored "$BLUE" "Operating System:"
cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2
echo ""

# Display available tools (installed in Dockerfile)
print_colored "$BLUE" "Installed Tools:"
echo "   • Bash: $(bash --version | head -n 1)"
echo "   • curl: $(curl --version | head -n 1)"
echo "   • jq: $(jq --version)"
echo ""

# Display GitHub Actions environment variables
print_colored "$BLUE" "GitHub Context (from environment):"
echo "   • Workspace: ${GITHUB_WORKSPACE:-not set}"
echo "   • Action: ${GITHUB_ACTION:-not set}"
echo "   • Actor: ${GITHUB_ACTOR:-not set}"
echo "   • Repository: ${GITHUB_REPOSITORY:-not set}"
echo "   • Event: ${GITHUB_EVENT_NAME:-not set}"
echo "   • Workflow: ${GITHUB_WORKFLOW:-not set}"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DISPLAY INPUTS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_colored "$CYAN$BOLD" "📥 Inputs Received:"
print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "   message: \"$MESSAGE\""
echo "   process-type: \"$PROCESS_TYPE\""
echo "   color-output: \"$COLOR_OUTPUT\""
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PROCESS THE MESSAGE
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_colored "$CYAN$BOLD" "🔧 Processing Message..."
print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Process based on type
case "$PROCESS_TYPE" in
  echo)
    RESULT="$MESSAGE"
    print_colored "$GREEN" "📤 Echo mode: Returning message as-is"
    ;;
  
  reverse)
    RESULT=$(echo "$MESSAGE" | rev)
    print_colored "$GREEN" "🔄 Reverse mode: Reversed the message"
    ;;
  
  count)
    CHAR_COUNT=${#MESSAGE}
    WORD_COUNT=$(echo "$MESSAGE" | wc -w | tr -d ' ')
    RESULT="Characters: $CHAR_COUNT, Words: $WORD_COUNT"
    print_colored "$GREEN" "📊 Count mode: Counted characters and words"
    ;;
  
  uppercase)
    RESULT=$(echo "$MESSAGE" | tr '[:lower:]' '[:upper:]')
    print_colored "$GREEN" "⬆️  Uppercase mode: Converted to uppercase"
    ;;
  
  lowercase)
    RESULT=$(echo "$MESSAGE" | tr '[:upper:]' '[:lower:]')
    print_colored "$GREEN" "⬇️  Lowercase mode: Converted to lowercase"
    ;;
  
  *)
    print_colored "$YELLOW" "⚠️  Unknown process type '$PROCESS_TYPE', defaulting to echo"
    RESULT="$MESSAGE"
    ;;
esac

echo ""
print_colored "$PURPLE" "Result: $RESULT"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SET OUTPUTS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Generate timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Create container info JSON
CONTAINER_INFO=$(cat <<EOF
{
  "os": "$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2)",
  "shell": "$(bash --version | head -n 1)",
  "process_type": "$PROCESS_TYPE",
  "pwd": "$(pwd)"
}
EOF
)

# Set outputs using GITHUB_OUTPUT
# GITHUB_OUTPUT is a special file path provided by GitHub Actions
# Format: <output-name>=<value>
# For multiline values, use EOF delimiters

print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_colored "$CYAN$BOLD" "📤 Setting Outputs:"
print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if GITHUB_OUTPUT is set (it should be in GitHub Actions)
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "result=$RESULT" >> "$GITHUB_OUTPUT"
  echo "timestamp=$TIMESTAMP" >> "$GITHUB_OUTPUT"
  echo "container-info=$CONTAINER_INFO" >> "$GITHUB_OUTPUT"
  print_colored "$GREEN" "   ✓ result"
  print_colored "$GREEN" "   ✓ timestamp"
  print_colored "$GREEN" "   ✓ container-info"
else
  echo "⚠️  GITHUB_OUTPUT not set (running outside GitHub Actions)"
  echo "Outputs would be:"
  echo "   result=$RESULT"
  echo "   timestamp=$TIMESTAMP"
  echo "   container-info=$CONTAINER_INFO"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# WRAP UP
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_colored "$GREEN$BOLD" "✅ Docker Container Action Complete!"
print_colored "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_colored "$YELLOW" "💡 What you learned:"
echo "   ✓ How Docker actions run in isolated containers"
echo "   ✓ How to pass arguments from action.yml"
echo "   ✓ How to access GitHub environment variables"
echo "   ✓ How to set outputs from a shell script"
echo "   ✓ How to use Alpine Linux for minimal images"
echo ""
print_colored "$BLUE" "🎯 Next: See how a workflow orchestrates all three action types!"
echo ""

# Exit successfully
exit 0
