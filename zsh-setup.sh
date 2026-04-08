#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/luxo.conf"

echo "== zsh-setup.sh =="

# check if zsh is installed
if ! command -v zsh >/dev/null 2>&1;
then
    print_red "Error: zsh is not installed"
    exit 1
else
    zsh --version
    if [[ "$(which zsh)" != "${SHELL}" ]];
    then
        print_yellow "Setting zsh as default shell"
        chsh -s "$(which zsh)"
    fi
fi

# create .zshrc if it doesn't exist
if [[ ! -f "${ZSH_PROFILE_PATH}" ]];
then
    print_yellow "Creating .zshrc"
    touch "${ZSH_PROFILE_PATH}"
fi

# ========= PREZTO SETUP =========

PREZTO_DIR="${HOME}/.zprezto"
PREZTORC_PATH="${HOME}/.zpreztorc"

if [[ ! -d "${PREZTO_DIR}" ]];
then
  print_blue "Cloning sorin-ionescu/prezto to ${PREZTO_DIR}..."
  git clone --recursive "${PREZTO_ZSH_FRAMEWORK}" "${PREZTO_DIR}"
else
  print_yellow "Prezto already installed"
fi

echo "Symlinking prezto runcoms"
# symlink runcom files, excluding README.md
for RUNCOM_FILE in "${PREZTO_DIR}"/runcoms/*; do
  [[ "$(basename "$RUNCOM_FILE")" == "README.md" ]] && continue
  TARGET_FILE="${HOME}/.$(basename "$RUNCOM_FILE")"
  if [ -e "$TARGET_FILE" ];
  then
    MARKER="prezto-runcom:$(basename "$RUNCOM_FILE")"
    if needs_append "$TARGET_FILE" "$MARKER";
    then
      printf '\n# === %s ===\n' "$MARKER" >> "$TARGET_FILE"
      cat "$RUNCOM_FILE" >> "$TARGET_FILE"
      printf '# === %s ===\n' "$MARKER" >> "$TARGET_FILE"
    fi
  else
    ln -s "$RUNCOM_FILE" "$TARGET_FILE"
  fi
done

# set_zstyle - find and replace a zstyle setting in .zpreztorc,
# or append it if not found. This is needed because zstyle lookups return the
# first match, so appending after an existing value has no effect.
set_zstyle() {
  local context="$1" style="$2" value="$3"
  local new_line="zstyle '${context}' ${style} '${value}'"

  if grep -qE "^#?[[:space:]]*zstyle '${context}' ${style} " "$PREZTORC_PATH"; then
    print_yellow "Replacing existing ${style} in .zpreztorc"
    sed -i '' "s|^#*[[:space:]]*zstyle '${context}' ${style} .*|${new_line}|" "$PREZTORC_PATH"
  else
    print_yellow "Appending ${style} to .zpreztorc"
    echo "${new_line}" >> "$PREZTORC_PATH"
  fi
}

echo "Configuring prezto settings"
set_zstyle ':prezto:module:editor' 'key-bindings' 'vi'
set_zstyle ':prezto:module:prompt' 'theme' 'smiley'
set_zstyle ':prezto:module:prompt' 'pwd-length' 'long'

if needs_append "$HOME/.zshrc" "zprezto/init.zsh";
then
  cat << 'EOF' >> "$HOME/.zshrc"

# === added automatically by zsh-setup.sh ===
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# === added automatically by zsh-setup.sh ===
EOF
fi

print_green "Done"
