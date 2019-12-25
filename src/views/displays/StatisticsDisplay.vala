/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
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
    public class StatisticsDisplay : Gtk.Grid {
        // Status bar
        Gtk.Label result_type_label_g;
        Gtk.Label result_type_label_m;
        Gtk.Label result_type_label_edia;
        Gtk.Label result_type_label_n;
        Gtk.Label result_type_label_mode;
        Gtk.Label result_type_label_summation;
        Gtk.Label result_type_label_x_bar;
        Gtk.Label result_type_label_x_sqr;
        Gtk.Label result_type_label_sigma;
        Gtk.Label result_type_label_sig_sqr;
        Gtk.Label result_type_label_sv;
        Gtk.Label result_type_label_sd;
        Gtk.Label memory_label;

        // Answer Label
        public Gtk.Label answer_label;

        // Input cells
        Gtk.Box input_table;
        public int sample_index = -1;

        construct {
            stats_display_make_ui ();
            set_result_type (-1);
        }

        StatisticsView stats_view;

        public StatisticsDisplay (StatisticsView stats_view) {
            this.stats_view = stats_view;
        }

        private void stats_display_make_ui () {
            // Stylize background;
            get_style_context ().add_class ("Pebbles_Display_Unit_Bg");

            // Make status bar
            var lcd_status_bar = new Gtk.Grid ();

            result_type_label_g = new Gtk.Label ("g");
            result_type_label_g.get_style_context ().add_class ("pebbles_h4");
            result_type_label_m = new Gtk.Label ("m");
            result_type_label_m.get_style_context ().add_class ("pebbles_h4");
            result_type_label_edia = new Gtk.Label ("edia");
            result_type_label_edia.get_style_context ().add_class ("pebbles_h4");
            result_type_label_n = new Gtk.Label ("n");
            result_type_label_n.get_style_context ().add_class ("pebbles_h4");
            result_type_label_mode = new Gtk.Label ("mode");
            result_type_label_mode.get_style_context ().add_class ("pebbles_h4");
            result_type_label_summation = new Gtk.Label ("Σ");
            result_type_label_summation.get_style_context ().add_class ("pebbles_h4");
            result_type_label_x_bar = new Gtk.Label ("x̄");
            result_type_label_x_bar.get_style_context ().add_class ("pebbles_h4");
            result_type_label_x_sqr = new Gtk.Label ("<sup>2</sup>");
            result_type_label_x_sqr.get_style_context ().add_class ("pebbles_h4");
            result_type_label_x_sqr.use_markup = true;
            result_type_label_sigma = new Gtk.Label ("σ");
            result_type_label_sigma.get_style_context ().add_class ("pebbles_h4");
            result_type_label_sig_sqr = new Gtk.Label ("<sup>2</sup>");
            result_type_label_sig_sqr.get_style_context ().add_class ("pebbles_h4");
            result_type_label_sig_sqr.use_markup = true;
            result_type_label_sv = new Gtk.Label ("SV");
            result_type_label_sv.get_style_context ().add_class ("pebbles_h4");
            result_type_label_sd = new Gtk.Label ("SD");
            result_type_label_sd.get_style_context ().add_class ("pebbles_h4");

            Gtk.Box result_type_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            result_type_box.pack_start (result_type_label_g, false, false, 0);
            result_type_box.pack_start (result_type_label_m, false, false, 0);
            result_type_box.pack_start (result_type_label_edia, false, false, 0);
            result_type_box.pack_start (result_type_label_n, false, false, 0);
            result_type_box.pack_start (result_type_label_mode, false, false, 0);
            result_type_box.pack_start (result_type_label_summation, false, false, 0);
            result_type_box.pack_start (result_type_label_x_bar, false, false, 0);
            result_type_box.pack_start (result_type_label_x_sqr, false, false, 0);
            result_type_box.pack_start (result_type_label_sigma, false, false, 0);
            result_type_box.pack_start (result_type_label_sig_sqr, false, false, 0);
            result_type_box.pack_start (result_type_label_sv, false, false, 0);
            result_type_box.pack_start (result_type_label_sd, false, false, 0);

            memory_label = new Gtk.Label ("M");
            memory_label.get_style_context ().add_class ("pebbles_h4");

            lcd_status_bar.attach (result_type_box, 0, 0, 1, 1);
            lcd_status_bar.attach (memory_label, 1, 0, 1, 1);
            lcd_status_bar.column_spacing = 205;
            lcd_status_bar.width_request = 530;
            lcd_status_bar.set_halign (Gtk.Align.END);


            answer_label = new Gtk.Label ("0");
            answer_label.set_halign (Gtk.Align.END);
            answer_label.get_style_context ().add_class ("pebbles_h1");
            var answer_scrollable = new Gtk.ScrolledWindow (null, null);
            answer_scrollable.add (answer_label);
            answer_scrollable.propagate_natural_height = true;
            answer_scrollable.shadow_type = Gtk.ShadowType.NONE;

            
            input_table = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            input_table.get_style_context ().add_class ("stats_table");
            var input_table_scrollable = new Gtk.ScrolledWindow (null, null);
            input_table_scrollable.add (input_table);

            
            

            // Make seperator
            Gtk.Separator lcd_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            lcd_separator.set_opacity (0.6);

            attach (lcd_status_bar, 0, 0, 1, 1);
            attach (answer_scrollable, 0, 1, 1, 1);
            attach (lcd_separator, 0, 2, 1, 1);
            attach (input_table_scrollable, 0, 3, 1, 1);
            
        }

        public void set_result_type (int type) {
            switch (type) {
                case 0:
                    result_type_label_g.set_opacity (1);
                    result_type_label_m.set_opacity (1);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 1:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (1);
                    result_type_label_edia.set_opacity (1);
                    result_type_label_n.set_opacity (1);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 2:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (1);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 3:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (1);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 4:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (1);
                    result_type_label_x_bar.set_opacity (1);
                    result_type_label_x_bar.set_text ("x");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 5:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (1);
                    result_type_label_x_bar.set_opacity (1);
                    result_type_label_x_bar.set_text ("x");
                    result_type_label_x_sqr.set_opacity (1);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 6:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (1);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 7:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (1);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (1);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 8:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (1);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 9:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (1);
                    result_type_label_sig_sqr.set_opacity (1);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 10:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (1);
                    result_type_label_sd.set_opacity (0.2);
                    break;
                case 11:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (1);
                    break;
                default:
                    result_type_label_g.set_opacity (0.2);
                    result_type_label_m.set_opacity (0.2);
                    result_type_label_edia.set_opacity (0.2);
                    result_type_label_n.set_opacity (0.2);
                    result_type_label_mode.set_opacity (0.2);
                    result_type_label_summation.set_opacity (0.2);
                    result_type_label_x_bar.set_opacity (0.2);
                    result_type_label_x_bar.set_text ("x̄");
                    result_type_label_x_sqr.set_opacity (0.2);
                    result_type_label_sigma.set_opacity (0.2);
                    result_type_label_sig_sqr.set_opacity (0.2);
                    result_type_label_sv.set_opacity (0.2);
                    result_type_label_sd.set_opacity (0.2);
                    break;
            }
            this.queue_draw ();
        }

        public void insert_cell (bool add_cell) {
            var cell = new Gtk.Entry ();
            cell.get_style_context ().add_class ("stat_cell");
            cell.has_frame = false;
            cell.width_chars = 16;
            this.input_table.pack_start (cell, false, false, 0);
            this.show_all ();
            if (!add_cell) {
                if (sample_index == -1){
                    sample_index = 0;
                }
                this.input_table.reorder_child (cell, sample_index);
            } else {
                int n = 0;
                input_table.foreach ((cell) => {
                    n++;
                });
                sample_index = n - 1;
            }
            cell.button_release_event.connect (() => {
                find_focused_cell ();
                return false;
            });
        }

        public void remove_cell () {
            int i = 0;
            input_table.foreach ((cell) => {
                if (i == sample_index && sample_index != -1) {
                    input_table.remove (cell);
                    if (sample_index > 0) {
                        sample_index--;
                    }
                }
                i++;
            });
            //  foreach (Gtk.Entry cell in input_table) {
            //      if (i == sample_index) {
            //          input_table.remove (cell);
            //      }
            //      i++;
            //  }
        }

        public void set_editable_cell () {
            int i = 0;
            input_table.foreach ((cell) => {
                if (i == sample_index) {
                    cell.grab_focus ();
                }
                i++;
            });
        }

        public bool navigate_left () {
            if (sample_index > 0) {
                sample_index--;
                return true;
            }
            return false;
        }

        public bool navigate_right () {
            int n = 0;
            input_table.foreach ((cell) => {
                n++;
            });
            if (sample_index < n - 1) {
                sample_index++;
                return true;
            }
            return false;
        }

        private void find_focused_cell () {
            int i = 0;
            input_table.foreach ((cell) => {
                if (cell.has_focus) {
                    sample_index = i;
                }
                i++;
            });
        }

        public bool reset_sample () {
            input_table.foreach ((cell) => {
                input_table.remove (cell);
                sample_index = -1;
            });
            return true;
        }

        public uint get_cardinality () {
            List<string> samples = new List<string> ();
            input_table.foreach ((cell) => {
                Gtk.Entry cell_e = (Gtk.Entry)cell;
                if (cell_e.get_text () != "" && cell_e.get_text () != null)
                samples.append (cell_e.get_text ());
            });
            return samples.length ();
        }

        public string get_samples () {
            List<string> samples = new List<string> ();
            string sample_text = "";
            input_table.foreach ((cell) => {
                Gtk.Entry cell_e = (Gtk.Entry)cell;
                if (cell_e.get_text () != "" && cell_e.get_text () != null)
                samples.append (cell_e.get_text ());
            });
            samples.foreach ((cell_data) => {
                sample_text = sample_text.concat (cell_data, ",");
            });
            sample_text = sample_text.slice (0, sample_text.len () - 1);
            return sample_text;
        }
    }
}