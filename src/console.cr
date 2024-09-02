require "./tty"
require "./con_conf"
require "./ansi_converter"
require "./renderable"

# A class to communicate with the terminal
# It includes a method to print text in the console and a method to print a "rule"(horizontal line) in the terminal
# It uses the tty linux command to get the terminal file
class Rainbow::Console
    property tty_file : String
    property con_conf : Rainbow::CONCOF
    property ansi_parser : Rainbow::Ansi_converter
    property fily : File

    # Initializes the Console class
    # It gets the tty file, the console configuration, and the ansi parser
    def initialize
        @tty_file = Rainbow::TTY.new.get_tty_file
        @con_conf = Rainbow::CONCOF.new
        @fily = File.new(@tty_file, mode: "w+", blocking: false)
        @ansi_parser = Rainbow::Ansi_converter.new(@con_conf.color)
    end

    # Prints text in the console
    # Can also print Rainbow::Renderable objects
    # - object : The text or Rainbow::Renderable object to print
    # - ending : The ending of the text, by default is a newline
    def print(object : String | Rainbow::Renderable, ending : String = "\n")
        if object.is_a?(Rainbow::Renderable)
            text = object.render(self)
        else
            text = object
        end
        @fily.print(@ansi_parser.convert(text) + ending)
        @fily.flush
    end

    # Prints a "rule"(horizontal line) in the terminal
    # - fg_color : The foreground color of the rule
    # - bg_color : The background color of the rule
    def rule(fg_color : String = "white", bg_color : String | Nil = nil)
        rule_ansi = ""
        if bg_color.to_s != ""
            rule_ansi += @ansi_parser.convert("#|bg_#{bg_color.to_s}|", return_to_default = false)
        end
        rule_ansi += @ansi_parser.convert("#|#{fg_color}|" + ("━"*@con_conf.cols))
        self.print(rule_ansi)
    end

    # Clears the WHOLE terminal
    def clear
        @fily.print("\e[2J\e[H")
        @fily.flush
    end
end
        