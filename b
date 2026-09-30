#!/bin/bash

# Copyright (c) 2023 Ben Westgate
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

###############################################################################
# Sets environment variable and launches install-core or installs CipherStick
###############################################################################

export VERSION='v0.7.2-alpha'
export WAYLAND_DISPLAY="" # Needed for zenity dialogs to have window icon
export ICON="--window-icon=$HOME/.local/share/icons/bails128.png"
export DOTFILES='/live/persistence/TailsData_unlocked/dotfiles'
BAILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

remove_legacy_wallet_files() {
  local root="${1:?}"
  local associations

  if [ -e "$root/.local/bin/Sparrow" ] || \
    [ -e "$root/.local/lib/app/Sparrow.cfg" ] || \
    [ -e "$root/.local/lib/sparrow-Sparrow.desktop" ] || \
    [ -e "$root/.local/share/applications/sparrow-Sparrow.desktop" ]; then
    rm -rf -- \
      "$root/.local/bin/Sparrow" \
      "$root/.local/lib/Sparrow.png" \
      "$root/.local/lib/app" \
      "$root/.local/lib/libapplauncher.so" \
      "$root/.local/lib/runtime" \
      "$root/.local/lib/sparrow-Sparrow-MimeInfo.xml" \
      "$root/.local/lib/sparrow-Sparrow.desktop" \
      "$root/.local/share/applications/sparrow-Sparrow.desktop" \
      "$root/.local/share/icons/Sparrow.png" \
      "$root/.local/share/mime/packages/sparrow-Sparrow-MimeInfo.xml" \
      "$root/.local/share/sparrow"
  fi

  for associations in "$root/.local/share/applications/defaults.list" \
    "$root/.local/share/applications/mimeinfo.cache"; do
    if [ -f "$associations" ] && [ ! -L "$associations" ]; then
      sed -i '/^x-scheme-handler\/bitcoin=/s/sparrow-Sparrow\.desktop/bitcoin-qt.desktop/g' \
        "$associations"
    fi
  done

  rm -rf -- \
    "$root/.local/bin/bails-wallet" \
    "$root/.local/bin/decrypt-vault" \
    "$root/.local/bin/install-sparrow" \
    "$root/.local/lib/python3.11/site-packages/bails-wallet" \
    "$root/.local/lib/python3.11/site-packages/codex32" \
    "$root/.local/lib/python3.11/site-packages/bails" \
    "$root/.local/share/applications/decrypt-vault.desktop"
}

if [ "$1" == "--version" ]; then
  echo "CipherStick version $VERSION"
  exit 0
elif ! grep 'NAME="Tails"' /etc/os-release > /dev/null; then # Check for Tails OS.
    echo "
    YOU MUST RUN THIS SCRIPT IN TAILS OS!
    "
    read -rp "PRESS ENTER TO EXIT SCRIPT, AND RUN AGAIN FROM TAILS. "
elif [[ $(id -u) = "0" ]]; then # Check for root.
    echo "
  YOU SHOULD NOT RUN THIS SCRIPT AS ROOT!
  "
    read -rp "PRESS ENTER TO EXIT SCRIPT, AND RUN AGAIN AS $USER. "
else
  printf '\033]2;Welcome to CipherStick!\a'
  # Install CipherStick to tmpfs
  rsync -rvh --perms "$BAILS_DIR/bails/" "$HOME"
  remove_legacy_wallet_files "$HOME"
  # shellcheck disable=SC1091
  . "$HOME/.profile"
  (
    persistent-setup &
    until /usr/local/lib/tpscli is-unlocked && \
      /usr/local/lib/tpscli is-active Dotfiles && \
      [ -d "$DOTFILES" ] && [ -w "$DOTFILES" ]; do
        sleep 1
    done
    # Install CipherStick to Persistent Storage
    rsync -rvh --perms --remove-source-files "$BAILS_DIR/bails/" $DOTFILES
    rsync -rvh --perms --delete --exclude=/release-key.asc --remove-source-files \
      "$BAILS_DIR"/ $DOTFILES/.local/share/bails
    remove_legacy_wallet_files "$DOTFILES"
    wallets='/live/persistence/TailsData_unlocked/Persistent/.bitcoin/wallets'
    if [ -d "$wallets" ] && [ ! -L "$wallets" ]; then
      chmod u+w "$wallets"
    fi
    rm -rvf "$BAILS_DIR"
    link-dotfiles
  ) & # Run persistent setup in background
  setup_pid=$!
  if [ -z "$1" ]; then # Install/Update core if ran without a parameter
    codex32_handoff_pending="$DOTFILES/.local/state/codex32-handoff-pending"
    # shellcheck disable=SC1091
    . install-core
    first_install=false
    # install-core is sourced above and deliberately sets this caller variable.
    # shellcheck disable=SC2154
    if [ -e "$codex32_handoff_pending" ] || \
      [ "$core_was_installed" != true ]; then
      first_install=true
    fi
    wait "$setup_pid"
    if [ "$first_install" = true ]; then
      touch "$codex32_handoff_pending"
      if open-codex32 --install; then
        rm -f -- "$codex32_handoff_pending"
      else
        zenity --error --title='codex32 setup did not complete' \
          --text='CipherStick setup stopped because codex32 did not start. Correct the error shown above, then run CipherStick again.' \
          "$ICON"
        exit 1
      fi
    fi
    notify-send --transient --icon=bails128 'CipherStick install complete' \
      "CipherStick $VERSION is installed. Bitcoin Core is syncing in the background."
  else
    wait "$setup_pid"
    notify-send --transient --icon=bails128 'CipherStick update complete' \
      "CipherStick has been updated to $VERSION."
  fi
  exit 0
fi
exit 1
