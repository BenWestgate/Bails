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

export VERSION='v0.7.3-alpha'
export WAYLAND_DISPLAY="" # Needed for zenity dialogs to have window icon
export ICON="--window-icon=$HOME/.local/share/icons/bails128.png"
export DOTFILES='/live/persistence/TailsData_unlocked/dotfiles'
readonly SECURITY_IN_A_BOX_TOR_URL="http://lxjacvxrozjlxd7pqced7dyefnbityrwqjosuuaqponlg3v7esifrzad.onion/en/"
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
  printf '\033]2;Welcome to Bails!\a'
  # Install Bails to tmpfs
  rsync -rvh "$BAILS_DIR/bails/" "$HOME"
  # shellcheck disable=SC1091
  . "$HOME/.profile"
  (
    persistent-setup &
    until /usr/local/lib/tpscli is-unlocked && \
      /usr/local/lib/tpscli is-active Dotfiles && \
      [ -d "$DOTFILES" ] && [ -w "$DOTFILES" ]; do
        sleep 1
    done
    # Install Bails to Persistent Storage
    rsync -rvh --remove-source-files "$BAILS_DIR/bails/" $DOTFILES
    rsync -rvh --remove-source-files "$BAILS_DIR"/ $DOTFILES/.local/share/bails
    rm -rvf "$BAILS_DIR"
    link-dotfiles
  ) & # Run persistent setup in background
  if [ -z "$1" ]; then # Install/Update core if ran without a parameter
    # shellcheck disable=SC1091
    . install-core && bails-wallet
    wait
    # Display info about IBD, keeping Tails private and extra reading material
    zenity --info --title='Setup almost complete' --icon-name=bails128 "$ICON" --text='Bitcoin Core has begun syncing the block chain automatically.\nMake sure no one messes with the PC.\n\nTo lock the screen for privacy, press ❖+L (⊞+L or ⌘+L)\n\nIt is safer to exit Bitcoin Core (Ctrl+Q), <a href="file:///usr/share/doc/tails/website/doc/first_steps/shutdown.en.html">shutdown Tails</a> and take your Bails USB stick with you or store it in a safe place than leave Tails running unattended where people you distrust could tamper with it.\n\nIf you want to learn more about using Tails safely read the <a href="file:///usr/share/doc/tails/website/doc.en.html">documentation</a>.\n\nAnother excellent read to improve your physical and digital security tactics is the <a href="'"$SECURITY_IN_A_BOX_TOR_URL"'">security in-a-box</a> website.'
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
  exit 0
fi
exit 1
