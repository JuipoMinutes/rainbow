require "./renderable"
require "./con_conf"

# A class to align text depending on the console width
class Rainbow::Align < Rainbow::Renderable
    property text : String
    property align : String

    # Initializes the Align class with the text to align and the alignment
    # - text : The text to align
    # - align : The alignment of the text, the options are:
    # * "left" : The text will be aligned to the left
    # * "center" : The text will be centered
    # * "right" : The text will be aligned to the right
    # If other word is passed it will be aligned to the left
    def initialize(text : String, align : String = "left")
        @text = text
        @align = align
    end

    # Renders the text depending on the alignment
    def render(console : Rainbow::Console) : String
        width = console.con_conf.cols
        text_copy = @text
        if text_copy.includes?("\n")
            lines = text_copy.split("\n")
        else
            lines = [text_copy]
        end
        bg_code = "#|bg_default|"
        code = "#|default|"
        to_return = ""
        lines.each do |line|
            words = ""
            words2 = code + bg_code
            coder = ""
            idx_to_finish = -1
            to_count = true
            deleted_chars = 0
            line.size.times do |i|
                words2 += line[i]
                if line[i] == '#'
                    if line[i+1] == '|' && line[i-1] != '/'
                        to_count = false
                        idx_to_finish=line[i+2..-1].index!("|")+i+2

                        coder = line[i..i+idx_to_finish]
                        if coder.includes?("bg_")
                            bg_code = coder
                        else
                            code = coder
                        end
                    elsif line[i-1] == '/'
                        deleted_chars += 1
                    end
                end

                if to_count
                    words += line[i]
                end
                if i == idx_to_finish
                    to_count = true
                end
            end
            case @align
            when "center"
                to_return += (" " * ((width - (words.size - deleted_chars)) // 2)) + words2
            when "right"
                to_return += (" " * (width - (words.size - deleted_chars))) + words2
            else
                to_return += words2
            end
            to_return += "\n"
        end
        return to_return
    end

end