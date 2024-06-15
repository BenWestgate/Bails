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
# Sets environment variable and launches install-core and/or installs Bails
###############################################################################

export VERSION='v0.7.0-alpha'
export WAYLAND_DISPLAY="" # Needed for zenity dialogs to have window icon
export ICON="--window-icon=$HOME/.local/share/icons/bails128.png"
export DOTFILES='/live/persistence/TailsData_unlocked/dotfiles'
BAILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$1" == "--version" ]; then
  echo "Bails version $VERSION"
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
  # Install Bails to tmpfs
  rsync --recursive "$BAILS_DIR/bails/" "$HOME"
  # shellcheck disable=SC1091
  . "$HOME"/.profile
  if [ -z "$1" ]; then # Don't update or install core if ran with a parameter
    install-core
  else
    persistent-setup
  fi &

  until /usr/local/lib/tpscli is-unlocked && \
    /usr/local/lib/tpscli is-active Dotfiles && \
    [ -d "$DOTFILES" ] && [ -w "$DOTFILES" ]; do
      sleep 1
  done
  # Install Bails to Persistent Storage
  rsync -r --remove-source-files "$BAILS_DIR"/bails/ $DOTFILES
  rsync --remove-source-files --recursive "$BAILS_DIR"/ $DOTFILES/.local/share/bails
  rm -rf "$BAILS_DIR"
  link-dotfiles
  wait
  if [ -z "$1" ]; then
    zenity --info --title="Bails install successful" --text="Bails $VERSION has been installed." "$ICON" --icon-name=bails128
    # Exit by killing controlling terminal
    echo "Bails installation complete! 

Closing this window in 30 seconds, press any key to abort.
"
for ((i = 30; i >= 1; i--)); do
    echo -n "$i "
    read -r -t 1 -n 1 && { printf '\n%s\n' "Aborted."; exit 0; }
done
    echo "
Closing terminal window..."
    sleep 3
    PARENT_PID=$(ps -o ppid= -p $$)
    kill -9 "$PARENT_PID"
  else
    zenity --info --title="Bails update successful" --text="Bails has been updated to $VERSION." "$ICON" --icon-name=bails128
  fi
fi
exit 1