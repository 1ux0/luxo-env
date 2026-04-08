# shared utilities
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'

print_green() {
  echo -e "${GREEN}$1${RESET}"
}

print_yellow() {
  echo -e "${YELLOW}$1${RESET}"
}

print_red() {
  echo -e "${RED}$1${RESET}"
}

print_blue() {
  echo -e "${BLUE}$1${RESET}"
}

needs_append() {
  local file="$1"
  local marker="$2"
  ! grep -qF "$marker" "$file"
}