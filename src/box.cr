require "./renderable"
require "./con_conf"

# A class to create a box with text inside
class Rainbow::Box < Rainbow::Renderable

    property text : String
    property v_size : Int32
    property h_size : Int32
    property anchor : String
    property title : String
    property box_color : String
    property bg_color : String

    # The constructor of the class
    # it has the following parameters:
    # - text : String : The text that will be inside the box, if it is too long it will be cut
    # - h_size : Int32 : The horizontal size of the box
    # * if it is -1 it will take the console width
    # - v_size : Int32 : The vertical size of the box
    # * if it is -1 it will take the console height
    # - anchor : String : The anchor of the text inside the box the options are:
    # * "center" : The text will be centered in the box
    # * "n" : The text will be aligned to the north of the box
    # * "nw" : The text will be aligned to the north west of the box
    # * "ne" : The text will be aligned to the north east of the box
    # * "w" : The text will be aligned to the west of the box
    # * "e" : The text will be aligned to the east of the box
    # * "s" : The text will be aligned to the south of the box
    # * "sw" : The text will be aligned to the south west of the box
    # * "se" : The text will be aligned to the south east of the box
    # - title : String : The title of the box if it is too long it will be cut
    # - box_color : String : The color of the box, e.g. "red", "green", "blue", "yellow", "rgb55,67,123", etc.
    # - bg_color : String : The background color of the box, e.g. "red", "green", "rgb78,190,32", "yellow", "cyan", etc.
    def initialize(text : String, h_size : Int32 = 20, v_size : Int32 = 5, anchor : String = "center", title : String = "", box_color : String = "default", bg_color : String = "default")
        @text = text
        @v_size = v_size
        @h_size = h_size
        @anchor = anchor
        @title = title
        @box_color = box_color
        @bg_color = bg_color
    end

    # A method to create the basic box array, this array will be used to render the box
    # it returns an array of strings with the box shape on the borders and the title
    def basic_box_array : Array(String)
        char_list = [] of String
        @v_size.times do |i|
            @h_size.times do |j|
                char_list << " "
            end
        end
        char_list[0] = "#|#{@box_color}|#|bg_#{@bg_color}|┌"
        char_list[@h_size - 1] = "┐"
        char_list[(@v_size - 1) * @h_size] = "#|#{@box_color}|└"
        char_list[@v_size * @h_size - 1] = "┘"
        (@h_size - 2).times do |i|
            char_list[i + 1] = "─"
            char_list[(@v_size - 1) * @h_size + i + 1] = "─"
        end
        (@v_size - 2).times do |i|
            char_list[(i + 1) * @h_size] = "#|#{@box_color}|│#|#default|"
            char_list[(i + 1) * @h_size + @h_size - 1] = "#|#{@box_color}|│"
        end
        title = "#{@title}"
        titleidx = (@h_size - title.size) // 2
        if title.size < @h_size - 2
            title.size.times do |i|
                char_list[titleidx + i] = title[i].to_s
            end
        else
            title = title[0..@h_size - 6] + "..."
            titleidx = 1
            title.size.times do |i|
                char_list[titleidx + i] = title[i].to_s
            end
        end
        return char_list
    end
    
    # A method to put the text inside the box, it returns an array of strings with the text inside the box
    # it has the following parameters:
    # - char_list : Array(String) : The array done by the basic_box_array method
    # - text : String : The text that will be inside the box, if it is too long it will be cut
    # - y_calc : String : The calculation of the y position of the text inside the box, the options are:
    # * "m" : The text will be centered in the box vertically
    # * "n" : The text will be aligned to the north of the box vertically
    # * "s" : The text will be aligned to the south of the box vertically
    def put_text_on_box(char_list : Array(String), text : String, y_calc : String = "m") : Array(String)
        xchar = 0
        ychar = 0
        rainbow_codes = [] of String
        codes_indexes = [0]
        text.scan(/#(\|[^|]+\|)/).each do |code|
            rainbow_codes << code.to_s
            codei = text.index(code.to_s)
            if codei.nil?
                codei = 0
            end
            codes_indexes << codei - rainbow_codes[-1].size
            text = text.gsub(code.to_s, "")
        end
        if rainbow_codes.size == 0
            rainbow_codes = ["#|default|"]
        end

        if text.includes?("\n")
            text = text.split("\n")
        else
            text = [text]
        end

        lines = [] of String
        text.size.times do |i|
            if text[i].size > @h_size - 2
                index = 0
                while index < text[i].size
                    lines << text[i][index..index + @h_size - 4].strip
                    index += @h_size - 3
                end
            else
                lines << text[i]
            end
        end
        if lines.size > @v_size - 2
            lines = lines[0..@v_size - 3]
            lines[-1] = lines[-1][0..-5] + "..."
        end
        case y_calc
        when "m"
            ychar = ((@v_size - 2)-lines.size)//2
        when "n"
            ychar = 1
        when "s"
            ychar = (@v_size - 1)-lines.size
        end

        text_index = 0
        used_codes = ""
        lines.each do |line|
            xchar = yield line
            ixr = 0
            line.size.times do |i|
                char_list[(ychar * @h_size) + xchar + i] = line[i].to_s
                if i == 0
                    char_list[(ychar * @h_size) + xchar + i] = used_codes + char_list[(ychar * @h_size) + xchar + i]
                end
                while codes_indexes.includes?(text_index)
                    char_list[(ychar * @h_size) + xchar + i] = rainbow_codes[codes_indexes.index(text_index).to_s.to_i] + char_list[(ychar * @h_size) + xchar + i]
                    used_codes += rainbow_codes[codes_indexes.index(text_index).to_s.to_i]
                    codes_indexes.delete_at(codes_indexes.index(text_index).to_s.to_i)
                end
                text_index += 1
                ixr = i
            end
            char_list[(ychar * @h_size) + xchar + ixr + 1] += "#|#{@box_color}|#|bg_#{@bg_color}|"
            ychar += 1
        end
        return char_list 
    end

        
    # A method to render the box, it returns a string with the box rendered
    def render(console : Rainbow::Console) : String
        if @v_size == -1
            @v_size = console.con_conf.rows
        end
        if @h_size == -1
            @h_size = console.con_conf.cols
        end
        char_list = self.basic_box_array
        case @anchor
        when "center"
            char_list = put_text_on_box(char_list, @text, "m"){|lin| ((@h_size -2) - lin.size)//2}
        when "n"
            char_list = put_text_on_box(char_list, @text, "n"){|lin| ((@h_size -2) - lin.size)//2}
        when "nw"
            char_list = put_text_on_box(char_list, @text, "n"){|lin| 1}
        when "ne"
            char_list = put_text_on_box(char_list, @text, "n"){|lin| (@h_size -1) - lin.size}
        when "w"
            char_list = put_text_on_box(char_list, @text, "m"){|lin| 1}
        when "e"
            char_list = put_text_on_box(char_list, @text, "m"){|lin| (@h_size -1) - lin.size}
        when "se"
            char_list = put_text_on_box(char_list, @text, "s"){|lin| (@h_size -1) - lin.size}
        when "s"
            char_list = put_text_on_box(char_list, @text, "s"){|lin| ((@h_size -2) - lin.size)//2}
        when "sw"
            char_list = put_text_on_box(char_list, @text, "s"){|lin| 1}
        end


            
        to_return = ""
        char_list.each_with_index do |char, i|
            to_return += char
            if (i + 1) % @h_size == 0
                to_return += "\n"
            end
        end
        return to_return
                
    end
end