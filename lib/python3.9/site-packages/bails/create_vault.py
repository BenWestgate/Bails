#!/usr/bin/env python

import dbus
import subprocess
import secrets
from pathlib import Path



def create_vault(passphrase=secrets.token_urlsafe(32), label='Secret'):
    """
    Creates a vault image file and formats it with a passphrase.

    @param passphrase: The passphrase string to use for encryption.
    @param label: The filesystem label for the new vault.
    """
    VAULT_PATH = "/live/persistence/TailsData_unlocked/dotfiles/Desktop/"

    if not Path(VAULT_PATH).exists():
        Path(VAULT_PATH).mkdir()

    name = 'vault_' + secrets.token_urlsafe(3) + '.img'
    while Path(VAULT_PATH+name).exists():
        name = 'vault_' + secrets.token_urlsafe(3) + '.img'

    if subprocess.run(["fallocate", "-l", "64MiB", VAULT_PATH+name],
                      check=True).returncode:
        print("Failed to create vault image")
        exit(1)
    result = subprocess.run(
        ["udisksctl", "loop-setup", "-f", VAULT_PATH+name],
        check=True, stdout=subprocess.PIPE)
    if result.returncode != 0:
        print("Failed to open vault loop device")
        exit(1)
    # Create a proxy object for the D-Bus service
    proxy = dbus.SystemBus().get_object(
        "org.freedesktop.UDisks2", "/org/freedesktop/UDisks2/block_devices/loop"
        + str(result.stdout).split('/dev/loop')[-1][:-4])

    # Get the interface for formatting
    iface = dbus.SystemBus().Interface(proxy, "org.freedesktop.UDisks2.Block")
    # Define the format type and options as a dictionary
    format_type = "ext4"
    format_options = {
        "encrypt.passphrase": dbus.String(passphrase),
        "encrypt.type": dbus.String("luks2"), "label": dbus.String(label),
        "take-ownership": dbus.Boolean(1)}

    # Call the Format method with the type and options
    iface.Format(format_type, format_options)

    return


