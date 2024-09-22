
# A class to work around transofrming more user friendly language to ansi color codes
class Rainbow::Ansi_converter
    property color : String

    # The constructor of the class, it's only parameter is the color mode, it can be "truecolor", "256color", "8color" or "mono"
    # if the color mode is not any of the previous ones it will default to "mono"
    def initialize(color : String)
        @color = color
    end
    
    # A method to transform rgb values to ansi color codes
    # it has 4 parameters, r, g and b are the rgb values, is_bg is a boolean that tells if the color is a background color, if not passed it defaults to false
    # it returns a string with the ansi color code
    # The ANSI code depends on the color mode
    def rgb_to_ansi(r : Int32, g : Int32, b : Int32, is_bg : Bool = false) : String
        case @color
        when "truecolor"
            return is_bg ? "\e[48;2;#{r};#{g};#{b}m" : "\e[38;2;#{r};#{g};#{b}m"
        when "256color"
            color256 = 16 + (r // 256) * 36 + (g // 256) * 6 + (b // 256)
            return is_bg ? "\e[48;5;#{color256}m" : "\e[38;5;#{color256}m"
        when "8color"
            r = (r > 128) ? 1 : 0
            g = (g > 128) ? 1 : 0
            b = (b > 128) ? 1 : 0
            return is_bg ? "\e[#{40+r+b+g}m" : "\e[#{30+r+b+g}m"
        else
            return ""
        end
    end

    # A method to transform a word to ansi color codes
    # it has 2 parameters, word is the word to transform, is_bg is a boolean that tells if the color is a background color, if not passed it defaults to false
    def word_to_ansi(word : String, is_bg : Bool = false) : String
        case word
        when "black"
            return rgb_to_ansi(0, 0, 0, is_bg)
        when "red"
            return rgb_to_ansi(255, 0, 0, is_bg)
        when "green"
            return rgb_to_ansi(0, 255, 0, is_bg)
        when "yellow"
            return rgb_to_ansi(255, 255, 0, is_bg)
        when "blue"
            return rgb_to_ansi(0, 0, 255, is_bg)
        when "magenta"
            return rgb_to_ansi(255, 0, 255, is_bg)
        when "cyan"
            return rgb_to_ansi(0, 255, 255, is_bg)
        when "white"
            return rgb_to_ansi(255, 255, 255, is_bg)
        when "orange"
            return rgb_to_ansi(255, 140, 0, is_bg)
        when "pink"
            return rgb_to_ansi(255, 192, 203, is_bg)
        when "purple"
            return rgb_to_ansi(128, 0, 128, is_bg)
        when "brown"
            return rgb_to_ansi(100, 42, 42, is_bg)
        when "gray"
            return rgb_to_ansi(128, 128, 128, is_bg)
        when "light_gray"
            return rgb_to_ansi(192, 192, 192, is_bg)
        when "light_red"
            return rgb_to_ansi(255, 150, 150, is_bg)
        when "light_green"
            return rgb_to_ansi(150, 250, 150, is_bg)
        when "light_yellow"
            return rgb_to_ansi(255, 255, 150, is_bg)
        when "light_blue"
            return rgb_to_ansi(150, 150, 255, is_bg)
        when "light_magenta"
            return rgb_to_ansi(255, 150, 255, is_bg)
        when "light_cyan"
            return rgb_to_ansi(150, 255, 255, is_bg)
        when "light_orange"
            return rgb_to_ansi(255, 140, 80, is_bg)
        when "light_pink"
            return rgb_to_ansi(255, 200, 220, is_bg)
        when "light_purple"
            return rgb_to_ansi(200, 120, 200, is_bg)
        when "light_brown"
            return rgb_to_ansi(130, 60, 60, is_bg)
        when "default"
            return is_bg ? "\e[49m" : "\e[39m"
        else
            return ""
        end
    end

    # The main function of the class, it takes a string and changes the 'rainbow' syntax to ansi color codes
    # it has one parameter, text is the string to transform
    # it returns the transformed string with ansi color codes when needed
    def convert(text : String, return_to_default : Bool = true) : String
        ansi_text = ""
        color_word = ""
        rgb = [0, 0, 0]
        is_bg = false
        take_on_count = true
        if text.includes?("#|")
            text.split("#|").each do |word|
                if take_on_count && word.includes?("|")
                    color_word = word.split("|")[0].strip
                    if color_word.starts_with?("bg_")
                        is_bg = true
                        color_word = color_word[3..-1].strip
                    else
                        is_bg = false
                    end
                    if color_word.starts_with?("rgb")
                        rgb = color_word.split("|")[0][3..-1].split(",").map(&.strip.to_i)
                        
                        ansi_text += rgb_to_ansi(rgb[0], rgb[1], rgb[2], is_bg)
                    else
                        ansi_text += word_to_ansi(color_word, is_bg)
                    end
                    ansi_text += word.split("|")[1]
                elsif word.ends_with?("/") && take_on_count
                    ansi_text += word
                elsif take_on_count
                    ansi_text += word
                    take_on_count = true
                else
                    ansi_text += "#|#{word}"
                    take_on_count = true
                end
                if ansi_text.ends_with?("/")
                    ansi_text = ansi_text[0..-2]
                end
                if word.ends_with?("/")
                    take_on_count = false
                end
            end
        else
            ansi_text = text
        end
        return return_to_default ? ansi_text + "\e[0m" : ansi_text
    end
end
