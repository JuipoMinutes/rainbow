require "./renderable"
require "./con_conf"

# A class to add padding to text
class Rainbow::Padding < Rainbow::Renderable
    property text : String
    property h_padding : Int32
    property v_padding : Int32
    property align : String

    # Initializes the Padding class with the text to add padding
    # - text : The text to add padding
    # - h_padding : The horizontal padding to add to the text
    # - v_padding : The vertical padding to add to the text
    # - align : The alignment of the text, the options are:
    # * "left" : The text will be aligned to the left
    # * "center" : The text will be centered
    # * "right" : The text will be aligned to the right
    # If other word is passed it will be aligned to the left
    # - Example:
    #  Rainbow::Padding.new("Hello World", 5, 2, "center")
    def initialize(text : String, h_padding : Int32 = 0, v_padding : Int32 = 0, align : String = "left")
        @text = text
        @h_padding = h_padding
        @v_padding = v_padding
        @align = align
    end

    def render(console : Rainbow::Console) : String
        text_size = @text.size
        to_return = ""
        rainbow_codes = @text.scan(/#(\|[^|]+\|)/).each do |code|
            text_size -= code.to_s.size
        end
        to_return += "\n" * @v_padding
        case @align
        when "right"
            to_return +=  " " * (console.con_conf.cols - text_size - @h_padding) + @text
        when "center"
            to_return +=  (" " * ((console.con_conf.cols - text_size) // 2)) + @text + (" " * ((console.con_conf.cols - text_size) // 2))
        else
            to_return += (" " * h_padding) + @text + (" " * (console.con_conf.cols - text_size - @h_padding))
        end 
        to_return += "\n" * @v_padding
        return to_return
    end
end
