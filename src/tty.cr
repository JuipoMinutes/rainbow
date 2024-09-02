

# A class to get the tty file path
# it only has one method that returns the tty file path
class Rainbow::TTY

    # The tty file path getter, it returns the tty file path on String format, if it fails it raises a RuntimeError
    # Has no parameters
    def get_tty_file : String
        
        output = IO::Memory.new

        run = Process.run(
            "tty",
            input: STDIN,
            output: output,
            error: STDERR
        )
        RuntimeError.new("There was an error while trying to comunicate with the terminal") unless run.success?
        output.rewind
        output.gets.to_s
    end
end
    
    