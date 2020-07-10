/*-
 * Copyright (c) 2017-2020 Subhadeep Jasu <subhajasu@gmail.com>
 * Copyright (c) 2017-2020 Saunak Biswas <saunakbis97@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Subhadeep Jasu <subhajasu@gmail.com>
 */

namespace Pebbles {
    public class ConvTempView : Gtk.Grid {
        private CommonKeyPadConverter keypad;

        public Gtk.Entry from_entry;
        public Gtk.Entry to_entry;
        private int from_to = 0;
        private bool allow_change = true;
        private Gtk.ComboBoxText from_unit;
        private Gtk.ComboBoxText to_unit;
        private Gtk.Button interchange_button;
        private Settings settings;

        bool ctrl_held = false;

        private string[] units = {
            (_("Celsius")),
            (_("Fahrenheit")),
            (_("Kelvin")),
        };

        construct {
            settings = Settings.get_default ();

            keypad = new CommonKeyPadConverter ();
            
            // Make Header Label
            var header_title = new Gtk.Label (_("Temperature"));
            header_title.get_style_context ().add_class ("h1");
            header_title.set_justify (Gtk.Justification.LEFT);
            header_title.halign = Gtk.Align.START;
            header_title.margin_start = 6;
            
            // Make Upper Unit Box
            from_entry = new Gtk.Entry ();
            from_entry.set_text (settings.conv_temp_from_entry);
            from_entry.get_style_context ().add_class ("Pebbles_Conversion_Text_Box");
            from_entry.max_width_chars = 35;
            from_unit = new Gtk.ComboBoxText ();
            for (int i = 0; i < units.length; i++) {
                from_unit.append_text (units [i]);
            }
            from_unit.active = 0;

            // Make Lower Unit Box
            to_entry = new Gtk.Entry ();
            to_entry.set_text (settings.conv_temp_to_entry);
            to_entry.get_style_context ().add_class ("Pebbles_Conversion_Text_Box");
            to_entry.max_width_chars = 35;
            to_unit = new Gtk.ComboBoxText ();
            for (int i = 0; i < units.length; i++) {
                to_unit.append_text (units [i]);
            }
            to_unit.active = 1;
            
            // Create Conversion active section
            interchange_button = new Gtk.Button ();
            var up_button = new Gtk.Image.from_icon_name ("go-up-symbolic", Gtk.IconSize.BUTTON);
            var down_button = new Gtk.Image.from_icon_name ("go-down-symbolic", Gtk.IconSize.BUTTON);
            var up_down_grid = new Gtk.Grid ();
            up_down_grid.valign = Gtk.Align.CENTER;
            up_down_grid.halign = Gtk.Align.CENTER;
            up_down_grid.attach (up_button, 0, 0, 1, 1);
            up_down_grid.attach (down_button, 1, 0, 1, 1);
            interchange_button.add (up_down_grid);
            interchange_button.margin_top = 8;
            interchange_button.margin_bottom = 8;
            interchange_button.margin_start = 100;
            interchange_button.margin_end   = 100;
            
            Gtk.Grid conversion_grid = new Gtk.Grid ();
            conversion_grid.attach (from_unit, 0, 0, 1, 1);
            conversion_grid.attach (from_entry, 0, 1, 1, 1);
            conversion_grid.attach (interchange_button, 0, 2, 1, 1);
            conversion_grid.attach (to_unit, 0, 3, 1, 1);
            conversion_grid.attach (to_entry, 0, 4, 1, 1);
            conversion_grid.width_request = 240;
            conversion_grid.height_request = 210;
            conversion_grid.set_row_homogeneous (true);
            conversion_grid.margin_start = 8;
            conversion_grid.margin_end = 8;
            conversion_grid.valign = Gtk.Align.CENTER;
            conversion_grid.halign = Gtk.Align.CENTER;
            conversion_grid.row_spacing = 8;
            
            var separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);
            separator.margin_start = 25;
            separator.margin_end = 25;
            
            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.CENTER;
            attach (header_title, 0, 0, 3, 1);
            attach (keypad, 0, 1, 1, 1);
            attach (separator, 1, 1, 1, 1);
            attach (conversion_grid, 2, 1, 1, 1);
            row_spacing = 8;

            handle_events ();
        }

        private void handle_events () {
            from_entry.button_press_event.connect (() => {
                from_to = 0;
                return false;
            });

            to_entry.button_press_event.connect (() => {
                from_to = 1;
                return false;
            });

            this.key_press_event.connect ((event) => {
                keypad.key_pressed (event);
                grab_focus_on_view_switch ();
                if (event.keyval == KeyboardHandler.KeyMap.CTRL) {
                    ctrl_held = true;
                }
                switch (event.keyval) {
                    case KeyboardHandler.KeyMap.C_UPPER:
                    case KeyboardHandler.KeyMap.C_LOWER:
                    if (ctrl_held) {
                        write_answer_to_clipboard ();
                    }
                    break;
                    case KeyboardHandler.KeyMap.TAB:
                    case KeyboardHandler.KeyMap.SHIFT_TAB:
                    if (this.from_entry.has_focus) {
                        this.to_entry.grab_focus_without_selecting ();
                        to_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
                        from_to = 1;
                    } else {
                        this.from_entry.grab_focus_without_selecting ();
                        from_to = 0;
                        from_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
                    }
                    break;
                    case KeyboardHandler.KeyMap.NAV_UP:
                    this.from_entry.grab_focus_without_selecting ();
                    from_to = 0;
                    from_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
                    break;
                    case KeyboardHandler.KeyMap.NAV_DOWN:
                    this.to_entry.grab_focus_without_selecting ();
                    to_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
                    from_to = 1;
                    break;
                    case KeyboardHandler.KeyMap.RETURN:
                    interchange_entries ();
                    interchange_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                    break;
                }
                return false;
            });

            this.key_release_event.connect ((event) => {
                keypad.key_released ();
                interchange_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
                if (event.keyval == KeyboardHandler.KeyMap.CTRL) {
                    ctrl_held = false;
                }
                return false;
            });


            from_entry.changed.connect (() => {
                if (from_to == 0 && allow_change) {
                    string result = TempConverter.convert ((from_entry.get_text ()), from_unit.active, to_unit.active);
                    to_entry.set_text (result);
                }
                save_state ();
            });

            to_entry.changed.connect (() => {
                if (from_to == 1 && allow_change) {
                    string result = TempConverter.convert ((to_entry.get_text ()), to_unit.active, from_unit.active);
                    from_entry.set_text (result);
                }
                save_state ();
            });

            from_unit.changed.connect (() => {
                if (allow_change) {
                    string result = TempConverter.convert ((to_entry.get_text ()), to_unit.active, from_unit.active);
                    from_entry.set_text (result);
                }
                save_state ();
            });

            to_unit.changed.connect (() => {
                if (allow_change) {
                    string result = TempConverter.convert ((from_entry.get_text ()), from_unit.active, to_unit.active);
                    to_entry.set_text (result);
                }
                save_state ();
            });

            interchange_button.clicked.connect (() => {
                allow_change = false;
                int temp = to_unit.active;
                to_unit.active = from_unit.active;
                from_unit.active = temp;
                string result = TempConverter.convert ((from_entry.get_text ()), from_unit.active, to_unit.active);
                to_entry.set_text (result);
                allow_change = true;
            });
            
            keypad.button_clicked.connect ((val) => {
                if (from_to == 0) {
                    if (val == "C") {
                        from_entry.grab_focus_without_selecting ();
                        from_entry.set_text ("0");
                    }
                    else if (val == "del") {
                        from_entry.grab_focus_without_selecting ();
                        from_entry.backspace ();
                    }
                    else {
                        if (from_entry.get_text () == "0"){
                            from_entry.set_text("");
                        }
                        from_entry.grab_focus_without_selecting ();
                        from_entry.insert_at_cursor (val);
                    }
                }
                else {
                    if (val == "C") {
                        to_entry.grab_focus_without_selecting ();
                        to_entry.set_text ("0");
                    }
                    else if (val == "del") {
                        to_entry.grab_focus_without_selecting ();
                        to_entry.backspace ();
                    }
                    else {
                        if (to_entry.get_text () == "0"){
                            to_entry.set_text("");
                        }
                        to_entry.grab_focus_without_selecting ();
                        to_entry.insert_at_cursor (val);
                    }
                }
            });
        }
        private void interchange_entries () {
            allow_change = false;
            int temp = to_unit.active;
            to_unit.active = from_unit.active;
            from_unit.active = temp;
            string result = TempConverter.convert ((from_entry.get_text ()), from_unit.active, to_unit.active);
            to_entry.set_text (result);
            allow_change = true;
        }

        public void grab_focus_on_view_switch () {
            switch (from_to) {
                case 0: 
                    this.from_entry.grab_focus_without_selecting ();
                    break;
                case 1:
                    this.to_entry.grab_focus_without_selecting ();
                    break;
            }
        }
        private void save_state () {
            settings.conv_temp_from_entry = from_entry.get_text ();
            settings.conv_temp_to_entry = to_entry.get_text ();
        }

        public void write_answer_to_clipboard () {
            Gdk.Display display = this.get_display ();
            Gtk.Clipboard clipboard = Gtk.Clipboard.get_for_display (display, Gdk.SELECTION_CLIPBOARD);
            if (from_to == 0) {
                string last_answer = to_entry.get_text().replace(Utils.get_local_separator_symbol(), "");
                clipboard.set_text (last_answer, -1);
            } else {
                string last_answer = from_entry.get_text().replace(Utils.get_local_separator_symbol(), "");
                clipboard.set_text (last_answer, -1);
            } 
        }
    }
    public class TempConverter {
        // C/5 = F-32/9;
        static double f_2_c (double far) {
            return ((far - 32) * 5 / 9);
        }
        static double c_2_f (double cel) {
            return ((cel * 9 / 5) + 32);
        }
        static double c_2_k (double cel) {
            return (cel + 273.15);
        }
        static double k_2_c (double k) {
            return (k - 273.15);
        }
        static double f_2_k (double far) {
            return ((((far - 32) * 5 / 9)) + 273.15);
        }
        static double k_2_f (double k) {
            return ((k - 273.15) * 9/5 + 32);
        }
        public static string convert (string input_string, int i, int j) {
            string input_temp = input_string.replace (Utils.get_local_separator_symbol (), "");
            input_temp = input_temp.replace(Utils.get_local_radix_symbol (), ".");
            double val = double.parse (input_temp);
            string output = "";
            if (i == 0) {
                switch (j) {
                    case 0:
                        output = val.to_string ();
                        break;
                    case 1:
                        output = ("%.9f".printf (c_2_f (val)));
                        break;
                    case 2:
                        output = ("%.9f".printf (c_2_k (val)));
                        break;
                }
            }
            else if (i == 1) {
                switch (j) {
                    case 0:
                        output = ("%.9f".printf (f_2_c (val)));
                        break;
                    case 1:
                        output = val.to_string ();
                        break;
                    case 2:
                        output = ("%.9f".printf (f_2_k (val)));
                        break;
                }
            }
            else {
                switch (j) {
                    case 0:
                        output = ("%.9f".printf (k_2_c (val)));
                        break;
                    case 1:
                        output = ("%.9f".printf (k_2_f (val)));
                        break;
                    case 2:
                        output = val.to_string ();
                        break;
                }
            }
            // Remove trailing 0s and decimals
            while (output.has_suffix ("0")) {
                output = output.slice (0, -1);
            }
            if (output.has_suffix (".")) {
                output = output.slice (0, -1);
            }
            if (output == "-0") {
                output = "0";
            }
            return output;
        }
    } 
}
