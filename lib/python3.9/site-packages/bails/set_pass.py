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
# Passphrase confirm entry with strength meter, length req and toggle to unmask
###############################################################################

import gi

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk


# Import the function from the provided file in Tails
from tps_frontend.passphrase_strength_hint import set_passphrase_strength_hint

class PassphraseDialog(Gtk.Dialog):
    def __init__(self, parent, title):
        Gtk.Dialog.__init__(self, title, parent, 0,
                            (
                            Gtk.STOCK_OK, Gtk.ResponseType.OK, Gtk.STOCK_CANCEL,
                            Gtk.ResponseType.CANCEL))
        # Set the icon from a file path
        icon_path = "/home/amnesia/.local/share/icons/bails128.png"
        self.set_icon_from_file(icon_path)
        self.set_default_size(400, 200)

        box = self.get_content_area()

        # Add the bold text above the strength meter
        label = Gtk.Label()
        label.set_markup(
            "<b>We recommend using the same passphrase as your current Tails so that the passphrase is easier to remember.</b>")
        box.pack_start(label, False, False, 0)

        # Create a box to hold the strength hint and progress bar
        strength_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
        box.pack_start(strength_box, False, False, 0)

        # Create the label to display the strength hint
        strength_label = Gtk.Label()
        strength_label.set_margin_bottom(6)  # Add some space below the hint
        strength_box.pack_start(strength_label, False, False, 0)
        # Create the progress bar
        progress_bar = Gtk.ProgressBar()
        style_context = progress_bar.get_style_context()
        style_context.add_class(Gtk.STYLE_CLASS_TROUGH)
        style_context.add_class(Gtk.STYLE_CLASS_BACKGROUND)
        progress_bar.set_show_text(False)
        strength_box.pack_start(progress_bar, False, False, 10)

        # Create the label for the passphrase length requirement
        length_requirement_label = Gtk.Label()
        length_requirement_label.set_markup(
            "<i>A random passphrase of at least 12 characters MUST be used.</i>")
        length_requirement_label.set_margin_top(
            6)  # Add some space above the requirement label
        strength_box.pack_start(length_requirement_label, False, False, 0)

        passphrase_entry = Gtk.Entry()
        passphrase_entry.set_placeholder_text("Passphrase")
        passphrase_entry.set_visibility(False)
        box.pack_start(passphrase_entry, False, False, 1)

        confirm_entry = Gtk.Entry()
        confirm_entry.set_placeholder_text("Confirm Passphrase")
        confirm_entry.set_visibility(False)
        box.pack_start(confirm_entry, False, False, 2)

        show_checkbox = Gtk.CheckButton(label="Show Passphrase")
        box.pack_start(show_checkbox, False, False, 0)

        ok_button = self.get_widget_for_response(
            Gtk.ResponseType.OK)  # Get the OK button
        ok_button.set_sensitive(
            False)  # Initialize the OK button with sensitivity set to False
        ok_button.grab_default()

        def on_passphrase_changed(entry):
            ok_button.set_sensitive(False)
            update_ok_button_state()
            passphrase = passphrase_entry.get_text()
            progress_bar.set_show_text(True)
            strength_hint = set_passphrase_strength_hint(progress_bar,
                                                         passphrase)
            strength_label.set_text(strength_hint)

        passphrase_entry.connect("changed", on_passphrase_changed)

        def on_confirm_passphrase_changed(entry):
            ok_button.set_sensitive(False)
            update_ok_button_state()

        confirm_entry.connect("changed", on_confirm_passphrase_changed)

        def update_ok_button_state():
            passphrase = passphrase_entry.get_text()
            confirm_passphrase = confirm_entry.get_text()
            if passphrase == confirm_passphrase and len(passphrase) >= 12:
                ok_button.set_sensitive(True)
                ok_button.grab_focus()
            if len(passphrase) >= 12 or len(confirm_passphrase) == 0:
                length_requirement_label.set_visible(False)
            else:
                length_requirement_label.set_visible(True)

        def on_show_checkbox_toggled(widget):
            if show_checkbox.get_active():
                passphrase_entry.set_visibility(True)
                confirm_entry.set_visibility(True)
            else:
                passphrase_entry.set_visibility(False)
                confirm_entry.set_visibility(False)

        def on_passphrase_entry_activate(widget):
            self.response(
                Gtk.ResponseType.OK)  # Simulate clicking the "OK" button

        passphrase_entry.connect("activate", on_passphrase_entry_activate)
        show_checkbox.connect("toggled", on_show_checkbox_toggled)

        self.show_all()
        update_ok_button_state()

        # Set focus on the "Show Passphrases" checkbox
        show_checkbox.grab_focus()

        self.passphrase = None
        self.confirm_passphrase = None

        response = self.run()
        if response == Gtk.ResponseType.OK:
            self.passphrase = passphrase_entry.get_text()
            self.confirm_passphrase = confirm_entry.get_text()
        else:
            self.passphrase = None
            self.confirm_passphrase = None

        self.destroy()


class SimplePassphraseDialog(Gtk.Dialog):
    def __init__(self, parent, title):
        Gtk.Dialog.__init__(self, title, parent, 0,
                            (Gtk.STOCK_OK, Gtk.ResponseType.OK))

        # Set the icon from a file path
        icon_path = "/home/amnesia/.local/share/icons/bails128.png"
        self.set_icon_from_file(icon_path)

        self.set_default_size(500, 150)

        box = self.get_content_area()

        passphrase_entry = Gtk.Entry()
        passphrase_entry.set_placeholder_text("Passphrase")
        passphrase_entry.set_visibility(False)
        box.pack_start(passphrase_entry, False, False, 0)

        confirm_entry = Gtk.Entry()
        confirm_entry.set_placeholder_text("Confirm Passphrase")
        confirm_entry.set_visibility(False)
        box.pack_start(confirm_entry, False, False, 0)

        show_checkbox = Gtk.CheckButton(label="Show Passphrase")
        box.pack_start(show_checkbox, False, False, 0)

        ok_button = self.get_widget_for_response(
            Gtk.ResponseType.OK)  # Get the OK button
        ok_button.set_sensitive(
            False)  # Initialize OK button with sensitivity set to False
        ok_button.grab_default()
        self.set_default(ok_button)

        def on_passphrase_changed(entry):
            ok_button.set_sensitive(False)
            update_ok_button_state()

        passphrase_entry.connect("changed", on_passphrase_changed)

        def on_confirm_passphrase_changed(entry):
            ok_button.set_sensitive(False)
            update_ok_button_state()

        confirm_entry.connect("changed", on_confirm_passphrase_changed)

        def update_ok_button_state():
            passphrase = passphrase_entry.get_text()
            confirm_passphrase = confirm_entry.get_text()
            if passphrase == confirm_passphrase and len(passphrase) >= 1:
                ok_button.set_sensitive(True)
                ok_button.grab_default()

        def on_show_checkbox_toggled(widget):
            if show_checkbox.get_active():
                passphrase_entry.set_visibility(True)
                confirm_entry.set_visibility(True)
            else:
                passphrase_entry.set_visibility(False)
                confirm_entry.set_visibility(False)

        show_checkbox.connect("toggled", on_show_checkbox_toggled)

        self.show_all()
        update_ok_button_state()

        # Set focus on the "Show Passphrases" checkbox
        show_checkbox.grab_focus()

        self.passphrase = None
        self.confirm_passphrase = None

        response = self.run()
        if response == Gtk.ResponseType.OK:
            self.passphrase = passphrase_entry.get_text()
            self.confirm_passphrase = confirm_entry.get_text()
        else:
            self.passphrase = None
            self.confirm_passphrase = None

        self.destroy()


# Example usage:
# dialog = PassphraseDialog(None, "Set passphrase")
# if dialog.passphrase and dialog.confirm_passphrase:
#     print(dialog.passphrase + '|' + dialog.confirm_passphrase)


# Example usage:
# dialog = SimplePassphraseDialog(None, "Set passphrase")
# if dialog.passphrase and dialog.confirm_passphrase:
#    print(dialog.passphrase + '|' + dialog.confirm_passphrase)
