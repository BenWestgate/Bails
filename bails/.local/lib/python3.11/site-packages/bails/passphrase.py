#!/usr/bin/env python3

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
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

###############################################################################
# Simple passphrase entry with toggle to unmask
###############################################################################

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

class PassphraseDialog(Gtk.Dialog):
    def __init__(self, parent, title):
        Gtk.Dialog.__init__(self, title, parent, 0,
                            (Gtk.STOCK_OK, Gtk.ResponseType.OK, Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL))
        # Set the icon from a file path
        icon_path = "/home/amnesia/.local/share/icons/bails128.png"
        self.set_icon_from_file(icon_path)

        self.set_default_size(500, 80)

        box = self.get_content_area()

        passphrase_entry = Gtk.Entry()
        passphrase_entry.set_placeholder_text("Passphrase")
        passphrase_entry.set_visibility(False)
        box.pack_start(passphrase_entry, False, False, 1)

        show_checkbox = Gtk.CheckButton(label="Show Passphrase")
        show_checkbox.set_active(False)  # Set the checkbox to be active (checked) by default
        box.pack_start(show_checkbox, False, False, 2)

        def on_show_checkbox_toggled(widget):
            if show_checkbox.get_active():
                passphrase_entry.set_visibility(True)
            else:
                passphrase_entry.set_visibility(False)

        def on_passphrase_entry_activate(widget):
            self.response(Gtk.ResponseType.OK)  # Simulate clicking the "OK" button

        passphrase_entry.connect("activate", on_passphrase_entry_activate)
        show_checkbox.connect("toggled", on_show_checkbox_toggled)

        self.show_all()

        self.passphrase = None

        response = self.run()
        if response == Gtk.ResponseType.OK:
            self.passphrase = passphrase_entry.get_text()
        else:
            self.passphrase = None

        self.destroy()

# Example usage:
# dialog = PassphraseDialog(None, "Enter passphrase")
# if dialog.passphrase:
#    print(dialog.passphrase)
