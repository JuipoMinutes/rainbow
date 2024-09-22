# A class to get the terminal configuration, these configurations can be forced
class Rainbow::CONCOF
    property color : String
    property cols : Int32
    property rows : Int32
    property term : String

    # The constructor gets it's configs trough environment variables and stty
    def initialize
        @color = ENV["COLORTERM"]
        if @color.starts_with?("truecolor") || @color.starts_with?("24bit") || @color.starts_with?("24-bit")
            @color = "truecolor"
        elsif @color.starts_with?("256color") || @color.starts_with?("256-color")
            @color = "256color"
        elsif @color.starts_with?("8color") || @color.starts_with?("8-color")
            @color = "8color"
        else
            @color = "mono"
        end
        @rows, @cols = get_term_size
        @term = ENV["TERM"]
    end

    # Get's the terminal size trough stty, if it can not use stty make's a RuntimeError
    def get_term_size : Array(Int32)
        output = IO::Memory.new

        run = Process.run(
            "stty",
            ["size"],
            input: STDIN,
            output: output,
            error: STDERR
        )
        RuntimeError.new("There was an error while trying to comunicate with the terminal") unless run.success?
        output.rewind
        output.gets.to_s.split(" ").map(&.to_i)
    end
end
        