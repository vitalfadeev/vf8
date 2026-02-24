module vf.gui.page_.strings;


struct
Strings {
    string[ubyte.max+1] s;
    pragma (msg, "strings.size: ", s.sizeof);  // 4_080

    void
    _init () {
        s[0] = "    ";
        s[1] = "";
        s[2] = "";
        s[3] = "󰁹󰁹󰁹󰁹";
        s[4] = "";  // //        󰕾 󰕿 󰖀 󰝞 󰝟 󰖁 󰝝 󱄠 󱄡
        s[5] = "󰀝󰀝󰀝󰀝";
    }
}
