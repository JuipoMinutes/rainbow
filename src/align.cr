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
        text_size = @text.size
        rainbow_codes = @text.scan(/#(\|[^|]+\|)/).each do |code|
            text_size -= code.to_s.size
        end
        case @align
        when "right"
            return " " * (console.con_conf.cols - text_size) + @text
        when "center"
            return " " * ((console.con_conf.cols - text_size) // 2) + @text + (" " * ((console.con_conf.cols - text_size) // 2))
        else
            return @text + (" " * (console.con_conf.cols - text_size))
        end 

    end
end